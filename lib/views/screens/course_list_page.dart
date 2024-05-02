import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:line_icons/line_icon.dart';
import 'package:provider/provider.dart';

import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/user_assigned_course_overview.dart';
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

  // static const String localFetchUrl = 'http://127.0.0.1:5000/get2';
  static const String localFetchUrl3 = 'http://127.0.0.1:5000/get3';

  static const String remoteFetchUrl =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get2';
  static const String remoteFetchUrl3 =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get3';
  late String _loggedInUserUid;

  final List<UserAssignedCourseOverview> _courses = [];
  List<UserAssignedCourseOverview> _assignedCourses = [];
  Map<String, List<ExamOverview>> _courseExamsMap = {};

  @override
  void initState() {
    super.initState();

    _loggedInUserUid = Provider.of<LoggedInState>(context, listen: false).currentUserUid!;
    _fetchAssignedCourses();
    // _fetchAssignedCoursesOverviewData();
  }

  Future<void> _fetchAssignedCourses() async {
    var fetchedAssignedCourses =
        await CourseProvider.fetchAssignedCoursesOverviewData(loggedInUserId: _loggedInUserUid);
    setState(() {
      _assignedCourses = fetchedAssignedCourses;
    });
  }

  // Future<List<dynamic>> _fetchCourseOverviewData() async {
  //   Map<String, dynamic> requestParams = {'user_id': _loggedInUserUid};
  //   String jsonString = jsonEncode(requestParams);
  //   String encodedJsonString = Uri.encodeComponent(jsonString);
  //   http.Response response = await http
  //       .get(Uri.parse('$remoteFetchUrl?flag=get_course_and_exam_overview_for_user&params=$encodedJsonString'));
  //   List<dynamic> jsonResponse = [];
  //   if (response.statusCode == 200) {
  //     // Check if the request was successful
  //     // Decode the JSON string into a Dart object (in this case, a List)
  //     jsonResponse = jsonDecode(response.body);
  //   }
  //   return jsonResponse;
  // }

  Future<List<UserAssignedCourseOverview>> _fetchAssignedCoursesOverviewData() async {
    Map<String, dynamic> requestParams = {'userID': _loggedInUserUid};
    String jsonString = jsonEncode(requestParams);
    String encodedJsonString = Uri.encodeComponent(jsonString);
    http.Response response =
        await http.get(Uri.parse('$remoteFetchUrl?flag=assigned_courses_list_for_user&params=$encodedJsonString'));
    List<dynamic> jsonResponse = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(response.body);
    }
    for (List<dynamic> jsonCourse in jsonResponse) {
      Map<String, dynamic> courseMap = jsonCourse.first as Map<String, dynamic>;
      // UserAssignedCourseOverview course = UserAssignedCourseOverview.fromJson(courseMap);
      List<SectionOverview> sections = [];
      for (Map<String, dynamic> section in courseMap['courseSections']) {
        sections.add(SectionOverview.fromJson(section));
      }
      UserAssignedCourseOverview course = UserAssignedCourseOverview(
        courseId: courseMap['courseId'] ?? '',
        courseVersion: courseMap['contentVersion'] ?? '0',
        courseTitle: courseMap['courseTitle'] ?? '',
        courseSummary: courseMap['courseSummary'] ?? '',
        courseDescription: courseMap['courseDescription'] ?? '',
        courseSections: sections ?? [],
        courseExams: [],
        allSectionIds: courseMap['allSectionIds'] ?? [],
        completedSections: courseMap['completedSections'] ?? [],
      );
      setState(() {
        _assignedCourses.add(course);
      });
    }
    return _assignedCourses;
  }

  Future<void> _fetchExamData({required String courseId}) async {
    if (_courseExamsMap.containsKey(courseId) && _courseExamsMap[courseId]!.isNotEmpty) {
      print("Exam data for course $courseId already loaded.");
      return;
    }
    Map<String, dynamic> requestParams = {'userID': _loggedInUserUid, 'courseID': courseId};
    print(requestParams);
    String jsonString = jsonEncode(requestParams);
    String encodedJsonString = Uri.encodeComponent(jsonString);
    http.Response response =
        await http.get(Uri.parse('$remoteFetchUrl3?flag=user_exam_progress_for_course&params=$encodedJsonString'));

    List<dynamic> jsonResponse = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(response.body);
    }
    for (List<dynamic> jsonExam in jsonResponse) {
      Map<String, dynamic> examMap = jsonExam.first as Map<String, dynamic>;
      ExamOverview exam = ExamOverview(
        examId: examMap['examId'],
        examVersion: examMap['contentVersion'],
        examTitle: examMap['examTitle'],
        examSummary: examMap['examSummary'],
        examDescription: examMap['examDescription'],
        examPassMark: examMap['passMark'],
        examEstimatedCompletionTime: examMap['estimatedCompletionTime'],
        examPassed: examMap['passed'] ?? false,
      );
      if (_courseExamsMap.containsKey(courseId)) {
        bool examExists = _courseExamsMap[courseId]!.any((e) => e.examId == exam.examId);
        if (!examExists) {
          _courseExamsMap[courseId]!.add(exam);
        }
      } else {
        _courseExamsMap[courseId] = [exam];
      }
    }
    setState(() {});

    print('courseExamMap: ${_courseExamsMap}');
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
            buildSectionHeader(title: 'Assigned Courses'),
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

  int calculatePassedExams(String courseId) {
    // Ensure the courseId exists in the map and is not null
    if (!_courseExamsMap.containsKey(courseId) || _courseExamsMap[courseId] == null) {
      return 0;
    }
    int passedExamsCount = 0;

    List<ExamOverview> exams = _courseExamsMap[courseId]!;
    for (ExamOverview exam in exams) {
      if (exam.examPassed) {
        // If the exam is passed, increment the count.
        passedExamsCount++;
      }
    }
    return passedExamsCount;
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getWidgets() {
    final List<Widget> contentWidgets = [];

    for (UserAssignedCourseOverview course in _assignedCourses) {
      int completedSectionTotal = course.completedSections?.length ?? 0;
      for (SectionOverview section in course.courseSections) {
        // if (section.sectionCompleted) {
        //   completedSectionTotal++;
        // }
      }

      contentWidgets.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CustomExpansionTile(
              titleWidget: Text(course.courseTitle),
              contentWidget: [
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
                                      NamedRouteQueryParameters.section.name: (completedSectionTotal).toString()
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
                                style:
                                    ThemeConfig.elevatedBoxButtonStyle(backgroundColor: ThemeConfig.primaryCardColor)),
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
                                    backgroundColor: ThemeConfig.percentageIconBackgroundFillColor!,
                                    valueColor: ThemeConfig.primaryColor!),
                              ),
                            ],
                          ),
                          contentWidget: [
                            ..._getCourseSections(course.courseId, course.courseSections, completedSectionTotal)
                          ]),
                      _separator,
                      if (_courseExamsMap[course.courseId] != null)
                        CustomExpansionTile(
                          expansionTileCardColor: ThemeConfig.secondaryCardColor,
                          titleWidget: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.examCompletion(
                                  calculatePassedExams(course.courseId), _courseExamsMap[course.courseId]!.length)),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: CustomLinearProgressIndicator(
                                    value: (calculatePassedExams(course.courseId) /
                                        _courseExamsMap[course.courseId]!.length),
                                    backgroundColor: ThemeConfig.percentageIconBackgroundFillColor!,
                                    valueColor: ThemeConfig.primaryColor!),
                              )
                            ],
                          ),
                          contentWidget: [
                            ..._getExamWidgets(_courseExamsMap[course.courseId]! ?? [],
                                course.allSectionIds?.length ?? 0, completedSectionTotal),
                          ],
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
              onDataFetch: () => _fetchExamData(courseId: course.courseId),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                exam.examPassed
                    ? Icon(
                        Icons.check_circle_outline_rounded,
                        color: ThemeConfig.primaryColor!,
                      )
                    : Icon(
                        Icons.pending_actions_rounded,
                        color: Colors.orange,
                      ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        '${exam.examTitle}',
                        style: TextStyle(fontSize: 14, color: ThemeConfig.primaryTextColor),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                        Text(
                            AppLocalizations.of(context)!.examEstimatedCompletionTime(exam.examEstimatedCompletionTime),
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
                    SizedBox(height: 15.0), // Add spacing before description
                    Text(exam.examDescription, style: TextStyle(fontSize: 13, color: ThemeConfig.tertiaryTextColor2)),
                  ],
                ),
              ],
            ),
            _separator,
            Align(
              alignment: Alignment.centerLeft,
              child: sectionTotal == completedSectionTotal
                  ? ElevatedButton(
                      onPressed: () {
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

    // return [Container(width: 100, height: 100, child: Text(''))];
    return contentWidgets;
  }
}
