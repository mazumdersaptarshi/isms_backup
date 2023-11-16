// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

Map<String, dynamic> getCourseCompletedPercentage(
    Map<String, dynamic> courseItem, CoursesProvider coursesProvider) {
  double courseCompletionPercentage = 0;
  int noOfExams = 0;
  bool isValid = false;
  debugPrint('Enrolled CoursesDropdown');

  int modulesCount = 0;

  for (int i = 0; i < coursesProvider.allCourses.length; i++) {
    var element = coursesProvider.allCourses[i];

    if (element.name == courseItem["course_name"]) {
      modulesCount = element.modulesCount;
      noOfExams = element.examsCount;
      isValid = true;
    }
  }

  int modulesCompletedCount = courseItem["modules_completed"] != null
      ? courseItem["modules_completed"].length
      : 0;
  int examsCompletedCount = courseItem["exams_completed"] != null
      ? courseItem["exams_completed"].length
      : 0;
  if (isValid) {
    courseCompletionPercentage = (modulesCompletedCount + examsCompletedCount) /
        (modulesCount + noOfExams);
  }

  return {
    "isValid": isValid,
    "courseCompletionPercentage": courseCompletionPercentage,
    "noOfExams": noOfExams
  };
}
