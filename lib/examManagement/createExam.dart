import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

Future<bool> createExam(
    {required CoursesProvider coursesProvider,
    required int courseIndex,
    required NewExam exam}) async {
  try {
    Course course = coursesProvider.allCourses[courseIndex];
    int index = 1;
    try {
      index = coursesProvider.allCourses[courseIndex].exams!.length + 1;
    } catch (e) {
      index = 1;
    }
    exam.index = index;
    Map<String, dynamic> examMap = exam.toMap();

    examMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection("exams")
        .doc(exam.title)
        .set(examMap);

    coursesProvider.addExamsToCourse(courseIndex, [exam]);
    print("Exam creation successful");
    return true;
  } catch (e) {
    return false;
  }
}