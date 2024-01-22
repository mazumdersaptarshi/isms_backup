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
    Map<String, dynamic> coursesDetails = {};
    Map<String, dynamic> examDetails = {};
    Map<String, dynamic> userAllData = {};

    Future<Map<String, dynamic>> fetchAllDataForUser(String uid) async {
      Map userAllData = await adminState.getAllDataForUser(uid);
      Map userCourses = userAllData['courses'];
      Map userExams = userAllData['exams'];
      print('EXAMS: $userExams');
      for (var courseProgressItem in userCourses.entries) {
        //gets the course details from the database
        Map fetchedCourse = await CourseProvider.getCourseByID(courseId: courseProgressItem.key);
        int fetchedCourseSectionsLength =
            await CourseProvider.getSectionsCountForCourse(courseId: courseProgressItem.key);
        int fetchedExamsCount = await ExamProvider.getExamsCountForCourse(courseId: courseProgressItem.key);
        List fetchedCourseExams = await ExamProvider.getExamsByCourseId(courseId: courseProgressItem.key);

        coursesDetails[courseProgressItem.key] = {
          'courseId': fetchedCourse['courseId'],
          'courseName': fetchedCourse['courseName'],
          'courseSections': fetchedCourse['courseSections'],
          'courseItemsLength': fetchedCourseSectionsLength + fetchedExamsCount,
          'courseExams': fetchedCourseExams,
          'completionStatus': courseProgressItem.value.completionStatus,
          'completedSections': courseProgressItem.value.completedSections,
          'completedExams': courseProgressItem.value.completedExams,
          'userExams': userExams,
        };
      }

      return coursesDetails;
    }

    void examsMap({required Map<String, dynamic> allExams}) {}

    Widget examAttempts(Map<String, dynamic> examAttempts) {
      List<Widget> attemptsList = [];
      examAttempts.forEach((key, value) {
        attemptsList.add(Row(
          children: [
            Text(value.attemptId.toString()),
            SizedBox(
              width: 10,
            ),
            Text(value.startTime.toString()),
            SizedBox(
              width: 10,
            ),
            Text(value.completionStatus.toString()),
            SizedBox(
              width: 10,
            ),
            Text('${value.score.toString()}%'),
          ],
        ));
      });
      return Column(
        children: attemptsList,
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
            future: fetchAllDataForUser(uid), // The async function call
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
                                  // title: Text(
                                  //   'course: ${snapshot.data!.values.elementAt(index).toString()}',
                                  // ),
                                  title: Text(
                                    'course: ${snapshot.data!.values.elementAt(index)['courseName'].toString()}',
                                  ),
                                ),
                                Text(
                                  '(${snapshot.data!.values.elementAt(index)['completedSections']} + '
                                  ' ${snapshot.data!.values.elementAt(index)['completedExams']}) /  ${snapshot.data!.values.elementAt(index)['courseItemsLength']}',
                                ),
                                // Text(
                                //   '${AdminState().getExamsProgressForCourseForUser(uid, snapshot.data!.values.elementAt(index)['courseId'])}',
                                // ),
                                // for (var entry in AdminState()
                                //     .getExamsProgressForCourseForUser(
                                //         uid, snapshot.data!.values.elementAt(index)['courseId'])
                                //     .entries)
                                //   Column(
                                //     children: [
                                //       examAttempts(entry.value.attempts),
                                //     ],
                                //   ),
                                for (var entry in AdminState()
                                    .getExamsProgressForCourseForUser(
                                        uid, snapshot.data!.values.elementAt(index)['courseId'])
                                    .entries)
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          '${entry.toString()}',
                                          style: TextStyle(
                                            backgroundColor: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
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