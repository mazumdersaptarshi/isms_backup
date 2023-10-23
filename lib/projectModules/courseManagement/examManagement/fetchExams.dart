import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

import '../coursesProvider.dart';

Future fetchExams(
    {required int courseIndex,
    required CoursesProvider coursesProvider}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  if (course.exams != null && course.exams!.isNotEmpty) {
    return;
  } else {
    QuerySnapshot examsListSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection('exams')
        .orderBy("index")
        .get();
    course.exams = [];
    examsListSnapshot.docs.forEach((element) {
      // print(element.data());
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);

      course.exams?.add(exam);
    });
    coursesProvider.fetchExamsToCourse(courseIndex, course.exams!);
    print("FCN Courses ${course.hashCode}, has exams: ${course.exams}");
  }
}

Future fetchModuleExams(
    {required int courseIndex,
    required CoursesProvider coursesProvider,
    required int moduleIndex}) async {
  Course course = coursesProvider.allCourses[courseIndex];
  Module module = course.modules![moduleIndex];
  if (module.exams != null && module.exams!.isNotEmpty) {
    return;
  } else {
    QuerySnapshot examsListSnapshot = await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection('modules')
        .doc(module.title)
        .collection('exams')
        .orderBy("index")
        .get();
    module.exams = [];
    examsListSnapshot.docs.forEach((element) {
      // print(element.data());
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);

      module.exams?.add(exam);
    });
    coursesProvider.addExamsToCourseModule(
        courseIndex, moduleIndex, module.exams!);
    print("FCN Module ${module.hashCode}, has exams: ${module.exams}");
  }
}
