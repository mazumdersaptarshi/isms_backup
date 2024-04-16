import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:isms/models/course/enums.dart';
import 'package:isms/models/course/exam_full.dart';
import 'package:isms/models/course/section_full.dart';
import 'package:isms/models/course/element.dart' as ExamElement;

class ExamProvider extends ChangeNotifier {
  static dynamic _allExams = {};
  String localGetURL3 = 'http://127.0.0.1:5000/get3?flag=';

  /// Converts a JSON to a type of _JsonMap (which is Map<String, dynamic> type)
  static Future<Map<String, dynamic>> parseJsonAsMap() async {
    String jsonString = await rootBundle.loadString('assets/data/all_courses/exams.json');

    return json.decode(jsonString);
  }

  Future<dynamic> getExamContent({required String examId}) async {
    Map<String, dynamic> params = {
      "examID": examId,
    };
    String jsonStringParams = jsonEncode(params);
    String encodedJsonStringParams = Uri.encodeComponent(jsonStringParams);
    http.Response response = await http
        .get(Uri.parse(localGetURL3 + 'exam_content' + '&param1=$examId' + '&params=$encodedJsonStringParams'));
    List<dynamic> jsonResponse = jsonDecode(response.body);

    print(jsonResponse[0][0]);

    List<SectionFull> sections = [];
    jsonResponse.first.first['contentJdoc']['examSections'].forEach((element) {
      List<ExamElement.Element> sectionElements = [];
      element['sectionElements'].forEach((element) {
        sectionElements.add(ExamElement.Element(
          elementId: element['elementId'],
          elementType: element['elementType'],
          elementContent: element['elementContent'],
          elementTitle: element['elementTitle'],
        ));
      });
      SectionFull sf = SectionFull(
        sectionElements: sectionElements,
        sectionId: element['sectionId'],
        sectionSummary: element['sectionSummary'],
        sectionTitle: element['sectionTitle'],
      );
      sections.add(sf);
    });

    print(sections);
    ExamFull ef = ExamFull(
      courseId: jsonResponse.first.first['contentJdoc']['courseId'],
      examId: jsonResponse.first.first['contentJdoc']['examId'],
      examVersion: jsonResponse.first.first['contentVersion'],
      examTitle: jsonResponse.first.first['contentJdoc']['examTitle'],
      examSummary: jsonResponse.first.first['contentJdoc']['examSummary'],
      examDescription: jsonResponse.first.first['contentJdoc']['examDescription'],
      examPassMark: jsonResponse.first.first['passMark'],
      examEstimatedCompletionTime: jsonResponse.first.first['estimatedCompletionTime'],
      examSections: sections,
    );
    // ExamFull examFull = ExamFull.fromJson(jsonResponse.first.first['contentJdoc']);
    print(ef);
    return ef;
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
