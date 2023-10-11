import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
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

    Stream<QuerySnapshot>? coursesStream =
        FirebaseFirestore.instance.collection('courses').snapshots();
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
    allCourses[courseIndex].modules![moduleIndex].slides = [];
    allCourses[courseIndex].modules![moduleIndex].slides?.addAll(slides);
    notifyListeners();
  }
}
