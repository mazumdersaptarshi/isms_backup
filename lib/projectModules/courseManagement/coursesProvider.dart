// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/slide.dart';

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
}
