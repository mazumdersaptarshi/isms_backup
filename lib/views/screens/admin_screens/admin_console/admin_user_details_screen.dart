import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:isms/controllers/admin_management/admin_data.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/admin_console/user_courses_list.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:provider/provider.dart';

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
    final String uid = 'gZZg3iv6e2YsoMXlMrXIVgf6Ycl2';
    Map<String, dynamic> _coursesDetails = {};
    Map _userAllData = {};

    Future<Map<String, dynamic>> _fetchAllCoursesDataForUser({required String uid}) async {
      _userAllData = await adminState.getAllDataForUser(uid);
      _coursesDetails = await adminState.buildUserCoursesDetailsMapUserDetailsPage(userAllData: _userAllData);
      return _coursesDetails;
    }

    Map<String, dynamic> _fetchAllExamsProgressDataForCourseForUser({required String uid, required String courseId}) {
      return adminState.getExamsProgressForCourseForUser(uid, courseId);
    }

    Widget _attemptWidget({required Map<String, dynamic> attempt}) {
      Widget attemptWidget = Row(
        children: [
          Text('${attempt['attemptId']}'),
          SizedBox(
            width: 20,
          ),
          Text('${attempt['startTime']}'),
          SizedBox(
            width: 20,
          ),
          Text('${attempt['completionStatus']}'),
          SizedBox(
            width: 20,
          ),
          Text('${attempt['score']}'),
          SizedBox(
            width: 20,
          ),
          Text('${attempt['responses']}'),
        ],
      );
      return attemptWidget;
    }

    List<Widget> _examAttemptsList(List<dynamic> attempts) {
      List<Widget> attemptWidgets = [];
      for (var attempt in attempts) {
        attemptWidgets.add(_attemptWidget(attempt: attempt));
      }
      return attemptWidgets;
    }

    Widget _courseExamWidget({required Map<String, dynamic> examData}) {
      Widget courseDescription = Row(
        children: [
          Text('${examData['examId']}'),
          SizedBox(
            width: 20,
          ),
          Text('${examData['examTitle']}'),
        ],
      );
      return courseDescription;
    }

    List<Widget> _courseExamsList({required Map<String, dynamic> allExamsTakenByUser}) {
      List<Widget> widgets = [];
      for (var entry in allExamsTakenByUser.entries) {
        widgets.add(_courseExamWidget(examData: entry.value));

        widgets.addAll(_examAttemptsList(entry.value['attempts']));
      }

      return widgets;
    }

    return Scaffold(
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
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
                // print('snapshotdata: ${snapshot.data?.values}');
                return Column(
                  children: [
                    // Text(snapshot.data?.toString() ?? 'No courses found'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        // String? key = snapshot.data?.keys.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    'course: ${snapshot.data!.values.elementAt(index)['courseName'].toString()}',
                                  ),
                                ),
                                Text(
                                  '(${snapshot.data!.values.elementAt(index)['completedSections']} + '
                                  ' ${snapshot.data!.values.elementAt(index)['completedExams']}) /  ${snapshot.data!.values.elementAt(index)['courseItemsLength']}',
                                ),
                                ..._courseExamsList(
                                    allExamsTakenByUser: _fetchAllExamsProgressDataForCourseForUser(
                                        uid: uid, courseId: snapshot.data!.values.elementAt(index)['courseId'])),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              } else {
                // Handle the case when there's no data
                return Text('No data available');
              }
            },
          ),
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
