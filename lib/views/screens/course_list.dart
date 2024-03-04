import 'dart:convert';
import 'dart:math';

import 'package:go_router/go_router.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/enums.dart';
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
  // static const String _jsonStringCourse1 =
  //     '{"courseId": "c1","courseTitle": "Test Course 1","courseSummary": "Test Course 1 summary","courseDescription": "Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description Test Course 1 description ","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionSummary": "Section 2 summary","sectionElements": []},{"sectionId": "section3","sectionTitle": "Section 3","sectionSummary": "Section 3 summary","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  static const String _jsonStringCourse1 = '''
{
  "courseId": "webdev101",
  "courseTitle": "Introduction to Web Development",
  "courseSummary": "Learn the fundamentals of web development, covering HTML, CSS, and JavaScript.",
  "courseDescription": "This course provides a comprehensive introduction to web development, starting from the basics of HTML, moving on to styling with CSS, and adding interactivity with JavaScript. By the end of this course, you will have built your own responsive website from scratch.",
  "courseSections": [
    {
      "sectionId": "section1",
      "sectionTitle": "HTML Basics",
      "sectionSummary": "Understanding the structure of web pages with HTML.",
      "sectionElements": [
        {
          "elementId": "htmlIntro",
          "elementType": "html",
          "elementTitle": "What is HTML?",
          "elementContent": "<html><body><p>HTML stands for HyperText Markup Language. It's the standard markup language for documents designed to be displayed in a web browser.</p></body></html>"
        },
        {
          "elementId": "htmlTags",
          "elementType": "question",
          "elementTitle": "Basic HTML Tags Quiz",
          "elementContent": [
            {
              "questionId": "htmlTagQ1",
              "questionType": "singleSelectionQuestion",
              "questionText": "Which tag is used to define a hyperlink in HTML?",
              "questionAnswers": [
                {"answerId": "aTag", "answerText": "<a>", "answerCorrect": true},
                {"answerId": "hrefTag", "answerText": "<href>", "answerCorrect": false},
                {"answerId": "linkTag", "answerText": "<link>", "answerCorrect": false}
              ]
            }
          ]
        }
      ]
    },
    {
      "sectionId": "cssStyling",
      "sectionTitle": "Styling with CSS",
      "sectionSummary": "Learn how to style and layout web pages using CSS.",
      "sectionElements": [
        {
          "elementId": "cssIntro",
          "elementType": "html",
          "elementTitle": "Introduction to CSS",
          "elementContent": "<html><body><p>CSS stands for Cascading Style Sheets. It describes how HTML elements are to be displayed on screen, paper, or in other media.</p></body></html>"
        }
      ]
    },
    {
      "sectionId": "javascriptInteractivity",
      "sectionTitle": "Adding Interactivity with JavaScript",
      "sectionSummary": "Make your web pages interactive with JavaScript.",
      "sectionElements": []
    }
  ]
}
''';

  // static const String _jsonStringCourse2 =
  //     '{"courseId": "c2","courseTitle": "Test Course 2","courseSummary": "Test Course 2 summary","courseDescription": "Test Course 2 description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionSummary": "Section 2 summary","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  static const String _jsonStringCourse2 = '''
{
  "courseId": "jsAdvanced102",
  "courseTitle": "Advanced JavaScript Techniques",
  "courseSummary": "Dive deeper into JavaScript with advanced concepts and techniques.",
  "courseDescription": "This course takes you beyond the basics of JavaScript, exploring advanced topics such as closures, asynchronous programming, and object-oriented concepts. You'll work on projects that require you to solve complex problems using JavaScript.",
  "courseSections": [
    {
      "sectionId": "section1",
      "sectionTitle": "Asynchronous Programming",
      "sectionSummary": "Understanding asynchronous operations in JavaScript.",
      "sectionElements": [
        {
          "elementId": "promises",
          "elementType": "html",
          "elementTitle": "Working with Promises",
          "elementContent": "<html><body><p>Promises are used to handle asynchronous operations in JavaScript. They represent a value that may be available now, in the future, or never.</p></body></html>"
        }
      ]
    },
    {
      "sectionId": "objectOrientedJS",
      "sectionTitle": "Object-Oriented JavaScript",
      "sectionSummary": "Explore object-oriented programming concepts in JavaScript.",
      "sectionElements": []
    }
  ]
}
''';

  static const String _jsonStringExam1 =
      // '{"courseId": "webdev101","examId": "e1","examTitle": "Test Exam 1","examSummary": "Test Exam 1 summary","examDescription": "Test Exam 1 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
      '{"courseId":"webdev101","examId":"e1","examTitle":"Introduction to HTML & CSS","examSummary":"Foundations of Web Development","examDescription":"This exam tests your basic understanding of HTML and CSS, essential for creating web pages.","examPassMark":2,"examEstimatedTime":3,"examSections":[{"sectionId":"section1","sectionTitle":"HTML Basics","sectionSummary":"Understanding HTML tags and structure","sectionElements":[{"elementId":"question1","elementType":"question","elementTitle":"Identifying HTML Tags","elementContent":[{"questionId":"ssq1","questionType":"singleSelectionQuestion","questionText":"Which tag is used to define a paragraph in HTML?","questionAnswers":[{"answerId":"ssq1a1","answerText":"<div>","answerCorrect":false},{"answerId":"ssq1a2","answerText":"<p>","answerCorrect":true},{"answerId":"ssq1a3","answerText":"<span>","answerCorrect":false}]}]},{"elementId":"question2","elementType":"question","elementTitle":"CSS Selectors","elementContent":[{"questionId":"msq1","questionType":"multipleSelectionQuestion","questionText":"Which of the following are valid CSS selectors?","questionAnswers":[{"answerId":"msq1a1","answerText":".classSelector","answerCorrect":true},{"answerId":"msq1a2","answerText":"#idSelector","answerCorrect":true},{"answerId":"msq1a3","answerText":"@keyframes","answerCorrect":false},{"answerId":"msq1a4","answerText":"<style>","answerCorrect":false}]}]}]}]}';

  static const String _jsonStringExam2 =
      // '{"courseId": "jsAdvanced102","examId": "e2","examTitle": "Test Exam 2","examSummary": "Test Exam 2 summary","examDescription": "Test Exam 2 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
      '{"courseId":"jsAdvanced102","examId":"e2","examTitle":"JavaScript Fundamentals","examSummary":"Core Concepts & Syntax","examDescription":"Evaluate your understanding of JavaScript\'s fundamental concepts, including variables, data types, and basic functions.","examPassMark":2,"examEstimatedTime":3,"examSections":[{"sectionId":"section1","sectionTitle":"Variables and Data Types","sectionSummary":"Understanding different data types and how to work with variables.","sectionElements":[{"elementId":"question1","elementType":"question","elementTitle":"Defining Variables","elementContent":[{"questionId":"ssq1","questionType":"singleSelectionQuestion","questionText":"Which keyword is used to declare a block-scoped variable?","questionAnswers":[{"answerId":"ssq1a1","answerText":"var","answerCorrect":false},{"answerId":"ssq1a2","answerText":"let","answerCorrect":true},{"answerId":"ssq1a3","answerText":"const","answerCorrect":false}]}]}]}]}';
  static const String _jsonStringExam3 =
      // '{"courseId": "jsAdvanced102","examId": "e3","examTitle": "Test Exam 3","examSummary": "Test Exam 3 summary","examDescription": "Test Exam 3 description","examPassMark": 2,"examEstimatedTime": 3,"examSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "questiongroup1","elementType": "question","elementTitle": "Multiple questions","elementContent": [{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq2a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq2a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq2a3","answerText": "A3","answerCorrect": false}]},{"questionId": "msq2","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq2a1","answerText": "A1","answerCorrect": true},{"answerId": "msq2a2","answerText": "A2","answerCorrect": false},{"answerId": "msq2a3","answerText": "A3","answerCorrect": false},{"answerId": "msq2a4","answerText": "A4","answerCorrect": true}]}]}]}]}';
      '{"courseId":"jsAdvanced102","examId":"e3","examTitle":"Advanced JavaScript Techniques","examSummary":"Exploring Advanced Topics","examDescription":"Dive deeper into JavaScript with questions on asynchronous programming, closures, and advanced functions.","examPassMark":2,"examEstimatedTime":3,"examSections":[{"sectionId":"section1","sectionTitle":"Advanced Functions","sectionSummary":"Mastering closures and callbacks","sectionElements":[{"elementId":"question1","elementType":"question","elementTitle":"Understanding Closures","elementContent":[{"questionId":"ssq1","questionType":"singleSelectionQuestion","questionText":"Which of the following best describes a closure in JavaScript?","questionAnswers":[{"answerId":"ssq1a1","answerText":"A function bundled together with its lexical environment","answerCorrect":true},{"answerId":"ssq1a2","answerText":"An advanced array method","answerCorrect":false},{"answerId":"ssq1a3","answerText":"A feature specific to ES6","answerCorrect":false}]}]},{"elementId":"question2","elementType":"question","elementTitle":"Asynchronous Programming","elementContent":[{"questionId":"msq1","questionType":"multipleSelectionQuestion","questionText":"Which features are used for asynchronous programming in JavaScript?","questionAnswers":[{"answerId":"msq1a1","answerText":"Promises","answerCorrect":true},{"answerId":"msq1a2","answerText":"setTimeout","answerCorrect":true},{"answerId":"msq1a3","answerText":"for loops","answerCorrect":false},{"answerId":"msq1a4","answerText":"Arrays","answerCorrect":false}]}]}]}]}';

  final List<String> _jsonCourses = [_jsonStringCourse1, _jsonStringCourse2];
  final List<String> _jsonExams = [
    _jsonStringExam1,
    _jsonStringExam2,
    _jsonStringExam3
  ];

  final Map<String, Course> _courses = {};
  final Map<String, Map<String, Exam>> _exams = {};

  @override
  void initState() {
    super.initState();

    for (String jsonCourse in _jsonCourses) {
      Map<String, dynamic> courseMap =
          jsonDecode(jsonCourse) as Map<String, dynamic>;
      Course course = Course.fromJson(courseMap);

      _courses[course.courseId] = course;
      _exams[course.courseId] = {};
    }

    for (String jsonExam in _jsonExams) {
      Map<String, dynamic> examMap =
          jsonDecode(jsonExam) as Map<String, dynamic>;
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader(title: 'Courses'),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width * 0.04,
                    MediaQuery.of(context).size.width * 0.006,
                    MediaQuery.of(context).size.width * 0.04,
                  MediaQuery.of(context).size.width * 0.015,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: getTertiaryColor1()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: ListView(
                    shrinkWrap: true,
                    children: [..._getWidgets()],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getWidgets() {
    final List<Widget> contentWidgets = [];

    _courses.forEach((courseId, course) {
      contentWidgets.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HoverableSectionContainer(
              onHover: (bool) {},
              // color: Theme.of(context).scaffoldBackgroundColor,
              // elevation: 4,
              child: CustomExpansionTile(
                  titleWidget: Text(course.courseTitle),
                  contentWidget: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(course.courseDescription,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey.shade700)),
                      ),
                    ),
                    _separator,
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              // decoration: getExpansionTileBoxDecoration(),
                              child: ElevatedButton(
                                  onPressed: () => context.goNamed(
                                          NamedRoutes.course.name,
                                          pathParameters: {
                                            NamedRoutePathParameters
                                                .courseId.name: course.courseId
                                          }),
                                  child: courseId == 'webdev101'
                                      ? Text('Resume Course')
                                      : Text('Start Course'))),
                        )),
                    _separator,
                    Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 1,
                      child: CustomExpansionTile(
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Sections (1/${course.courseSections.length} Completed)"),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomLinearProgressIndicator(
                                    value:
                                        (1 / course.courseSections.length ?? 3),
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: primary!),
                              ),
                            ],
                          ),
                          contentWidget: [..._getCourseSections(courseId)]),
                    ),
                    // _separator,
                    Card(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      elevation: 1,
                      child: CustomExpansionTile(
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Exams (0/${_exams[courseId]?.length} Completed)"),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomLinearProgressIndicator(
                                    value: (0 / _exams[courseId]!.length ?? 3),
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: primary!),
                              ),
                            ],
                          ),
                          contentWidget: [..._getExamWidgets(courseId)]),
                    )
                  ]),
            ),
          )
        ],
      ));
    });

    return contentWidgets;
  }

  List<Widget> _getCourseSections(String courseId) {
    final List<Widget> contentWidgets = [];

    for (Section section in _courses[courseId]!.courseSections) {
      contentWidgets.add(Container(
          child: Row(children: [
        section.sectionId == 'section1'
            ? IconButton(
                icon: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
                padding: const EdgeInsets.only(left: 15.0),
                onPressed: section.sectionTitle == 'Section 1'
                    ? () => print(section.sectionTitle)
                    : null,
                // style: getIconButtonStyleTransparent(),
              )
            : IconButton(
                icon: Icon(
                  Icons.pending,
                  color: Colors.orange,
                ),
                padding: const EdgeInsets.only(left: 15.0),
                onPressed: section.sectionTitle == 'Section 1'
                    ? () => print(section.sectionTitle)
                    : null,
                // style: getIconButtonStyleTransparent(),
              ),
        Flexible(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  section.sectionTitle,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  section.sectionSummary,
                  style: TextStyle(fontSize: 13),
                ),
                onTap: section.sectionTitle == 'Section 1'
                    ? () => print(section.sectionTitle)
                    : null,
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),
            ],
          ),
        )
      ])));
      // contentWidgets.add(_separator);
    }

    return contentWidgets;
  }

  List<Widget> _getExamWidgets(String courseId) {
    final List<Widget> contentWidgets = [];
    final Map<String, Exam>? courseExams = _exams[courseId];

    courseExams?.forEach((examId, exam) {
      contentWidgets.add(Container(
          // decoration: getExpansionTileBoxDecoration(),
          child: ExpansionTile(
        title: Text(
          exam.examTitle,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        subtitle: Row(children: [
          Text(
            exam.examSummary,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          Text("Estimated time: ${exam.examEstimatedTime}",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text("Pass mark: ${exam.examPassMark}",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700))
        ]),
        childrenPadding: const EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 25.0),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(exam.examDescription,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          ),
          _separator,
          Align(
              alignment: Alignment.centerLeft,
              child: Container(
                  // decoration: getExpansionTileBoxDecoration(),
                  child: ElevatedButton(
                      onPressed: () => print(exam.examTitle),
                      child: examId == 'e1'
                          ? Text('Retake Exam')
                          : Text('Start Exam')))),
        ],
      )));
      contentWidgets.add(_separator);
    });

    return contentWidgets;
  }
}
