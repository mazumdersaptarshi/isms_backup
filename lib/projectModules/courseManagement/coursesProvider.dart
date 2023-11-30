// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:isms/models/course.dart';

import 'coursesDataMaster.dart';

class CoursesProvider with ChangeNotifier {
  CoursesProvider() {
    CoursesDataMaster.listenToCourseUpdates(this);
  }

  final List<Course> _allCourses = [];

  List<Course> get allCourses => _allCourses;

  addCourse(Course course) {
    _allCourses.add(course);
  }

  static Future<List<dynamic>> getCurrentCourse(
      {String? identifier, String? module}) async {
    return await CoursesDataMaster.getCurrentCourse(
        identifier: identifier, module: module);
  }
}
