import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ExamProvider extends ChangeNotifier {
  static dynamic _allExams = {};
  String localGetURL3 = 'http://127.0.0.1:5000/get3?flag=';

  /// Converts a JSON to a type of _JsonMap (which is Map<String, dynamic> type)
  static Future<Map<String, dynamic>> parseJsonAsMap() async {
    String jsonString = await rootBundle.loadString('assets/data/all_courses/exams.json');

    return json.decode(jsonString);
  }

  Future<dynamic> getExam({required String examId}) async {
    Map<String, dynamic> params = {
      "examID": examId,
    };
    String jsonStringParams = jsonEncode(params);
    String encodedJsonStringParams = Uri.encodeComponent(jsonStringParams);
    http.Response response = await http
        .get(Uri.parse(localGetURL3 + 'exam_content' + '&param1=$examId' + '&params=$encodedJsonStringParams'));
    print(response.body);
  }

// static Future<dynamic> getAllExams() async {
//   Map<String, dynamic> jsonCoursesData = await parseJsonAsMap();
//   _allExams = jsonCoursesData['examsList']; //for now we are using JSON data
//
//   /* For now we have alll exams in a list called 'examsList' but when we fecth the data from
//   * Firestore we will return a map of all exams. */
//
//   return _allExams;
// }

  /// Searches for Course details by ID from Local storage and returns the details. For now, we get this data from JSON
// static Map<String, dynamic> getExamByIDLocal({String? examId}) {
//   Map<String, dynamic> fetchedExam =
//       {}; //this variable will store the course that needs to be fetched from the local storage
//
//   //for now we are using JSON data
//   if (_allExams.isEmpty) {
//     _allExams = getAllExams();
//   }
//   // print(_allExams);
//   // List examsList = _allExams['examsList']; // Gets the List of courses
//   for (Map<String, dynamic> exam in _allExams) {
//     if (exam['examId'] == examId) {
//       fetchedExam = exam;
//     }
//   }
//   return fetchedExam; //returns the course fetched by Id
// }

  ///This function returns a  List of all the exams associated with the given course ID
// static Future<List> getExamsByCourseId({String? courseId}) async {
//   List examsForCourse = [];
//   if (_allExams.isEmpty) {
//     _allExams = await getAllExams();
//   }
//   for (var exam in _allExams) {
//     if (exam['courseId'] == courseId) {
//       examsForCourse.add(exam);
//     }
//   }
//   return examsForCourse;
// }

// static Future<int> getExamsCountForCourse({String? courseId}) async {
//   List examsForCourse = [];
//   if (_allExams.isEmpty) {
//     _allExams = await getAllExams();
//   }
//   for (var exam in _allExams) {
//     if (exam['courseId'] == courseId) {
//       examsForCourse.add(exam);
//     }
//   }
//   return examsForCourse.length;
// }
}
