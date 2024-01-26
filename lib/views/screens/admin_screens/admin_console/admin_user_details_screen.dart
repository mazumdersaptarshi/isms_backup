import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:hive/hive.dart';
import 'package:isms/controllers/admin_management/admin_data.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/common_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/admin_console/user_courses_list.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:line_icons/line_icons.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  const AdminUserDetailsScreen({super.key});

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  late AdminState adminState;
  List<Map<String, dynamic>> userData = [
    {
      'courseName': 'Python Fundamentals',
      'isEnrolled': true,
      'status': 'In progress',
      'attempts': [
        {
          'date': '2023-01-15',
          'attempt': 1,
          'score': 75,
          'result': 'Pass',
        },
        {
          'date': '2023-02-15',
          'attempt': 2,
          'score': 80,
          'result': 'Pass',
        },
        {
          'date': '2023-03-15',
          'attempt': 3,
          'score': 85,
          'result': 'Pass',
        },
      ],
    },
    // ... Other course data
  ];

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    final String uid = 'gZZg3iv6e2YsoMXlMrXIVgf6Ycl2'; //Sample UserID for testing
    Map<String, dynamic> _coursesDetails = {};
    Map _userAllData = {};

    /// Returns a [Future<Map<String, dynamic>>] that fetches all course progress
    /// data stored in the database for the given user.
    Future<Map<String, dynamic>> _fetchAllCoursesDataForUser({required String uid}) async {
      _userAllData = await adminState.getAllDataForUser(uid);
      _coursesDetails = await adminState.buildUserCoursesDetailsMapUserDetailsPage(userAllData: _userAllData);
      return _coursesDetails;
    }

    /// Returns a map containing the exam progress data for a specific course and user.
    /// The map includes detailed information about each exam attempt within the specified course.
    Map<String, dynamic> _fetchAllExamsProgressDataForCourseForUser({required String uid, required String courseId}) {
      return adminState.getExamsProgressForCourseForUser(uid, courseId);
    }

    Widget _getAattemptDetailsWidget({required dynamic data}) {
      return Text(
        data.toString(),
      );
    }

    /// Returns a Widget displaying information about a specific exam attempt.
    /// `attempt` is a Map<String, dynamic> containing the following keys:
    ///
    ///   - 'attemptId': The id of the attempt.
    ///   - 'startTime': The start time of the exam (eg. 2024-01-24 09:29:04.066).
    ///   - 'endTime': The end time of the exam (eg. 2024-01-24 10:30:40.234).
    ///   - 'score': The score in that attempt (eg. 40).
    ///   - 'responses': A list of the responses i.e. the questions and the answers the user selected in that attempt
    Widget _getAttemptWidget({required Map<String, dynamic> attempt}) {
      Widget attemptWidget = Row(
        children: [
          _getAattemptDetailsWidget(data: attempt['attemptId']),
          SizedBox(
            width: 20,
          ),
          _getAattemptDetailsWidget(data: attempt['startTime']),
          SizedBox(
            width: 20,
          ),
          _getAattemptDetailsWidget(data: attempt['completionStatus']),
          SizedBox(
            width: 20,
          ),
          _getAattemptDetailsWidget(data: attempt['score']),
          SizedBox(
            width: 20,
          ),
          _getAattemptDetailsWidget(data: attempt['responses']),
        ],
      );
      return attemptWidget;
    }

    /// Returns a list of Widgets, each representing an exam attempt.
    /// It takes an input List<dynamic> attempts
    List<Widget> _getExamAttemptsList(List<dynamic> attempts) {
      List<Widget> attemptWidgets = [];
      for (var attempt in attempts) {
        attemptWidgets.add(_getAttemptWidget(attempt: attempt));
      }
      return attemptWidgets;
    }

    Widget _getExamAttemptsDataTable(List<dynamic> attempts) {
      List<DataColumn> columns = [
        DataColumn(label: Text('Attempt ID')),
        DataColumn(label: Text('Start Time')),
        DataColumn(label: Text('Completion Status')),
        DataColumn(label: Text('Score')),
        DataColumn(label: Text('Responses')),
        // Add more DataColumn if you have more fields in each attempt
      ];
      List<DataRow> rows = attempts.map<DataRow>((attempt) {
        return DataRow(cells: [
          DataCell(Text(attempt['attemptId'].toString())),
          DataCell(Text(attempt['startTime'].toString())),
          DataCell(Text(attempt['completionStatus'].toString())),
          DataCell(Text(attempt['score'].toString())),
          DataCell(Text(attempt['responses'].toString())),
          // Add more DataCell if you have more fields in each attempt
        ]);
      }).toList();
      return DataTable(columns: columns, rows: rows);
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

    /// Returns a list of Widgets, which contains a list of the Exams taken by the User for a specific Course, .
    /// It takes an input List<dynamic> attempts

    List<Widget> _getCourseExamsList({required Map<String, dynamic> allExamsTakenByUser}) {
      List<Widget> expansionTiles = [];
      for (var entry in allExamsTakenByUser.entries) {
        // The title widget for the ExpansionTile
        Widget titleWidget = _getCourseExamWidget(examData: entry.value);

        // The content widget for the ExpansionTile
        Widget contentWidget = _getExamAttemptsDataTable(entry.value['attempts']);

        // Create an ExpansionTile and add it to the list
        expansionTiles.add(ExpansionTile(
          title: titleWidget,
          children: [contentWidget],
        ));
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
                  courseDetails['completionStatus'] == 'completed'
                      ? Icons.check_circle_outline // Icon for 'completed' status
                      : Icons.pending, // Icon for other statuses
                  color: courseDetails['completionStatus'] == 'completed'
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
                            valueColor: getPrimaryColor(),
                          ),
                        ),
                        SizedBox(width: 8),

                        // Text widget to display the percentage
                        Text(
                          '${((courseDetails['completedSections'].length + courseDetails['completedExams'].length) / (courseDetails['courseSections'].length + courseDetails['courseExams'].length) * 100).toStringAsFixed(0)}%',
                          style: TextStyle(color: getPrimaryColor()),
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

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
          // FutureBuilder to asynchronously fetch user data.
          FutureBuilder<Map<String, dynamic>>(
            future: AdminData.getUser(uid), // The async function call
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Data is fetched successfully, display the user's name
                return Text(snapshot.data?['username'] ?? 'No name found');
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
          // FutureBuilder to asynchronously fetch course data for the user.

          FutureBuilder<Map<String, dynamic>>(
            future: _fetchAllCoursesDataForUser(uid: uid), // The async function call
            builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Data is fetched successfully, display the user's name
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(150, 30, 150, 0),
                      child: Text(
                        'All Courses',
                        style: TextStyle(fontSize: 30, color: Colors.grey.shade600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(150, 10, 150, 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: getTertiaryColor1()),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          // ListView.builder creates a list of course and exam details.
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              // String? key = snapshot.data?.keys.elementAt(index);
                              return ClipRRect(
                                borderRadius: (index == 0)
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      )
                                    : (index == (snapshot.data!.length - 1))
                                        ? BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          )
                                        : BorderRadius.zero,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(width: 1, color: getTertiaryColor1()),
                                    )),
                                    child: ExpansionTile(
                                      // Widget that displays header information for each course.
                                      title: _courseDetailHeaderWidget(
                                        courseDetails: snapshot.data!.values.elementAt(index),
                                        index: index,
                                      ),
                                      children: [
                                        // List of Widgets, that shows a list of exams for each course.
                                        ..._getCourseExamsList(
                                            allExamsTakenByUser: _fetchAllExamsProgressDataForCourseForUser(
                                                uid: uid,
                                                courseId: snapshot.data!.values.elementAt(index)['courseId'])),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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
          //The part below is just an example for demonstration purposes only
          Text(
            'User Details',
            style: Theme.of(context).textTheme.headline4,
          ),
          UserCoursesList(userData: userData)
        ],
      ),
    );
  }
}
