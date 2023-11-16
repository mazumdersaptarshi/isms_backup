// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/foundation.dart';

class CoursesDetails {
  String course_id;
  String course_name;
  List<dynamic>? course_completed;
  List<dynamic>? course_started;

  CoursesDetails(
      {required this.course_id,
      required this.course_name,
      this.course_started,
      this.course_completed});

  Map<String, dynamic> toMap() {
    debugPrint('Here');
    return {
      'course_id': course_id,
      'course_name': course_name,
    };
  }

  factory CoursesDetails.fromMap(Map<String, dynamic> map) {
    debugPrint('CourseStartedddd ${map['course_started']}');

    return CoursesDetails(
      course_id: map['course_ID'] ?? 'n/a',
      course_name: map['course_name'] ?? 'n/a',

      course_started: map['course_started'] ?? [],
      course_completed: map['course_completed'] ?? [],
    );
  }
}
