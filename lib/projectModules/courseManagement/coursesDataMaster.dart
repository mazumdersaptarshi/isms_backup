// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:isms/models/adminConsoleModels/coursesDetails.dart';

import 'package:isms/models/course.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';

class CoursesDataMaster {
  CoursesDataMaster({
    required this.coursesProvider,
  }) {
  }
  final CoursesProvider coursesProvider;
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static final CollectionReference _coursesRef = db.collection("courses");
  static final CollectionReference _adminConsoleCoursesRef = db
      .collection('adminconsole')
      .doc('allcourses')
      .collection("allCourseItems");

  CollectionReference get coursesRef => _coursesRef;

  Future<bool> createCourse({required Course course}) async {
    // TODO fail if there is already a course with this name
    try {
      // add the new course into the database
      Map<String, dynamic> courseMap = course.toMap();
      courseMap['createdAt'] = DateTime.now();
      await _coursesRef.doc(course.name).set(courseMap);

      debugPrint("Course creation successful");
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createCourseAdminConsole(
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
