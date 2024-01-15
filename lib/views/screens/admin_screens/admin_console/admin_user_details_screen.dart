import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:isms/controllers/admin_management/admin_data.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:provider/provider.dart';

class AdminUserDetailsScreen extends StatefulWidget {
  const AdminUserDetailsScreen({super.key});

  @override
  State<AdminUserDetailsScreen> createState() => _AdminUserDetailsScreenState();
}

class _AdminUserDetailsScreenState extends State<AdminUserDetailsScreen> {
  late AdminState adminState;

  @override
  void initState() {
    super.initState();
    adminState = AdminState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    final String uid = 'gZZg3iv6e2YsoMXlMrXIVgf6Ycl2';

    Future<Map<String, dynamic>> userCourseMap(String uid) async {
      Map courses = await adminState.getCoursesForUser(uid);
      Map<String, dynamic> coursesDetails = {};

      for (var entry in courses.entries) {
        print(entry.value.completionStatus);
        Map fetchedCourse =
            await CourseProvider.getCourseByIDLocal(courseId: entry.key);
        coursesDetails[entry.key] = {
          'courseId': fetchedCourse['courseId'],
          'courseName': fetchedCourse['courseName'],
          'completionStatus': entry.value.completionStatus
        };
      }

      return coursesDetails;
    }

    Widget examAttempts(Map<String, dynamic> examAttempts) {
      print(examAttempts);
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
            Text(value.score.toString()),
          ],
        ));
      });
      return Column(
        children: attemptsList,
      );
    }

    return Scaffold(
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(
                backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
          FutureBuilder<Map<String, dynamic>>(
            future: AdminData.getUser(uid), // The async function call
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
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
            future: userCourseMap(uid), // The async function call
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the data
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle the error case
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // Data is fetched successfully, display the user's name
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
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5)),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    snapshot.data!.values
                                        .elementAt(index)
                                        .toString(),
                                  ),
                                ),
                                Text(
                                    '${AdminState().getExamsForCourseForUser(uid, snapshot.data!.values.elementAt(index)['courseId'])}'),
                                for (var entry in AdminState()
                                    .getExamsForCourseForUser(
                                        uid,
                                        snapshot.data!.values
                                            .elementAt(index)['courseId'])
                                    .entries)
                                  Column(
                                    children: [
                                      examAttempts(entry.value.attempts)
                                    ],
                                  ),
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
        ],
      ),
    );
  }
}
