import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:intl/intl.dart';
import 'package:isms/controllers/admin_management/admin_data.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/testing/test_data.dart';
import 'package:isms/controllers/testing/testing_admin_graphs.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/user_progress/user_course_progress.dart';
import 'package:isms/models/user_progress/user_exam_attempt.dart';
import 'package:isms/models/user_progress/user_exam_progress.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/screens/testing/test_ui_type1/user_test_responses.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/chart_metric_select_widget_dropdown.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_bar_chart_user_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_line_chart_user_widget.dart';
import 'package:isms/views/widgets/shared_widgets/charts/custom_pie_chart_widget.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_expansion_tile.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:isms/views/widgets/shared_widgets/user_profile_banner.dart';
import 'package:provider/provider.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  const AdminUserDetailsScreen({super.key});

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  late AdminState adminState;
  List<CustomBarChartData> _usersDataBarChart = [];

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
    _usersDataBarChart = updateUserDataOnDifferentMetricSelection('avgScore');
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    // final String uid = 'gZZg3iv6e2YsoMXlMrXIVgf6Ycl2'; //Sample UserID for testing
    // Map _userAllData = {};

    /// Returns a DataTable Widget, each row representing an exam attempt.
    /// It takes an input List<dynamic> attempts
    /// `attempt` is a Map<String, dynamic> containing the following keys:
    ///
    ///   - 'attemptId': The id of the attempt.
    ///   - 'startTime': The start time of the exam (eg. 2024-01-24 09:29:04.066).
    ///   - 'endTime': The end time of the exam (eg. 2024-01-24 10:30:40.234).
    ///   - 'score': The score in that attempt (eg. 40).
    ///   - 'responses': A list of the responses i.e. the questions and the answers the user selected in that attempt
    Widget _getExamAttemptsDataTable(List<dynamic> attempts) {
      if (attempts.isEmpty) {
        return Text('No attempts data available');
      }
      // Add a 'duration' key to each attempt map
      String durationString = '';
      for (var attempt in attempts) {
        if (attempt['startTime'] != null &&
            attempt['startTime'].isNotEmpty &&
            attempt['startTime'] != '' &&
            attempt['endTime'] != null &&
            attempt['endTime'] != '' &&
            attempt['endTime'].isNotEmpty) {
          DateTime startTime = DateTime.parse(attempt['startTime']);
          DateTime endTime = DateTime.parse(attempt['endTime']);
          Duration duration = endTime.difference(startTime);
          durationString = duration.toString().split('.').first; // Format duration
        }

        // Format duration;
        attempt['duration'] = durationString; // Add the duration to the attempt map
      }
      // Dynamically generate the DataColumn list based on the keys of the first attempt.
      List<String> keys = attempts.first.keys.toList();
      // List<String> keys = List.from(attempts.first.keys)..add('duration');

      List<DataColumn> columns = keys.map((key) {
        return DataColumn(
            tooltip: key,
            label: (key == 'startTime' || key == 'endTime')
                ? Row(
                    children: [
                      Icon(
                        CupertinoIcons.clock,
                        size: 15,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        key,
                        style: TextStyle(color: getTertiaryTextColor1()),
                      )
                    ],
                  )
                : Text(
                    key,
                    style: TextStyle(color: getTertiaryTextColor1()),
                  ));
      }).toList();

      // Dynamically generate the DataRow list.
      List<DataRow> rows = attempts.asMap().entries.map<DataRow>((entry) {
        int index = entry.key; // This is the index of the row
        var attempt = entry.value;

        List<DataCell> cells = keys.map((key) {
          String cellText;
          if (attempt[key] == null || attempt[key].toString().isEmpty) {
            cellText = 'n/a';
          } else if (key == 'score') {
            cellText = attempt[key].toString() + '%'; // Add '%' for 'score' key
          } else if (key == 'startTime' || key == 'endTime') {
            DateTime dateTime = DateTime.parse(attempt[key]);
            String date = DateFormat('yyyy-MM-dd').format(dateTime);
            String time = DateFormat('HH:mm:ss').format(dateTime);
            cellText = '$date\n$time';
          } else {
            cellText = attempt[key].toString().length > 10
                ? attempt[key].toString().substring(0, 10) + '...'
                : attempt[key].toString();
          }

          return DataCell(
            Container(
              // alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10), // Adjust padding as needed
              decoration: BoxDecoration(
                color: key == 'completionStatus'
                    ? (attempt[key] == 'completed' ? Colors.green : Colors.orange)
                    : Colors.transparent, // Alternating row colors
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: (key != 'responses')
                  ? Text(
                      cellText,
                      style: TextStyle(
                        color: key == 'completionStatus' ? Colors.white : getTertiaryTextColor1(),
                        fontSize: 14,
                      ),
                    )
                  : TextButton(
                      onPressed: () =>
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminTestResponsesPage())),
                      child: Text(
                        'View Responses',
                        style: TextStyle(color: primary),
                      )),
            ),
          );
        }).toList();

        return DataRow(
            color: MaterialStateProperty.all(
              (index % 2 == 1) ? Colors.transparent : Colors.grey.shade100,
            ),
            cells: cells);
      }).toList();

      return DataTable(
        columns: columns,
        rows: rows,
      );
    }

    Widget _getExamAttemptDataTable(List<UserExamAttempt> attempts) {
      if (attempts.isEmpty) {
        return Text('No attempts data available');
      }

      return DataTable(
        columns: [
          DataColumn(
              tooltip: 'Exam ID',
              label: Text(
                'Exam ID',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              )),
          DataColumn(
              tooltip: 'Start Time',
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
                  Text(
                    'Start Time',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                  ),
                ],
              )),
          DataColumn(
              tooltip: 'End Time',
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
                  Text(
                    'End Time',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                  ),
                ],
              )),
          DataColumn(
              tooltip: 'Result',
              label: Text(
                'Result',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              )),
          DataColumn(
              tooltip: 'Score',
              label: Text(
                'Score',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              )),
          DataColumn(
              tooltip: 'Duration',
              label: Text(
                'Duration',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              )),
        ],
        rows: attempts
            .asMap()
            .map((index, attempt) {
              // Format dates and duration for display
              String formattedStartTime = DateFormat('yyyy-MM-dd – kk:mm').format(attempt.startTime);
              String formattedEndTime = DateFormat('yyyy-MM-dd – kk:mm').format(attempt.endTime);
              Duration duration = attempt.endTime.difference(attempt.startTime);

              String formattedDuration = '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
              Color bgColor = index % 2 == 1 ? Colors.transparent : Colors.grey.shade200;

              return MapEntry(
                  index,
                  DataRow(
                      color: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
                        return bgColor; // Use the bgColor for this row
                      }),
                      cells: [
                        DataCell(Text(attempt.examId)),
                        DataCell(Text(formattedStartTime)),
                        DataCell(Text(formattedEndTime)),
                        DataCell(Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                              color:
                                  attempt.result.name == ExamAttemptResult.pass.name ? Colors.lightGreen : Colors.red,
                            ),
                            child: Text(
                              attempt.result.name == ExamAttemptResult.pass.name ? 'Pass' : 'Fail',

                              // Assuming 'passed' is a boolean
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.right,
                            ))),
                        DataCell(Text('${attempt.score}')),
                        DataCell(Text(formattedDuration)),
                      ]));
            })
            .values
            .toList(), // Convert map entries back to a list
      );
    }

    /// Returns a Widget displaying details about a specific Exam, taken by the specific User.
    /// Input: the function takes in a Map<String, dynamic>, which stores information about an Exam
    /// `examData` is a Map<String, dynamic> containing the following keys:
    ///
    ///   - 'examId': The id of the exam.
    ///   - 'examTitle': The Title of the exam.
    Widget _getCourseExamWidget({required Map<String, dynamic> examData}) {
      Widget examDescription = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Text('${examData['examId']}'),
            // SizedBox(
            //   width: 20,
            // ),
            Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
            ),
            SizedBox(
              width: 10,
            ),
            Text('${examData['examTitle']}'),
          ],
        ),
      );
      return examDescription;
    }

    Widget _getCourseExamTitleWidget({required String examTitle, ExamStatus? examStatus}) {
      Widget examDescription = Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Text('${examData['examId']}'),
            // SizedBox(
            //   width: 20,
            // ),
            examStatus == ExamStatus.completed
                ? Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  )
                : Icon(
                    Icons.hourglass_top_rounded,
                    color: Colors.orangeAccent,
                  ),
            SizedBox(
              width: 10,
            ),
            Text('$examTitle'),
          ],
        ),
      );
      return examDescription;
    }

    void _updateBarDataOnMetricSelection(String? metricKey) {
      setState(() {
        _usersDataBarChart = updateUserDataOnDifferentMetricSelection(metricKey);
      });
    }

    void _updateSelectedMetricBarChart(String? selectedMetric) {
      setState(() {
        _updateBarDataOnMetricSelection(selectedMetric);
      });
    }

    /// Returns a list of Widgets, which contains a list of the Exams taken by the User for a specific Course, .
    /// It takes an input List<dynamic> attempts

    List<Widget> _getCourseExamsList({required Map<String, dynamic> allExamsTakenByUser}) {
      List<Widget> expansionTiles = [];
      for (var entry in allExamsTakenByUser.entries) {
        // The title widget for the ExpansionTile
        Widget titleWidget = _getCourseExamWidget(examData: entry.value);

        // The content widget for the ExpansionTile
        Widget contentWidget = _getExamAttemptsDataTable(entry.value['attempts']);

        expansionTiles.add(CustomExpansionTile(titleWidget: titleWidget, contentWidget: contentWidget));
      }

      return expansionTiles;
    }

    List<Widget> _getCourseExamsListOfWidgets({required List<UserExamProgress> examsProgressList}) {
      List<Widget> expansionTiles = [];
      for (UserExamProgress examProgressItem in examsProgressList) {
        // The title widget for the ExpansionTile
        Widget titleWidget =
            _getCourseExamTitleWidget(examTitle: examProgressItem.examTitle!, examStatus: examProgressItem.examStatus!);

        // The content widget for the ExpansionTile
        Widget contentWidget = _getExamAttemptDataTable(examProgressItem.examAttempts!);

        expansionTiles.add(Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: CustomExpansionTile(titleWidget: titleWidget, contentWidget: contentWidget)));
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
    Widget _courseDetailHeaderWidget({required Map<String, dynamic> courseDetails, int? index}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  courseDetails['completionStatus'] == true
                      ? Icons.check_circle_rounded // Icon for 'completed' status
                      : Icons.pending, // Icon for other statuses
                  color: courseDetails['completionStatus'] == true
                      ? Colors.green // Color for 'completed' status
                      : Colors.amber, // Color for other statuses
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.menu_book_rounded, color: Colors.black),
                          SizedBox(width: 20),
                          Text(
                            courseDetails['courseName'].toString(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3, // 40% of screen width

                          child: CustomLinearProgressIndicator(
                            value:
                                (courseDetails['completedSections'].length + courseDetails['completedExams'].length) /
                                    (courseDetails['courseSections'].length + courseDetails['courseExams'].length),
                            backgroundColor: Colors.grey[300]!,
                            valueColor: primary!,
                          ),
                        ),
                        SizedBox(width: 8),

                        // Text widget to display the percentage
                        Text(
                          '${((courseDetails['completedSections'].length + courseDetails['completedExams'].length) / (courseDetails['courseSections'].length + courseDetails['courseExams'].length) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: primary),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${(courseDetails['completedSections'].length + courseDetails['completedExams'].length)}/${(courseDetails['courseSections'].length + courseDetails['courseExams'].length).toString()})',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: getSecondaryTextColor()),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Widget to display the progress information.
          // It calculates the total number of completed sections and exams and
          // compares them with the total number of sections and exams in the course.
        ],
      );
    }

    Widget _courseDetailsHeaderWidget({required UserCourseProgress userCourseProgress, int? index}) {
      double completionPercentage =
          ((userCourseProgress.completedSections!.length + userCourseProgress.completedExams!.length) /
              (userCourseProgress.sectionsInCourse!.length + userCourseProgress.examsInCourse!.length));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the start (left)

        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(
                  userCourseProgress.courseCompleted == true
                      ? Icons.check_circle_rounded // Icon for 'completed' status
                      : Icons.pending, // Icon for other statuses
                  color: userCourseProgress.courseCompleted == true
                      ? Colors.green // Color for 'completed' status
                      : Colors.amber, // Color for other statuses
                ),
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.menu_book_rounded, color: Colors.black),
                          SizedBox(width: 20),
                          Text(
                            userCourseProgress.courseTitle.toString(),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3, // 40% of screen width

                          child: CustomLinearProgressIndicator(
                            value: completionPercentage,
                            backgroundColor: Colors.grey[300]!,
                            valueColor: primary!,
                          ),
                        ),
                        SizedBox(width: 8),

                        // Text widget to display the percentage
                        Text(
                          '${(completionPercentage * 100).toStringAsFixed(2)}%',
                          style: TextStyle(color: primary),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(${(userCourseProgress.completedSections!.length + userCourseProgress.completedExams!.length).toString()}'
                          '/${(userCourseProgress.sectionsInCourse!.length + userCourseProgress.examsInCourse!.length).toString()})',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: getSecondaryTextColor()),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Widget to display the progress information.
          // It calculates the total number of completed sections and exams and
          // compares them with the total number of sections and exams in the course.
        ],
      );
    }

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(context, loggedInState),
      drawer: IsmsDrawer(context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
          // FutureBuilder to asynchronously fetch user data.
          FutureBuilder<Map<String, dynamic>>(
            future: AdminDataHandler.getUser(loggedInState.currentUser!.uid), // The async function call
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
                // return Text(snapshot.data?['username'] ?? 'No name found');
                return Container(
                  margin: EdgeInsets.all(40),
                  child: UserProfileBanner(
                    userName: loggedInState.currentUser!.displayName!,
                    userEmail: loggedInState.currentUser!.email!,
                    userRole: loggedInState.currentUserRole,
                    adminState: adminState,
                    uid: loggedInState.currentUser!.uid,
                  ),
                );
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
          // FutureBuilder to asynchronously fetch course data for the user.

          FutureBuilder<dynamic>(
            future: adminState.retrieveAllDataFromDatabase(), // The async function call
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionHeader(title: 'Summary'),
                    _buildSummarySection(
                        adminState.getAllCoursesDataForCurrentUser(loggedInState.currentUser!.uid)['summary']),
                    buildSectionHeader(title: 'Progress Overview'),
                    Container(
                      margin: EdgeInsets.fromLTRB(80, 10, 80, 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: getTertiaryColor1()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        // itemCount: adminState.getAllCoursesDataForCurrentUser(uid)['coursesDetails'].length,
                        itemCount: userCourseDetailsList.length,
                        itemBuilder: (context, index) {
                          return CustomExpansionTile(
                            // Widget that displays header information for each course.
                            // titleWidget: _courseDetailHeaderWidget(
                            //   courseDetails: adminState
                            //       .getAllCoursesDataForCurrentUser(uid)['coursesDetails']
                            //       .values
                            //       .elementAt(index),
                            //   index: index,
                            // ),
                            titleWidget: _courseDetailsHeaderWidget(
                              userCourseProgress: userCourseDetailsList[index],
                              index: index,
                            ),
                            contentWidget:
                                // List of Widgets, that shows a list of exams for each course.
                                // _getCourseExamsList(
                                //     allExamsTakenByUser: adminState.getExamsProgressForCourseForUser(
                                //         uid,
                                //         adminState
                                //             .getAllCoursesDataForCurrentUser(uid)['coursesDetails']
                                //             .values
                                //             .elementAt(index)['courseId'])),
                                _getCourseExamsListOfWidgets(
                                    examsProgressList: userCourseDetailsList[index].examsProgressList!),
                            index: index,
                            length: userCourseDetailsList.length,
                            hasHoverBorder: true,
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
          buildSectionHeader(title: 'Activity'),
          Container(
            width: MediaQuery.of(context).size.width * 0.95,
            margin: EdgeInsets.fromLTRB(80, 10, 80, 30),
            decoration: BoxDecoration(
              border: Border.all(color: getTertiaryColor1()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 8,
                runSpacing: 8,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: HoverableSectionContainer(
                      onHover: (bool) {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User activity over time',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 40,
                          ),
                          CustomLineChartUserWidget(),
                        ],
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: HoverableSectionContainer(
                      onHover: (bool) {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Courses  performance overview',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 40,
                          ),
                          ChartMetricSelectWidget(
                            onMetricSelected: (selectedMetric) {
                              _updateSelectedMetricBarChart(selectedMetric);
                            },
                          ),
                          CustomBarChartUserWidget(
                              key: ValueKey(_usersDataBarChart), barChartValuesData: _usersDataBarChart),
                        ],
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: HoverableSectionContainer(
                      onHover: (bool) {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Courses progress by status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 40,
                          ),
                          CustomPieChartWidget(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSummarySection(snapshotData) {
    print(snapshotData);
    int summaryItemsLength = userSummaryData.length;
    return Container(
      margin: EdgeInsets.fromLTRB(80, 10, 80, 30),
      decoration: BoxDecoration(
        border: Border.all(color: getTertiaryColor1()),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // children: [
        //   SummaryItemWidget(
        //     title: 'Total Courses Enrolled',
        //     value: '${snapshotData['coursesEnrolled']}',
        //     index: 0,
        //     length: 4,
        //     type: 'number',
        //   ),
        //   SummaryItemWidget(
        //     title: 'Total Exams Taken',
        //     value: '${snapshotData['examsTaken']}',
        //     index: 1,
        //     length: 4,
        //     type: 'number',
        //   ),
        //   SummaryItemWidget(
        //     title: 'Average Score',
        //     value: '${snapshotData['averageScore']}',
        //     index: 2,
        //     length: 4,
        //     type: 'number',
        //   ),
        //   SummaryItemWidget(
        //     title: 'Completed',
        //     value: '${1 - snapshotData['inProgressCoursesPercent']}',
        //     index: 3,
        //     length: 4,
        //     type: 'percentage',
        //   ),
        // ],
        children: userSummaryData.asMap().entries.map((entry) {
          int index = entry.key;
          return SummaryItemWidget(
              title: entry.value.summaryTitle,
              value: entry.value.value.toString(),
              index: index,
              length: summaryItemsLength,
              type: entry.value.type.toString());
        }).toList(),
      ),
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
            color: _isHovered ? getPrimaryColorShade(50) : Colors.transparent, // Change color on hover
            borderRadius: _getBorderRadius(), // Set the border radius based on index
            border: _isHovered ? Border.all(color: primary!) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.black,
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
                        color: getTertiaryColor1(),
                        width: 1,
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.value,
                          style: TextStyle(
                            color: primary,
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
                              value: double.parse(widget.value), // Convert percentage to a value between 0 and 1
                              strokeWidth: 6.0, // The thickness of the progress bar
                              backgroundColor: getPrimaryColorShade(50), // Background color of the progress bar
                              color: primary, // Progress color
                            ),
                          ),
                          Text(
                            '${(double.parse(widget.value) * 100).toStringAsFixed(0)}%', // The percentage text
                            style: TextStyle(fontSize: 30, color: primary),
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
