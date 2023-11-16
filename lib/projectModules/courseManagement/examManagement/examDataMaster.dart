// ignore_for_file: file_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';

class ExamDataMaster extends CoursesDataMaster {
  ExamDataMaster({
    required this.coursesProvider,
    required this.course,
  }) : super() {
    _courseRef = CoursesDataMaster.coursesRef.doc(course.name);
    _examsRef = _courseRef.collection("exams");
  }
  final CoursesProvider coursesProvider;
  final Course course;
  late final DocumentReference _courseRef;
  late final CollectionReference _examsRef;

  Future<bool> createCourseExam({required NewExam exam}) async {
    // TODO fail if there is already an exam with this title
    try {
      exam.index = course.examsCount + 1;

      // add the new exam into the database
      Map<String, dynamic> examMap = exam.toMap();
      examMap['createdAt'] = DateTime.now();
      await _examsRef.doc(exam.title).set(examMap);
      await _courseRef.update({'examsCount': exam.index});

      // add the new exam in the local cache
      course.addExam(exam);
      course.examsCount = exam.index;

      coursesProvider.notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<NewExam>> _fetchExams() async {
    // this delay can be enabled to test the loading code
    //await Future.delayed(const Duration(milliseconds: 1000));

    QuerySnapshot examsListSnapshot = await _examsRef.orderBy("index").get();
    if (course.exams == null) {
      course.exams = [];
    } else {
      course.exams!.clear();
    }
    for (var element in examsListSnapshot.docs) {
      NewExam exam = NewExam.fromMap(element.data() as Map<String, dynamic>);
      course.addExam(exam);
    }
    if (course.exams!.length != course.examsCount) {
      log("fetched ${course.exams!.length} course exams, was expecting ${course.examsCount}");
    }
    return course.exams!;
  }

  Future<List<NewExam>> get exams async {
    if (course.exams != null) {
      return course.exams!;
    } else {
      try {
        return _fetchExams();
      } catch (e) {
        course.exams = null;
        return [];
      }
    }
  }
}
