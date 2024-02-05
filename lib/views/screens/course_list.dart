import 'dart:convert';

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/exam.dart';
import 'package:isms/models/course/section.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

import 'home_screen.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  /// SizedBox for adding consistent spacing between widgets
  static const SizedBox _separator = SizedBox(height: 20);

  // Data structures containing course content populated in initState() then not changed
  /// Course data represented as a JSON [String]
  static const String _jsonStringCourse1 =
      '{"courseId": "c1","courseTitle": "Test Course 1","courseSummary": "Test Course 1 summary","courseDescription": "Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description ","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionSummary": "Section 2 summary","sectionElements": []},{"sectionId": "section3","sectionTitle": "Section 3","sectionSummary": "Section 3 summary","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  static const String _jsonStringCourse2 =
      '{"courseId": "c2","courseTitle": "Test Course 2","courseSummary": "Test Course 2 summary","courseDescription": "Test Course 2 description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionSummary": "Section 2 summary","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';

  static const String _jsonStringExam1 =
      '{"courseId": "c1","examId": "e1","examTitle": "Test Exam 1","examSummary": "Test Exam 1 summary","examDescription": "Test Exam 1 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
  static const String _jsonStringExam2 =
      '{"courseId": "c2","examId": "e2","examTitle": "Test Exam 2","examSummary": "Test Exam 2 summary","examDescription": "Test Exam 2 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
  static const String _jsonStringExam3 =
      '{"courseId": "c2","examId": "e3","examTitle": "Test Exam 3","examSummary": "Test Exam 3 summary","examDescription": "Test Exam 3 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';

  final List<String> _jsonCourses = [_jsonStringCourse1, _jsonStringCourse2];
  final List<String> _jsonExams = [_jsonStringExam1, _jsonStringExam2, _jsonStringExam3];

  final Map<String, Course> _courses = {};
  final Map<String, Map<String, Exam>> _exams = {};

  @override
  void initState() {
    super.initState();

    for (String jsonCourse in _jsonCourses) {
      Map<String, dynamic> courseMap = jsonDecode(jsonCourse) as Map<String, dynamic>;
      Course course = Course.fromJson(courseMap);

      _courses[course.courseId] = course;
      _exams[course.courseId] = {};
    }

    for (String jsonExam in _jsonExams) {
      Map<String, dynamic> examMap = jsonDecode(jsonExam) as Map<String, dynamic>;
      Exam exam = Exam.fromJson(examMap);

      _exams[exam.courseId]?[exam.examId] = exam;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      // body: SingleChildScrollView(
      body: ListView(
        children: [..._getWidgets()],
      ),
      // ),
    );
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getWidgets() {
    final List<Widget> contentWidgets = [];

    _courses.forEach((courseId, course) {
      contentWidgets.add(Container(
          padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 0.0),
          child: Container(
              decoration: getExpansionTileBoxDecoration(),
              child: ExpansionTile(
                title: Text(course.courseTitle),
                subtitle: Text(course.courseSummary),
                childrenPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(course.courseDescription, style: const TextStyle(color: Colors.white)),
                  ),
                  _separator,
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          decoration: getExpansionTileBoxDecoration(),
                          child: ElevatedButton(
                              onPressed: () => context.goNamed(NamedRoutes.course.name,
                                  pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId}),
                              child: courseId == 'c1' ? Text('Resume Course') : Text('Start Course')))),
                  _separator,
                  Container(
                      decoration: getExpansionTileBoxDecoration(),
                      child: ExpansionTile(
                          title: Text("Sections (1/${course.courseSections.length} Completed)"),
                          childrenPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                          children: [..._getCourseSections(courseId)])),
                  _separator,
                  Container(
                      decoration: getExpansionTileBoxDecoration(),
                      child: ExpansionTile(
                          title: Text("Exams (0/${_exams[courseId]?.length} Completed)"),
                          childrenPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
                          children: [..._getExamWidgets(courseId)]))
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
          child: Row(children: [
            section.sectionTitle == 'Section 1'
                ? IconButton(
                    icon: Icon(Icons.check_circle_outline, color: Colors.green, shadows: [getIconBoxShadow()]),
                    padding: const EdgeInsets.only(left: 15.0),
                    onPressed: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
                    style: getIconButtonStyleTransparent(),
                  )
                : IconButton(
                    icon: Icon(Icons.highlight_off, color: Colors.red, shadows: [getIconBoxShadow()]),
                    padding: const EdgeInsets.only(left: 15.0),
                    onPressed: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
                    style: getIconButtonStyleTransparent(),
                  ),
            Flexible(
                child: ListTile(
              title: Text(section.sectionTitle),
              subtitle: Text(section.sectionSummary),
              onTap: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
            ))
          ])));
      contentWidgets.add(_separator);
    }

    return contentWidgets;
  }

  List<Widget> _getExamWidgets(String courseId) {
    final List<Widget> contentWidgets = [];
    final Map<String, Exam>? courseExams = _exams[courseId];

    courseExams?.forEach((examId, exam) {
      contentWidgets.add(Container(
          decoration: getExpansionTileBoxDecoration(),
          child: ExpansionTile(
            title: Text(exam.examTitle),
            subtitle: Row(children: [
              Text(exam.examSummary),
              Text("Estimated time: ${exam.examEstimatedTime}"),
              Text("Pass mark: ${exam.examPassMark}")
            ]),
            childrenPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(exam.examDescription),
              ),
              _separator,
              Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      decoration: getExpansionTileBoxDecoration(),
                      child: ElevatedButton(
                          onPressed: () => print(exam.examTitle),
                          child: examId == 'e1' ? Text('Retake Exam') : Text('Start Exam')))),
            ],
          )));
      contentWidgets.add(_separator);
    });

    return contentWidgets;
  }
}
