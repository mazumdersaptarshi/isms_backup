import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:provider/provider.dart';

import 'package:isms/controllers/theme_management/app_theme.dart';
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

  static const String localFetchUrl = 'http://127.0.0.1:5000/get2';
  static const String remoteFetchUrl =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get2';

  late String _loggedInUserUid;

  final List<CourseOverview> _courses = [];

  @override
  void initState() {
    super.initState();

    _loggedInUserUid = Provider.of<LoggedInState>(context, listen: false).currentUserUid!;

    _fetchCourseOverviewData().then((List<dynamic> responseData) {
      for (List<dynamic> jsonCourse in responseData) {
        Map<String, dynamic> courseMap = jsonCourse.first as Map<String, dynamic>;
        CourseOverview course = CourseOverview.fromJson(courseMap);

        setState(() {
          _courses.add(course);
        });
      }
    });
  }

  Future<List<dynamic>> _fetchCourseOverviewData() async {
    Map<String, dynamic> requestParams = {'user_id': _loggedInUserUid};
    String jsonString = jsonEncode(requestParams);
    String encodedJsonString = Uri.encodeComponent(jsonString);
    http.Response response = await http
        .get(Uri.parse('$remoteFetchUrl?flag=get_course_and_exam_overview_for_user&params=$encodedJsonString'));
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
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      // drawer: IsmsDrawer(context: context),
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
                            child: Text(AppLocalizations.of(context)!.buttonResumeCourse))
                        : ElevatedButton(
                            onPressed: () => context.goNamed(NamedRoutes.course.name,
                                pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId}),
                            child: Text(AppLocalizations.of(context)!.buttonStartCourse))),
                _separator,
                Card(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 1,
                  child: CustomExpansionTile(
                      titleWidget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalizations.of(context)!
                              .sectionCompletion(completedSectionTotal, course.courseSections.length)),
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
                          Text(AppLocalizations.of(context)!
                              .examCompletion(completedExamTotal, course.courseExams.length)),
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
                    Text(AppLocalizations.of(context)!.examEstimatedCompletionTime(exam.examEstimatedCompletionTime),
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.school_outlined), // Score icon
                    SizedBox(width: 16),
                    Text(AppLocalizations.of(context)!.examPassMark(exam.examPassMark),
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
                        onPressed: () => print(exam.examTitle),
                        child: Text(AppLocalizations.of(context)!.buttonStartExam))
                    : ElevatedButton(
                        onPressed: null, child: Text(AppLocalizations.of(context)!.buttonStartExamDisabled))),
          ],
        ),
      ));
      contentWidgets.add(_separator);
    }

    return contentWidgets;
  }
}
