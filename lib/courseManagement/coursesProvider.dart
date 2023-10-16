import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/slide.dart';

enum CoursesFetchStatus { idle, initiated, fetched }

class CoursesProvider with ChangeNotifier {
  List<Course> allCourses = [];
  bool isCoursesStreamFetched = false;

  CoursesFetchStatus coursesFetchStatus = CoursesFetchStatus.idle;

  CoursesProvider() {
    if (coursesFetchStatus != CoursesFetchStatus.initiated) getAllCourses();
  }

  @override
  notifyListeners() {
    if (kDebugMode) {
      print("Notifying listeners");
    }
    super.notifyListeners();
  }

  getAllCourses({bool isNotifyListener = true}) async {
    isCoursesStreamFetched = true;
    coursesFetchStatus = CoursesFetchStatus.initiated;
    print("FETCHING COURSES STREAMMMM");

    Stream<QuerySnapshot>? coursesStream = FirebaseFirestore.instance
        .collection('courses')
        .orderBy("createdAt")
        .snapshots();
    coursesStream!.listen((snapshot) async {
      final List<Course> courses = [];

      snapshot.docs.forEach((element) {
        Map<String, dynamic> elementMap =
            element.data() as Map<String, dynamic>;
        if (elementMap['name'] != "exam") {
          Course courseItem = Course.fromMap(elementMap);
          courses.add(courseItem);
        }
      });
      allCourses.clear();
      allCourses.addAll(courses);

      if (isNotifyListener) notifyListeners();

      coursesFetchStatus = CoursesFetchStatus.initiated;
    });
  }

  addModulesToCourse(int courseIndex, List<Module> modules) {
    // if (allCourses[courseIndex].modules == null)

    try {
      allCourses[courseIndex].modules?.addAll(modules);
    } catch (e) {
      allCourses[courseIndex].modules = [];
      allCourses[courseIndex].modules?.addAll(modules);
    }

    notifyListeners();
  }

  addSlidesToModules(int courseIndex, int moduleIndex, List<Slide> slides) {
    try {
      allCourses[courseIndex].modules![moduleIndex].slides!.addAll(slides);
    } catch (e) {
      allCourses[courseIndex].modules![moduleIndex].slides = [];
      allCourses[courseIndex].modules![moduleIndex].slides!.addAll(slides);
    }

    notifyListeners();
  }

  addExamsToCourse(int courseIndex, List<NewExam> exams) {
    try {
      allCourses[courseIndex].exams?.addAll(exams);
    } catch (e) {
      allCourses[courseIndex].exams = [];
      allCourses[courseIndex].exams?.addAll(exams);
    }

    notifyListeners();
  }

  Future<void> addHardcodedExam(
      String courseId, Map<String, dynamic> examData) async {
    // 1) Getting reference to the specific course document by using the provided courseId.
    DocumentReference courseDocRef =
        FirebaseFirestore.instance.collection('courses').doc(courseId);

    // 2) Check if 'exams' subcollection exists, and if not, create it.
    CollectionReference examsCollection = courseDocRef.collection('exams');

    // Get all documents from the 'exams' subcollection to determine the next index.
    QuerySnapshot examDocs = await examsCollection.get();
    int nextExamIndex = examDocs.docs.length + 1;

    // 3) Inside the new document, store all the required fields and values.
    examsCollection.doc('exam_$nextExamIndex').set(examData);

    notifyListeners(); // Notify listeners after adding the data.
  }
}
