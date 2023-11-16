// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:isms/models/course.dart';

import 'coursesDataMaster.dart';

class CoursesProvider with ChangeNotifier {
  final List<Course> _allCourses = [];

  List<Course> get allCourses => _allCourses;

  CoursesProvider() {
    CoursesDataMaster.listenToCourseUpdates(this);
  }

  addCourse(Course course) {
    _allCourses.add(course);
  }
}
