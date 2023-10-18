import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

Future<bool> createCourseExam(
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

Future<bool> createModuleExam(
    {required CoursesProvider coursesProvider,
    required int courseIndex,
    required int moduleIndex,
    required NewExam exam}) async {
  try {
    Course course = coursesProvider.allCourses[courseIndex];
    Module module = course.modules![moduleIndex];
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

    coursesProvider.addExamsToCourse(courseIndex, [exam]);
    print("Module Exam creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
