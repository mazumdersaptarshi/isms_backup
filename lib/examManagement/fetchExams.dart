import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

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
    coursesProvider.addExamsToCourse(courseIndex, course.exams!);
    print("FCN Courses ${course.hashCode}, has exams: ${course.exams}");
  }
}
