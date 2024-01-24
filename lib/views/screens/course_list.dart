import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/exam.dart';
import 'package:isms/models/course/section.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  /// SizedBox for adding consistent spacing between widgets
  static const SizedBox _separator = SizedBox(height: 20);
  static const EdgeInsets _padding = EdgeInsets.all(25.0);

  // Data structures containing course content populated in initState() then not changed
  /// Course data represented as a JSON [String]
  static const String _jsonStringCourse1 =
      '{"courseId": "c1","courseTitle": "Test Course 1","courseDescription": "Test Course 1 description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  static const String _jsonStringCourse2 =
      '{"courseId": "c2","courseTitle": "Test Course 2","courseDescription": "Test Course 2 description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';

  static const String _jsonStringExam1 =
      '{"courseId": "c1","examId": "e1","examTitle": "Test Exam 1","examDescription": "Test Exam 1 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
  static const String _jsonStringExam2 =
      '{"courseId": "c2","examId": "e2","examTitle": "Test Exam 2","examDescription": "Test Exam 2 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
  static const String _jsonStringExam3 =
      '{"courseId": "c2","examId": "e3","examTitle": "Test Exam 3","examDescription": "Test Exam 3 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';

  final List<String> _jsonCourses = [_jsonStringCourse1, _jsonStringCourse2];
  final List<String> _jsonExams = [_jsonStringExam1, _jsonStringExam2, _jsonStringExam3];

  final Map<String, Course> _courses = {};
  final Map<String, Exam> _exams = {};

  /// Ordered [List] of section IDs to allow lookup by section index
  final List<String> _courseSections = [];

  /// [Map] of widgets for all course sections keyed by section ID
  final Map<String, dynamic> _courseWidgets = {};

  @override
  void initState() {
    super.initState();

    for (String jsonCourse in _jsonCourses) {
      Map<String, dynamic> courseMap = jsonDecode(jsonCourse) as Map<String, dynamic>;
      Course course = Course.fromJson(courseMap);

      _courses[course.courseId] = course;
    }

    for (String jsonExam in _jsonExams) {
      Map<String, dynamic> examMap = jsonDecode(jsonExam) as Map<String, dynamic>;
      Exam exam = Exam.fromJson(examMap);

      _exams[exam.examId] = exam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      // drawer: const SidebarWidget(),
      // drawerScrimColor: Colors.transparent,
      // body: SingleChildScrollView(
      body: Column(
        children: [..._getWidgets()],
      ),
      // ),
    );
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getWidgets() {
    final List<Widget> contentWidgets = [];

    // Add widgets for all elements in the current course section, conditionally building different widget types
    // depending on `elementType` from the JSON
    _courses.forEach((courseId, course) {
      contentWidgets.add(Container(
          padding: _padding,
          child: Container(
              decoration: getExpansionTileBoxDecoration(),
              child: ExpansionTile(
                title: Text(course.courseTitle),
                subtitle: Text(course.courseDescription),
                childrenPadding: _padding,
                children: [
                  ElevatedButton(onPressed: () => {print(course.courseTitle)}, child: Text('Start Course')),
                  _separator,
                  Container(
                      decoration: getExpansionTileBoxDecoration(),
                      child: ExpansionTile(
                          title: Text("Sections (0/${course.courseSections.length} Completed)"),
                          childrenPadding: _padding,
                          children: [..._getCourseSections(course.courseId)])),
                  _separator,
                  Container(
                      decoration: getExpansionTileBoxDecoration(),
                      child: ExpansionTile(
                          title: Text("Exams"),
                          childrenPadding: _padding,
                          children: [..._getExamWidgets(course.courseId)]))
                ],
              ))));
    });

    return contentWidgets;
  }

  List<Widget> _getCourseSections(String courseId) {
    final List<Widget> contentWidgets = [];

    for (Section section in _courses[courseId]!.courseSections) {
      contentWidgets.add(Container(
          decoration: getExpansionTileBoxDecoration(),
          child: ListTile(
            title: Text(
              section.sectionTitle,
              // style: const TextStyle(color: Colors.white),
            ),
            onTap: () => {print(section.sectionTitle)},
          )));
      contentWidgets.add(_separator);
    }

    return contentWidgets;
  }

  List<Widget> _getExamWidgets(String courseId) {
    final List<Widget> contentWidgets = [];

    _exams.forEach((examId, exam) {
      if (exam.courseId == courseId) {
        contentWidgets.add(Container(
            decoration: getExpansionTileBoxDecoration(),
            child: ListTile(
              title: Text(exam.examTitle),
              subtitle: Text(exam.examDescription),
              onTap: () => {print(exam.examTitle)},
            )));
        contentWidgets.add(_separator);
      }
    });

    return contentWidgets;
  }
}
