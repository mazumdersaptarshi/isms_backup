// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:logging/logging.dart';

class CoursesDataMaster extends ChangeNotifier {
  CoursesDataMaster({
    required this.coursesProvider,
  });
  final CoursesProvider coursesProvider;
  static FirebaseFirestore db = FirebaseFirestore.instance;
  static final CollectionReference _coursesRef = db.collection("courses");
  static final CollectionReference _adminConsoleCoursesRef = db
      .collection('adminconsole')
      .doc('allcourses')
      .collection("allCourseItems");

  final Logger logger = Logger("Courses");

  CollectionReference get coursesRef => _coursesRef;

  Future<bool> createCourse({required Course course}) async {
    // TODO fail if there is already a course with this name
    try {
      // add the new course into the database
      Map<String, dynamic> courseMap = course.toMap();
      courseMap['createdAt'] = DateTime.now();
      await _coursesRef.doc(course.name).set(courseMap);

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

      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> listenToCourseUpdates(
      CoursesProvider coursesProvider) async {
    Stream<QuerySnapshot> coursesStream =
        _coursesRef.orderBy("createdAt").snapshots();
    coursesStream.listen((snapshot) async {
      //await Future.delayed(const Duration(milliseconds: 5000));
      coursesProvider.allCourses.clear();

      for (var element in snapshot.docs) {
        Map<String, dynamic> elementMap =
            element.data() as Map<String, dynamic>;
        Course course = Course.fromMap(elementMap);
        coursesProvider.addCourse(course);
      }

      coursesProvider.notifyListeners();
    });
  }

  static Future<List<dynamic>> getCurrentCourse(
      {String? identifier, String? module}) async {
    List<Map<String, dynamic>> currentCourseDetails = [];
    DocumentSnapshot courseDocumentSnapshot =
        await db.collection('courses').doc('${identifier}').get();
    if (courseDocumentSnapshot.exists) {
      Map<String, dynamic> courseOverviewData =
          courseDocumentSnapshot.data() as Map<String, dynamic>;
      currentCourseDetails.add({'courseOverview': courseOverviewData});
    }
    if (module != null) {
      DocumentSnapshot moduleDocumentSnapshot = await db
          .collection('courses')
          .doc('${identifier}')
          .collection('modules')
          .doc(module)
          .get();
      if (moduleDocumentSnapshot.exists) {
        Map<String, dynamic> courseModuleOverviewData =
            moduleDocumentSnapshot.data() as Map<String, dynamic>;
        currentCourseDetails.add({'currentModule': courseModuleOverviewData});
      }
    }
    return currentCourseDetails;
  }
}
