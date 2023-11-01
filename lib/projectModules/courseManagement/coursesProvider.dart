import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/slide.dart';

enum CoursesFetchStatus { idle, initiated, fetched }

class CoursesProvider with ChangeNotifier {
  List<Course> _allCourses = [];

  List<Course> get allCourses => _allCourses;
  bool isCoursesStreamFetched = false;

  CoursesFetchStatus _coursesFetchStatus = CoursesFetchStatus.idle;

  CoursesProvider() {
    if (_coursesFetchStatus != CoursesFetchStatus.initiated) getAllCourses();
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
    _coursesFetchStatus = CoursesFetchStatus.initiated;
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
      _allCourses.clear();
      _allCourses.addAll(courses);

      if (isNotifyListener) notifyListeners();

      _coursesFetchStatus = CoursesFetchStatus.initiated;
    });
  }

  addModulesToCourse(Course course, List<Module> modules) {
    course.modules.addAll(modules);
    notifyListeners();
  }

  addSlidesToModules(Module module, List<Slide> slides) {
    try {
      module.slides!.addAll(slides);
    } catch (e) {
      module.slides = [];
      module.slides!.addAll(slides);
    }

    notifyListeners();
  }

  addExamsToCourse(Course course, List<NewExam> exams) {
    course.exams.addAll(exams);

    notifyListeners();
  }

  fetchExamsToCourse(int courseIndex, List<NewExam> exams) {
    _allCourses[courseIndex].exams = exams;

    notifyListeners();
  }

  addExamsToCourseModule(Module module, List<NewExam> exams) {
    try {
      module.exams?.addAll(exams);
    } catch (e) {
      module.exams = [];
      module.exams?.addAll(exams);
    }

    notifyListeners();
  }
}
