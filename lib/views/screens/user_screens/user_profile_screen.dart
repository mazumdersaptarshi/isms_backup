import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:intl/intl.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/testing/testing_admin_graphs.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/admin_models/summary_section_item_widget.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/user_progress/user_course_progress.dart';
import 'package:isms/models/user_progress/user_exam_attempt.dart';
import 'package:isms/models/user_progress/user_exam_progress.dart';
import 'package:isms/sql/queries/query6.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/screens/admin_screens/settings_page.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/chart_metric_select_widget_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_bar_chart_user_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_line_chart_user_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_pie_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/settings_section.dart';
import 'package:isms/views/widgets/shared_widgets/user_profile_banner.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileScreen extends StatefulWidget {
  final String uid;

  const UserProfileScreen({super.key, required this.uid});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late AdminState adminState;
  late String _CSRFToken;
  late String _JWT;

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
    // _fetchCoursesForUser();

    // _usersDataBarChart = updateUserDataOnDifferentMetricSelection('avgScore');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _CSRFToken = Provider.of<CsrfTokenProvider>(context).csrfToken;
    _JWT = Provider.of<CsrfTokenProvider>(context).jwt;
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    /// Returns a DataTable Widget, each row representing an exam attempt.
    /// It takes an input List<dynamic> attempts
    /// `attempt` is a Map<String, dynamic> containing the following keys:
    ///
    ///   - 'attemptId': The id of the attempt.
    ///   - 'startTime': The start time of the exam (eg. 2024-01-24 09:29:04.066).
    ///   - 'endTime': The end time of the exam (eg. 2024-01-24 10:30:40.234).
    ///   - 'score': The score in that attempt (eg. 40).
    ///   - 'responses': A list of the responses i.e. the questions and the answers the user selected in that attempt

    Widget _getExamAttemptDataTable(List<UserExamAttempt> attempts) {
      if (attempts.isEmpty) {
        return Text('No attempts data available');
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.examId}',
              label: Text(
                '${AppLocalizations.of(context)!.examId}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
            ),
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.startTime}',
              label: Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Text(
                      '${AppLocalizations.of(context)!.startTime}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.endTime}',
              label: Row(
                children: [
                  Icon(
                    CupertinoIcons.clock,
                    color: Colors.grey.shade500,
                    size: 16,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Flexible(
                    child: Text(
                      '${AppLocalizations.of(context)!.endTime}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.result}',
              label: Text(
                '${AppLocalizations.of(context)!.result}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
            ),
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.score}',
              label: Text(
                '${AppLocalizations.of(context)!.score}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
            ),
            DataColumn(
              tooltip: '${AppLocalizations.of(context)!.duration}',
              label: Text(
                '${AppLocalizations.of(context)!.duration}',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
            ),
          ],
          rows: attempts
              .asMap()
              .map((index, attempt) {
            // Format dates and duration for display
            String formattedStartTime = DateFormat('yyyy-MM-dd – kk:mm').format(attempt.startTime);
            String formattedEndTime = DateFormat('yyyy-MM-dd – kk:mm').format(attempt.endTime);
            Duration duration = attempt.endTime.difference(attempt.startTime);

            String formattedDuration =
                '${duration.inHours}${AppLocalizations.of(context)?.hours} ${duration.inMinutes.remainder(60)}${AppLocalizations.of(context)?.minutes}';
            Color bgColor = index % 2 == 1 ? Colors.transparent : ThemeConfig.tableRowColor!;

            return MapEntry(
              index,
              DataRow(
                color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                  return bgColor; // Use the bgColor for this row
                }),
                cells: [
                  DataCell(Text(
                    attempt.examId,
                    style: TextStyle(color: ThemeConfig.primaryTextColor),
                  )),
                  DataCell(Text(
                    formattedStartTime,
                    style: TextStyle(color: ThemeConfig.primaryTextColor),
                  )),
                  DataCell(Text(
                    formattedEndTime,
                    style: TextStyle(color: ThemeConfig.primaryTextColor),
                  )),
                  DataCell(Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: attempt.result.name == ExamAttemptResult.pass.name ? Colors.lightGreen : Colors.red,
                    ),
                    child: Text(
                      attempt.result.name == ExamAttemptResult.pass.name
                          ? '${AppLocalizations.of(context)!.pass}'
                          : '${AppLocalizations.of(context)!.fail}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.right,
                    ),
                  )),
                  DataCell(Text(
                    '${attempt.score}',
                    style: TextStyle(color: ThemeConfig.primaryTextColor),
                  )),
                  DataCell(Text(
                    formattedDuration,
                    style: TextStyle(color: ThemeConfig.primaryTextColor),
                  )),
                ],
              ),
            );
          })
              .values
              .toList(), // Convert map entries back to a list
        ),
      );

    }

    /// Returns a Widget displaying details about a specific Exam, taken by the specific User.
    /// Input: the function takes in a Map<String, dynamic>, which stores information about an Exam
    /// `examData` is a Map<String, dynamic> containing the following keys:
    ///
    ///   - 'examId': The id of the exam.
    ///   - 'examTitle': The Title of the exam.

    Widget _getCourseExamTitleWidget({required String examTitle, ExamStatus? examStatus}) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            examStatus == ExamStatus.completed
                ? Icon(
              Icons.check_circle_outline_rounded,
              color: ThemeConfig.primaryColor,
            )
                : Icon(
              Icons.hourglass_top_rounded,
              color: Colors.orangeAccent,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                examTitle,
                style: TextStyle(overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
        ),
      );
    }

    // void _updateBarDataOnMetricSelection(String? metricKey) {
    //   setState(() {
    //     _usersDataBarChart = updateUserDataOnDifferentMetricSelection(metricKey);
    //   });
    // }

    // void _updateSelectedMetricBarChart(String? selectedMetric) {
    //   setState(() {
    //     _updateBarDataOnMetricSelection(selectedMetric);
    //   });
    // }

    /// Returns a list of Widgets, which contains a list of the Exams taken by the User for a specific Course, .
    /// It takes an input List<dynamic> attempts

    List<Widget> _getCourseExamsListOfWidgets({required List<UserExamProgress> examsProgressList}) {
      List<Widget> expansionTiles = [];
      for (UserExamProgress examProgressItem in examsProgressList) {
        // The title widget for the ExpansionTile
        Widget titleWidget =
            _getCourseExamTitleWidget(examTitle: examProgressItem.examTitle!, examStatus: examProgressItem.examStatus);

        // The content widget for the ExpansionTile
        // Widget contentWidget = _getExamAttemptDataTable(examProgressItem.examAttempts!);
        // Widget contentWidget = Text('');
        Widget contentWidget = FutureBuilder<List<UserExamAttempt>>(
          future: adminState.getExamAttemptsList(
            userId: examProgressItem.userId!,
            courseId: examProgressItem.courseId!,
            examId: examProgressItem.examId,
          ), // Pass the userId, courseId, examId to the future
          builder: (BuildContext context, AsyncSnapshot<List<UserExamAttempt>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Loading state
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // Error state
            } else {
              // Data loaded state, convert your data into a widget here
              return _getExamAttemptDataTable(
                  snapshot.data!); // Assuming this is your method to convert data into widget
            }
          },
        );

        expansionTiles.add(Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: CustomExpansionTile(
              titleWidget: titleWidget,
              contentWidget: contentWidget,
              expansionTileCardColor: ThemeConfig.secondaryCardColor,
            )));
      }

      return expansionTiles;
    }

    /// Returns a Widget displaying details about a specific Course, taken by the User.
    /// Input: the function takes in a Map<String, dynamic>, which stores information about the Course
    /// Sample input:
    /// ```
    /// Returns a Column widget that serves as the header for displaying course details.
    /// The widget layout includes the course name, completion status, and progress information.
    ///
    /// `courseDetails` is a Map<String, dynamic> containing the following keys:
    ///   - 'courseName': The name of the course.
    ///   - 'completionStatus': The current completion status of the course (e.g., 'In progress', 'Completed').
    ///   - 'completedSections': A list of sections that have been completed by the user.
    ///   - 'completedExams': A list of exams that have been completed by the user.
    ///   - 'courseSections': A list of all sections in the course.
    ///   - 'courseExams': A list of all exams in the course.

    Widget _courseDetailsTitleWidget({required UserCourseProgress userCourseProgress, int? index}) {
      double completionPercentage = 0;
      try {
        completionPercentage = ((userCourseProgress.completedSectionsCount! + userCourseProgress.passedExamsCount!) /
            (userCourseProgress.sectionsInCourseCount! + userCourseProgress.examsInCourseCount!));
      } catch (e) {}

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  userCourseProgress.courseLearningCompleted == true
                      ? Icons.check_circle_outline_rounded // Icon for 'completed' status
                      : Icons.pending, // Icon for other statuses
                  color: userCourseProgress.courseLearningCompleted == true
                      ? ThemeConfig.primaryColor // Color for 'completed' status
                      : Colors.amber, // Color for other statuses
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.menu_book_rounded, color: ThemeConfig.primaryTextColor),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                userCourseProgress.courseTitle.toString(),
                                style: TextStyle(
                                  color: ThemeConfig.primaryTextColor,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.20,
                            child: CustomLinearProgressIndicator(
                              value: completionPercentage,
                              backgroundColor: ThemeConfig.percentageIconBackgroundFillColor!,
                              valueColor: ThemeConfig.primaryColor!,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${(completionPercentage * 100).toStringAsFixed(2)}%',
                            style: TextStyle(color: ThemeConfig.primaryTextColor),
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '(${(userCourseProgress.completedSectionsCount! + userCourseProgress.passedExamsCount!).toString()}'
                                  '/${(userCourseProgress.sectionsInCourseCount! + userCourseProgress.examsInCourseCount!).toString()})',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: ThemeConfig.secondaryTextColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(
        context: context,
      ),
      drawer: IsmsDrawer(context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
          // FutureBuilder to asynchronously fetch user data.
          FutureBuilder<dynamic>(
            // future: AdminDataHandler.getUser(loggedInState.currentUser!.uid), // The async function call
            future: adminState.getUserProfileData(widget.uid),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                var userJson = snapshot.data[0][0];
                // Data is fetched successfully, display the user's name
                // return Text(snapshot.data?['username'] ?? 'No name found');
                return Container(
                  margin: EdgeInsets.all(40),
                  child: UserProfileBanner(
                    userName: '${userJson['givenName']} ${userJson['familyName']}',
                    // userEmail: loggedInState.currentUser!.email!,
                    userEmail: userJson['email'],
                    userRole: userJson['accountRole'],
                    adminState: adminState,
                    uid: userJson['userId'],
                  ),
                );
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
          // FutureBuilder to asynchronously fetch course data for the user.
          buildSectionHeader(title: '${AppLocalizations.of(context)?.summary}'),
          FutureBuilder<dynamic>(
            // future: adminState.retrieveAllDataFromDatabase(), // The async function call
            future: adminState.getUserSummary(widget.uid, context),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Data is fetched successfully, display the user's name
                snapshot.data.forEach((element) {});
                // return _buildSummarySection(snapshot.data);
                return _buildSummaryItemWidgets(snapshot.data);
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
          buildSectionHeader(title: '${AppLocalizations.of(context)?.progressOverview}'),

          FutureBuilder<dynamic>(
              future: adminState.getUserProgressOverview(widget.uid),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for the data
                  return SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  // Handle the error case
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    child: ListView.builder(
                      shrinkWrap: true,
                      // itemCount: adminState.getAllCoursesDataForCurrentUser(uid)['coursesDetails'].length,
                      // itemCount: userCourseDetailsList.length,
                      itemCount: snapshot.data.length,

                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: CustomExpansionTile(
                            titleWidget: _courseDetailsTitleWidget(
                              userCourseProgress: snapshot.data[index],
                              index: index,
                            ),
                            contentWidget: _getCourseExamsListOfWidgets(
                                examsProgressList: snapshot.data[index].examsProgressList!),
                            index: index,
                            length: userCourseDetailsList.length,
                            hasHoverBorder: true,
                          ),
                        );
                      },
                    ),
                  );
                }
              }),
          buildSectionHeader(title: '${AppLocalizations.of(context)?.buttonSettings}'),

          Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 30),
              child: SettingsSection(
                CSRFToken: _CSRFToken,
                JWT: _JWT,
              )),
        ],
      ),
    );
  }

  Widget _buildSummaryItemWidgets(snapshotData) {
    print(snapshotData);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 900) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              children: snapshotData.asMap().entries.map<Widget>((entry) {
                int index = entry.key;
                return Expanded(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: HoverableSectionContainer(
                      onHover: (bool) {},
                      child: SummarySectionItemWidget(
                        title: entry.value.summaryTitle,
                        value: entry.value.value.toString(),
                        icon: entry.value.icon ?? null,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        } else {
          return Container(
            height: 350,
            margin: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Column(
              children: snapshotData.asMap().entries.map<Widget>((entry) {
                int index = entry.key;
                return Container(
                  margin: EdgeInsets.all(10),
                  child: HoverableSectionContainer(
                    onHover: (bool) {},
                    child: SummarySectionItemWidget(
                      title: entry.value.summaryTitle,
                      value: entry.value.value.toString(),
                      icon: entry.value.icon ?? null,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}

class SummaryItemWidget extends StatefulWidget {
  final String title;
  final String value;
  final int index;
  final int length;

  final String type;

  const SummaryItemWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.index,
    required this.length,
    required this.type,
  }) : super(key: key);

  @override
  _SummaryItemWidgetState createState() => _SummaryItemWidgetState();
}

class _SummaryItemWidgetState extends State<SummaryItemWidget> {
  bool _isHovered = false;

  BorderRadius _getBorderRadius() {
    if (widget.index == 0) {
      return BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        topRight: Radius.circular(3),
        bottomRight: Radius.circular(3),
      );
    } else if (widget.index == widget.length - 1) {
      return BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
        topLeft: Radius.circular(3),
        bottomLeft: Radius.circular(3),
      );
    } else {
      return BorderRadius.circular(3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Container(
          decoration: BoxDecoration(
            color: _isHovered ? ThemeConfig.hoverFillColor1 : Colors.transparent, // Change color on hover
            borderRadius: _getBorderRadius(), // Set the border radius based on index
            border: _isHovered ? Border.all(color: ThemeConfig.hoverBorderColor1!) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: ThemeConfig.primaryTextColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                if (widget.type == 'number')
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeConfig.borderColor2!,
                        width: 2,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.value,
                          style: TextStyle(
                            color: ThemeConfig.primaryTextColor,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (widget.type == 'percentage')
                  Container(
                    width: 80,
                    height: 80,
                    child: FittedBox(
                      fit: BoxFit.scaleDown, // Ensures the child scales down to fit the available width
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: double.parse(widget.value) / 100,
                              // Convert percentage to a value between 0 and 1
                              strokeWidth: 6.0,
                              // The thickness of the progress bar
                              backgroundColor: ThemeConfig.percentageIconBackgroundFillColor,
                              // Background color of the progress bar
                              color: ThemeConfig.primaryColor, // Progress color
                            ),
                          ),
                          Text(
                            '${(double.parse(widget.value)).toStringAsFixed(0)}%', // The percentage text
                            style: TextStyle(fontSize: 30, color: ThemeConfig.primaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
