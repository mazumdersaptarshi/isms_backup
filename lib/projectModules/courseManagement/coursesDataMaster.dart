// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:isms/models/adminConsoleModels/coursesDetails.dart';

import 'package:isms/models/course.dart';
import 'coursesProvider.dart';

class CoursesDataMaster {
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static final CollectionReference _coursesRef = db.collection("courses");
  static final CollectionReference _adminConsoleCoursesRef = db
      .collection('adminconsole')
      .doc('allcourses')
      .collection("allCourseItems");

  static CollectionReference get coursesRef => _coursesRef;

  static Future<bool> createCourse({required Course course}) async {
    try {
      Map<String, dynamic> courseMap = course.toMap();

      courseMap['createdAt'] = DateTime.now();

      await _coursesRef.doc(course.name).set(courseMap);

      debugPrint("Course creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createCourseAdminConsole(
      {required CoursesDetails coursesDetails}) async {
    try {
      Map<String, dynamic> courseMap = coursesDetails.toMap();

      courseMap['createdAt'] = DateTime.now();

      await _adminConsoleCoursesRef
          .doc(coursesDetails.course_name)
          .set(courseMap);

      debugPrint("Course creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> listenToCourseUpdates(CoursesProvider coursesProvider) async {
    Stream<QuerySnapshot> coursesStream = _coursesRef
        .orderBy("createdAt")
        .snapshots();
    coursesStream.listen((snapshot) async {
      //await Future.delayed(const Duration(milliseconds: 5000));
      coursesProvider.allCourses.clear();

      snapshot.docs.forEach((element) {
        Map<String, dynamic> elementMap =
            element.data() as Map<String, dynamic>;
        Course course = Course.fromMap(elementMap);
        coursesProvider.addCourse(course);
      });

      coursesProvider.notifyListeners();
    });
  }
}
