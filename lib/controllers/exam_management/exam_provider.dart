import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class ExamProvider extends ChangeNotifier {
  static dynamic _allExams = {};

  /// Converts a JSON to a type of _JsonMap (which is Map<String, dynamic> type)
  static Future<Map<String, dynamic>> parseJsonAsMap() async {
    String jsonString = await rootBundle.loadString('assets/data/all_courses/exams.json');

    return json.decode(jsonString);
  }

  /// Searches for Course details by ID from Local storage and returns the details. For now, we get this data from JSON
  static Map<String, dynamic> getExamByIDLocal({String? examId}) {
    Map<String, dynamic> fetchedExam =
        {}; //this variable will store the course that needs to be fetched from the local storage

    //for now we are using JSON data
    if (_allExams.isEmpty) {
      _allExams = getAllExams();
    }
    // print(_allExams);
    // List examsList = _allExams['examsList']; // Gets the List of courses
    for (Map<String, dynamic> exam in _allExams) {
      if (exam['examId'] == examId) {
        fetchedExam = exam;
      }
    }
    return fetchedExam; //returns the course fetched by Id
  }

  static Future<dynamic> getAllExams() async {
    _allExams = await parseJsonAsMap(); //for now we are using JSON data

    /* For now we have alll exams in a list called 'examsList' but when we fecth the data from
    * Firestore we will return a map of all exams. */

    return _allExams['examsList'];
  }

  ///This function returns a  List of all the exams associated with the given course ID
  static Future<List> getExamsByCourseId({String? courseId}) async {
    List examsForCourse = [];
    if (_allExams.isEmpty) {
      _allExams = await getAllExams();
    }
    for (var exam in _allExams) {
      if (exam['courseId'] == courseId) {
        examsForCourse.add(exam);
      }
    }
    return examsForCourse;
  }

  static Future<int> getExamsCountForCourse({String? courseId}) async {
    List examsForCourse = [];
    if (_allExams.isEmpty) {
      _allExams = await getAllExams();
    }
    for (var exam in _allExams) {
      if (exam['courseId'] == courseId) {
        examsForCourse.add(exam);
      }
    }
    return examsForCourse.length ?? 0;
  }
}
