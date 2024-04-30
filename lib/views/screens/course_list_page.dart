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

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
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
    print('lop: ${jsonResponse}');
    return jsonResponse;
  }

  @override
  Widget build(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
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
              child: ListView(
                shrinkWrap: true,
                children: [..._getWidgets()],
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
            padding: const EdgeInsets.all(8),
            child: CustomExpansionTile(titleWidget: Text(course.courseTitle), contentWidget: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(
                        thickness: 1,
                        color: ThemeConfig.borderColor2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(course.courseSummary,
                                style: TextStyle(fontSize: 14, color: ThemeConfig.primaryTextColor)),
                            _separator,
                            Text(course.courseDescription,
                                style: TextStyle(fontSize: 14, color: ThemeConfig.primaryTextColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _separator,
              Align(
                  alignment: Alignment.centerLeft,
                  child: completedSectionTotal > 0 && completedSectionTotal < course.courseSections.length
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                              onPressed: () => context.goNamed(NamedRoutes.course.name, pathParameters: {
                                    NamedRoutePathParameters.courseId.name: course.courseId
                                  }, queryParameters: {
                                    NamedRouteQueryParameters.section.name: (completedSectionTotal + 1).toString()
                                  }),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: Text(AppLocalizations.of(context)!.buttonResumeCourse,
                                    style: TextStyle(color: ThemeConfig.secondaryTextColor)),
                              ),
                              style: ThemeConfig.elevatedBoxButtonStyle()),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ElevatedButton(
                              onPressed: () => context.goNamed(NamedRoutes.course.name,
                                  pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId}),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 13),
                                child: Text(
                                  AppLocalizations.of(context)!.buttonStartCourse,
                                  style: TextStyle(color: ThemeConfig.secondaryTextColor),
                                ),
                              ),
                              style: ThemeConfig.elevatedBoxButtonStyle(backgroundColor: ThemeConfig.primaryCardColor)),
                        )),
              _separator,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomExpansionTile(
                        expansionTileCardColor: ThemeConfig.secondaryCardColor,
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
                    _separator,
                    CustomExpansionTile(
                        expansionTileCardColor: ThemeConfig.secondaryCardColor,
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          )
        ],
      ));
    }

    return contentWidgets;
  }

  List<Widget> _getCourseSections(String courseId, List<SectionOverview> sections, int completedSectionTotal) {
    final List<Widget> contentWidgets = [];

    for (int i = 0; i < sections.length; i++) {
      contentWidgets.add(Container(
        // color: ThemeConfig.secondaryCardColor,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          sections[i].sectionCompleted
              ? IconButton(
                  icon: Icon(
                    Icons.check_circle_outline_rounded,
                    color: ThemeConfig.primaryColor!,
                  ),
                  padding: const EdgeInsets.only(left: 15.0),
                  onPressed: () => context.goNamed(NamedRoutes.course.name,
                      pathParameters: {NamedRoutePathParameters.courseId.name: courseId},
                      queryParameters: {NamedRouteQueryParameters.section.name: (i + 1).toString()}),
                  // style: getIconButtonStyleTransparent(),
                )
              : IconButton(
                  icon: const Icon(
                    Icons.pending_outlined,
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
                      color: ThemeConfig.primaryTextColor,
                    ),
                  ),
                  subtitle: Text(
                    sections[i].sectionSummary,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeConfig.tertiaryTextColor1,
                    ),
                  ),
                  onTap: sections[i].sectionCompleted || i == completedSectionTotal
                      ? () => context.goNamed(NamedRoutes.course.name,
                          pathParameters: {NamedRoutePathParameters.courseId.name: courseId},
                          queryParameters: {NamedRouteQueryParameters.section.name: (i + 1).toString()})
                      : null,
                ),
                Divider(
                  color: ThemeConfig.borderColor2,
                  thickness: 1,
                ),
              ],
            ),
          )
        ]),
      ));
      // contentWidgets.add(_separator);
    }

    return contentWidgets;
  }

  List<Widget> _getExamWidgets(List<ExamOverview> exams, int sectionTotal, int completedSectionTotal) {
    final List<Widget> contentWidgets = [];

    for (ExamOverview exam in exams) {
      contentWidgets.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Text(
              exam.examTitle,
              style: TextStyle(fontSize: 14, color: ThemeConfig.primaryTextColor),
            ),
            SizedBox(height: 10.0), // Add spacing between title and summary
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exam.examSummary,
                  style: TextStyle(fontSize: 13, color: ThemeConfig.tertiaryTextColor2),
                ),
                SizedBox(height: 5.0), // Add spacing between summary and icons
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: ThemeConfig.primaryColor!,
                    ), // Timer icon
                    SizedBox(width: 16),
                    Text(AppLocalizations.of(context)!.examEstimatedCompletionTime(exam.examEstimatedCompletionTime),
                        style: TextStyle(fontSize: 13, color: ThemeConfig.tertiaryTextColor1)),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      color: ThemeConfig.primaryColor!,
                    ), // Score icon
                    SizedBox(width: 16),
                    Text(AppLocalizations.of(context)!.examPassMark(exam.examPassMark),
                        style: TextStyle(fontSize: 13, color: ThemeConfig.tertiaryTextColor1)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15.0), // Add spacing before description
            Text(exam.examDescription, style: TextStyle(fontSize: 13, color: ThemeConfig.tertiaryTextColor2)),
            _separator,
            Align(
              alignment: Alignment.centerLeft,
              child: sectionTotal == completedSectionTotal
                  ? ElevatedButton(
                      onPressed: () {
                        print('${exam.examTitle}, ${exam.examId}');
                        context.goNamed(NamedRoutes.exam.name,
                            pathParameters: {NamedRoutePathParameters.examId.name: exam.examId});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        child: Text(
                          AppLocalizations.of(context)!.buttonStartExam,
                          style: TextStyle(
                            color: ThemeConfig.secondaryTextColor,
                          ),
                        ),
                      ),
                      style: ThemeConfig.elevatedBoxButtonStyle(backgroundColor: ThemeConfig.secondaryCardColor),
                    )
                  : ElevatedButton(
                      onPressed: () {},
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        child: Text(
                          'Complete all sections to start the exam',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      style: ThemeConfig.elevatedBoxButtonStyleDisabled(),
                    ),
            ),
            Divider(
              thickness: 1,
              color: ThemeConfig.borderColor2,
            ),
          ],
        ),
      ));
      contentWidgets.add(_separator);
    }

    return contentWidgets;
  }
}
