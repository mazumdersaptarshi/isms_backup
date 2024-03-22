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
import 'package:http/http.dart' as http;
import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/exam.dart';
import 'package:isms/models/course/section.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

import '../../utilities/platform_check.dart';
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
  final List<String> _jsonExams = [_jsonStringExam1, _jsonStringExam2, _jsonStringExam3];

  // final Map<String, Course> _courses = {};
  final Map<String, dynamic> _courses = {};
  final Map<String, Map<String, Exam>> _exams = {};

  static const String query = r'''
  WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = {0}
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = {0}
), highest_course_versions AS (
	SELECT DISTINCT ON (course_id)
			course_id,
			content_version	FROM course_versions
	WHERE course_id IN (SELECT course_id FROM assigned_courses)
	ORDER BY course_id ASC, content_version DESC
), section_completion AS (
	SELECT hcv.course_id,
			hcv.content_version,
			ucp.completed_sections
	FROM highest_course_versions hcv
	LEFT JOIN user_course_progress ucp
	ON (hcv.course_id = ucp.course_id AND hcv.content_version = ucp.course_learning_version)
), course_sections AS (
	SELECT cc.course_id,
			cc.content_version,
			jsonb_build_object(
				'sectionId', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionId'::jsonpath),
				'sectionTitle', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionTitle'::jsonpath),
				'sectionSummary', jsonb_path_query(cc.content_jdoc, '$.courseSections[*].sectionSummary'::jsonpath)
			) AS section_metadata
	FROM course_content cc
	INNER JOIN highest_course_versions hcv
	ON (cc.course_id = hcv.course_id AND cc.content_version = hcv.content_version)
	WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
), course_sections_and_completion AS (
	SELECT cs.course_id,
			cs.content_version,
			jsonb_set(cs.section_metadata, '{sectionCompleted}', to_jsonb(COALESCE((SELECT cs.section_metadata->>'sectionId' = ANY(sc.completed_sections)), false))) AS section_details
	FROM course_sections cs
	LEFT JOIN section_completion sc
	ON (cs.course_id = sc.course_id AND cs.content_version = sc.content_version)
	GROUP BY cs.course_id,
			cs.content_version,
			cs.section_metadata,
			sc.completed_sections
	ORDER BY cs.course_id
), assigned_exams AS (
	SELECT course_id,
			exam_id
	FROM course_exam_relationships
	WHERE enabled = true
	AND course_id IN (SELECT course_id FROM assigned_courses)
), exam_assignment_deadlines AS (
	SELECT cer.exam_id,
			uca.completion_deadline,
			uca.completion_tracking_period_start
	FROM user_course_assignments uca
	INNER JOIN course_exam_relationships cer
	ON (uca.course_id = cer.course_id)
	WHERE uca.enabled = true
	AND cer.enabled = true
), highest_exam_versions AS (
	SELECT DISTINCT ON (exam_id)
			exam_id,
			content_version,
			pass_mark,
			estimated_completion_time
	FROM exam_versions
	WHERE exam_id IN (SELECT exam_id FROM assigned_exams)
	ORDER BY exam_id ASC, content_version DESC
), exam_details AS (
	SELECT ec.exam_id,
			ec.content_version,
			ec.content_jdoc->>'examTitle' AS exam_title,
			ec.content_jdoc->>'examSummary' AS exam_summary,
			ec.content_jdoc->>'examDescription' AS exam_description,
			hev.pass_mark,
			hev.estimated_completion_time
	FROM exam_content ec
	INNER JOIN highest_exam_versions hev
	ON (ec.exam_id = hev.exam_id AND ec.content_version = hev.content_version)
	WHERE ec.content_language = (SELECT preferred_language FROM user_preferred_language)
), exam_completion AS (
	SELECT DISTINCT ON (uea.exam_id)
			uea.exam_id,
			uea.exam_version,
			uea.passed
	FROM user_exam_attempts uea
	INNER JOIN highest_exam_versions hev
	ON (uea.exam_id = hev.exam_id AND uea.exam_version = hev.content_version)
	INNER JOIN exam_assignment_deadlines ead
	ON (uea.exam_id = ead.exam_id)
	WHERE uea.user_id = {0}
    AND uea.passed = true
	AND uea.finished_at <= ead.completion_deadline
	AND uea.finished_at >= ead.completion_tracking_period_start
	ORDER BY uea.exam_id ASC, uea.exam_version DESC
), exam_details_and_completion AS (
	SELECT ae.course_id,
			jsonb_build_object(
				'examId', ed.exam_id,
				'examVersion', ed.content_version,
				'examTitle', ed.exam_title,
				'examSummary', ed.exam_summary,
				'examDescription', ed.exam_description,
				'examPassMark', ed.pass_mark,
				'examEstimatedCompletionTime', ed.estimated_completion_time,
				'examPassed', COALESCE(ec.passed, false)
			) AS exam_details_and_completion
	FROM exam_details ed
	INNER JOIN assigned_exams ae
	ON (ed.exam_id = ae.exam_id)
	LEFT JOIN exam_completion ec
	ON (ed.exam_id = ec.exam_id AND ed.content_version = ec.exam_version)
	GROUP BY ae.course_id,
			ed.exam_id,
			ed.content_version,
			ed.exam_title,
			ed.exam_summary,
			ed.exam_description,
			ed.pass_mark,
			ed.estimated_completion_time,
			ec.passed
	ORDER BY ed.exam_id ASC
), course_exams AS (
	SELECT edac.course_id,
		jsonb_agg(edac.exam_details_and_completion ORDER BY edac.course_id ASC) AS course_exams
	FROM exam_details_and_completion edac
	GROUP BY edac.course_id
	ORDER BY edac.course_id
)
SELECT jsonb_build_object(
			'courseId', csac.course_id,
			'courseVersion', csac.content_version,
            'courseTitle', cc.content_jdoc->>'courseTitle',
            'courseSummary', cc.content_jdoc->>'courseSummary',
            'courseDescription', cc.content_jdoc->>'courseDescription',
			'courseSections', jsonb_agg(csac.section_details ORDER BY csac.course_id ASC),
			'courseExams', ce.course_exams
		)
	FROM course_sections_and_completion csac
    INNER JOIN course_content cc
    ON (csac.course_id = cc.course_id AND csac.content_version = cc.content_version)
	INNER JOIN course_exams ce
	ON (csac.course_id = ce.course_id)
    WHERE cc.content_language = (SELECT preferred_language FROM user_preferred_language)
	GROUP BY csac.course_id,
            csac.content_version,
            cc.content_jdoc,
            ce.course_exams
	ORDER BY csac.course_id ASC;
	''';

  static const String url = 'http://127.0.0.1:5000/api?query=';

  final List<dynamic> _courseListData = [];

  @override
  void initState() {
    super.initState();

    fetchCourseListData('u1').then((List<dynamic> responseData) {
      for (List<dynamic> jsonCourse in responseData) {
        _courseListData.add(jsonDecode(jsonCourse.first) as Map<String, dynamic>);
      }
      print(_courseListData);
    });

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

  Future<List<dynamic>> fetchCourseListData(String uid) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query, [uid]);
    http.Response response = await http.get(Uri.parse('$url$sqlQuery'));
    List<dynamic> jsonResponse = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(response.body);
    }
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildSectionHeader(title: AppLocalizations.of(context)!.courses),
              Container(
                width: MediaQuery.of(context).size.width * 1,
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.02,
                  MediaQuery.of(context).size.width * 0.006,
                  MediaQuery.of(context).size.width * 0.02,
                  MediaQuery.of(context).size.width * 0.006,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: getTertiaryColor1()),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
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
      // for (Map<String, dynamic> course in _courseListData) {
      contentWidgets.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: HoverableSectionContainer(
              onHover: (bool) {},
              // color: Theme.of(context).scaffoldBackgroundColor,
              // elevation: 4,
              child: CustomExpansionTile(titleWidget: Text(course.courseTitle), contentWidget: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(course.courseDescription, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                  ),
                ),
                _separator,
                Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        // decoration: getExpansionTileBoxDecoration(),
                        child: ElevatedButton(
                            onPressed: () => context.goNamed(NamedRoutes.course.name,
                                pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId}),
                            child: courseId == 'webdev101' ? Text(AppLocalizations.of(context)!.resumeCourse) : Text(AppLocalizations.of(context)!.startCourse)))),
                _separator,
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 1,
                  child: CustomExpansionTile(
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppLocalizations.of(context)!.sections} (1/${course.courseSections.length} ${AppLocalizations.of(context)!.completed})"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: CustomLinearProgressIndicator(
                                value: (1 / course.courseSections.length ?? 3),
                                backgroundColor: Colors.grey.shade300,
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
                          Text("${AppLocalizations.of(context)!.exams} (0/${_exams[courseId]?.length} ${AppLocalizations.of(context)!.completed})"),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: CustomLinearProgressIndicator(
                                value: (0 / _exams[courseId]!.length ?? 3),
                                backgroundColor: Colors.grey.shade300,
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
                onPressed: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
                // style: getIconButtonStyleTransparent(),
              )
            : IconButton(
                icon: Icon(
                  Icons.pending,
                  color: Colors.orange,
                ),
                padding: const EdgeInsets.only(left: 15.0),
                onPressed: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
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
                onTap: section.sectionTitle == 'Section 1' ? () => print(section.sectionTitle) : null,
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
        padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 40.0), // Adjust padding for spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exam.examTitle,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10.0), // Add spacing between title and summary
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.examSummary,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
                SizedBox(height: 5.0), // Add spacing between summary and icons
                Row(
                  children: [
                    Icon(Icons.access_time), // Timer icon
                    SizedBox(width: 16),
                    Text("Estimated time: ${exam.examEstimatedTime} hours",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.school_outlined), // Score icon
                    SizedBox(width: 16),
                    Text("Pass mark: ${exam.examPassMark}",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.0), // Add spacing before description
            Text(exam.examDescription, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
            _separator,
            Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                    onPressed: () => print(exam.examTitle),
                    child: examId == 'e1' ? Text(AppLocalizations.of(context)!.retakeExam) : Text(AppLocalizations.of(context)!.startExam))),
          ],
        ),
      ));
      contentWidgets.add(_separator);
    });

    return contentWidgets;
  }
}
