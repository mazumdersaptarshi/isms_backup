import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:provider/provider.dart';

import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/course_overview.dart';
import 'package:isms/models/course/exam_overview.dart';
import 'package:isms/models/course/section_overview.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';

class CourseList extends StatefulWidget {
  const CourseList({super.key});

  @override
  State<CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<CourseList> {
  /// SizedBox for adding consistent spacing between widgets
  static const SizedBox _separator = SizedBox(height: 20);

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

  final List<CourseOverview> _courses = [];

  @override
  void initState() {
    super.initState();

    fetchCourseListData('u1').then((List<dynamic> responseData) {
      for (List<dynamic> jsonCourse in responseData) {
        Map<String, dynamic> courseMap = jsonCourse.first as Map<String, dynamic>;
        CourseOverview course = CourseOverview.fromJson(courseMap);

        setState(() {
          _courses.add(course);
        });
      }
    });
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
                border: Border.all(color: ThemeConfig.tertiaryColor1!),
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
      // ),
    );
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getWidgets() {
    final List<Widget> contentWidgets = [];

    for (CourseOverview course in _courses) {
      int completedSectionTotal = 0;
      for (SectionOverview section in course.courseSections) {
        if (section.sectionCompleted) {
          completedSectionTotal++;
        }
      }

      int completedExamTotal = 0;
      for (ExamOverview exam in course.courseExams) {
        if (exam.examPassed) {
          completedExamTotal++;
        }
      }

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
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(course.courseSummary, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                          ],
                        ),
                        _separator,
                        Row(
                          children: [
                            Text(course.courseDescription, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _separator,
                Align(
                    alignment: Alignment.centerLeft,
                    child: completedSectionTotal > 0 && completedSectionTotal < course.courseSections.length
                        ? ElevatedButton(
                            onPressed: () => context.goNamed(NamedRoutes.course.name, pathParameters: {
                                  NamedRoutePathParameters.courseId.name: course.courseId
                                }, queryParameters: {
                                  NamedRouteQueryParameters.section.name: (completedSectionTotal + 1).toString()
                                }),
                            child: Text(AppLocalizations.of(context)!.resumeCourse))
                        : ElevatedButton(
                            onPressed: () => context.goNamed(NamedRoutes.course.name,
                                pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId}),
                            child: Text(AppLocalizations.of(context)!.startCourse))),
                _separator,
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 1,
                  child: CustomExpansionTile(
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.sections} ($completedSectionTotal/${course.courseSections.length} ${AppLocalizations.of(context)!.completed})"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: CustomLinearProgressIndicator(
                                value: (completedSectionTotal / course.courseSections.length),
                                backgroundColor: Colors.grey.shade300,
                                valueColor: ThemeConfig.primaryColor!),
                          ),
                        ],
                      ),
                      contentWidget: [
                        ..._getCourseSections(course.courseId, course.courseSections, completedSectionTotal)
                      ]),
                ),
                _separator,
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 1,
                  child: CustomExpansionTile(
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${AppLocalizations.of(context)!.exams} ($completedExamTotal/${course.courseExams.length} ${AppLocalizations.of(context)!.completed})"),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: CustomLinearProgressIndicator(
                                value: (completedExamTotal / course.courseExams.length),
                                backgroundColor: Colors.grey.shade300,
                                valueColor: ThemeConfig.primaryColor!),
                          ),
                        ],
                      ),
                      contentWidget: [
                        ..._getExamWidgets(course.courseExams, course.courseSections.length, completedSectionTotal)
                      ]),
                )
              ]),
            ),
          )
        ],
      ));
    }

    return contentWidgets;
  }

  List<Widget> _getCourseSections(String courseId, List<SectionOverview> sections, int completedSectionTotal) {
    final List<Widget> contentWidgets = [];

    for (int i = 0; i < sections.length; i++) {
      contentWidgets.add(Row(children: [
        sections[i].sectionCompleted
            ? IconButton(
                icon: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
                padding: const EdgeInsets.only(left: 15.0),
                onPressed: () => context.goNamed(NamedRoutes.course.name,
                    pathParameters: {NamedRoutePathParameters.courseId.name: courseId},
                    queryParameters: {NamedRouteQueryParameters.section.name: (i + 1).toString()}),
                // style: getIconButtonStyleTransparent(),
              )
            : IconButton(
                icon: const Icon(
                  Icons.pending,
                  color: Colors.orange,
                ),
                padding: const EdgeInsets.only(left: 15.0),
                onPressed: i == completedSectionTotal
                    ? () => context.goNamed(NamedRoutes.course.name,
                        pathParameters: {NamedRoutePathParameters.courseId.name: courseId},
                        queryParameters: {NamedRouteQueryParameters.section.name: (i + 1).toString()})
                    : null,
                // style: getIconButtonStyleTransparent(),
              ),
        Flexible(
          child: Column(
            children: [
              ListTile(
                title: Text(
                  sections[i].sectionTitle,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  sections[i].sectionSummary,
                  style: TextStyle(fontSize: 13),
                ),
                onTap: sections[i].sectionCompleted || i == completedSectionTotal
                    ? () => context.goNamed(NamedRoutes.course.name,
                        pathParameters: {NamedRoutePathParameters.courseId.name: courseId},
                        queryParameters: {NamedRouteQueryParameters.section.name: (i + 1).toString()})
                    : null,
              ),
              Divider(
                color: Colors.grey.shade200,
                thickness: 1,
              ),
            ],
          ),
        )
      ]));
      // contentWidgets.add(_separator);
    }

    return contentWidgets;
  }

  List<Widget> _getExamWidgets(List<ExamOverview> exams, int sectionTotal, int completedSectionTotal) {
    final List<Widget> contentWidgets = [];

    for (ExamOverview exam in exams) {
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
                    const Icon(Icons.access_time), // Timer icon
                    SizedBox(width: 16),
                    Text("Estimated completion time: ${exam.examEstimatedCompletionTime}",
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.school_outlined), // Score icon
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
                child: sectionTotal == completedSectionTotal
                    ? ElevatedButton(
                        onPressed: () => print(exam.examTitle), child: Text(AppLocalizations.of(context)!.startExam))
                    : ElevatedButton(onPressed: null, child: Text('Complete all course sections to take exam'))),
          ],
        ),
      ));
      contentWidgets.add(_separator);
    }

    return contentWidgets;
  }
}
