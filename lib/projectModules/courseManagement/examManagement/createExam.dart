import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

import '../coursesProvider.dart';

Future<bool> createCourseExam(
    {required CoursesProvider coursesProvider,
    required Course course,
    required NewExam exam}) async {
  try {
    int index = course.exams.length + 1;

    exam.index = index;
    Map<String, dynamic> examMap = exam.toMap();

    examMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection("exams")
        .doc(exam.title)
        .set(examMap);

    coursesProvider.addExamsToCourse(course, [exam]);

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .update({'examsCount': index});

    print("Exam creation successful");
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> createModuleExam(
    {required CoursesProvider coursesProvider,
    required Course course,
    required Module module,
    required NewExam exam}) async {
  try {
    int index = 1;
    try {
      index = module.exams!.length + 1;
    } catch (e) {
      index = 1;
    }
    exam.index = index;
    Map<String, dynamic> examMap = exam.toMap();

    examMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('courses')
        .doc(course.name)
        .collection("modules")
        .doc(module.title)
        .collection("exams")
        .doc(exam.title)
        .set(examMap);

    coursesProvider.addExamsToCourseModule(module, [exam]);
    print("Module Exam creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
