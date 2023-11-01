import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';

import '../coursesProvider.dart';

Future fetchExams(
    {required Course course, required CoursesProvider coursesProvider}) async {
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
    // coursesProvider.fetchExamsToCourse(courseIndex, course.exams!);
    print("FCN Courses ${course.hashCode}, has exams: ${course.exams}");
  }
}

Future fetchModuleExams(
    {required Course course,
    required CoursesProvider coursesProvider,
    required Module module}) async {
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
    // coursesProvider.addExamsToCourseModule(
    //     courseIndex, moduleIndex, module.exams!);
    print("FCN Module ${module.hashCode}, has exams: ${module.exams}");
  }
}
