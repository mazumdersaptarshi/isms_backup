import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/userManagement/userprofileHeaderWidget.dart';
import 'package:provider/provider.dart';

import '../../userManagement/userDataGetterMaster.dart';

List allEnrolledCourses = [];
List allCompletedCourses = [];

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool hasCheckedForChangedDependencies = false;
  final List<UserActions> userActions = [
    UserActions(
        name: 'Dashboard', icon: Icons.dashboard, actionId: 'dashboard'),
    UserActions(name: 'Reports', icon: Icons.description, actionId: 'reports'),
    UserActions(
        name: 'Courses Enrolled', icon: Icons.school, actionId: 'crs_enrl'),
    UserActions(
        name: 'Courses Completed', icon: Icons.check, actionId: 'crs_compl'),
    UserActions(name: 'Exams', icon: Icons.assignment, actionId: 'exms'),
    UserActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
  ];

  @override
  void initState() {
    super.initState();
    UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
    print('abcdef: ${userDataGetterMaster.currentUserEmail}');
    allEnrolledCourses = [];
    allCompletedCourses = [];
  }

  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasCheckedForChangedDependencies) {
      LoggedInUserProvider loggedInUserProvider =
          Provider.of<LoggedInUserProvider>(context, listen: true);
      if (mounted) {
        print(" I AM ${loggedInUserProvider.loggedInUser!.email} ");
        await loggedInUserProvider.fetchAllCoursesUser();
        setState(() {
          allEnrolledCourses = LoggedInUserProvider.allEnrolledCoursesGlobal;
          allCompletedCourses = LoggedInUserProvider.allCompletedCoursesGlobal;
          print("PRINTTTT ${LoggedInUserProvider.allEnrolledCoursesGlobal}");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Column(
        children: [
          Expanded(child: UserProfileHeaderWidget()),
          Expanded(
              flex: 2,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final action = userActions[index];

                    return ExpansionTile(
                      leading: Icon(action.icon),
                      title: Text(action.name!),
                      onExpansionChanged: (expanded) async {
                        if (expanded) {
                          LoggedInUserProvider loggedInUserProvider =
                              await Provider.of<LoggedInUserProvider>(context,
                                  listen: false);
                          await loggedInUserProvider
                              .currentUserCoursesGetter(action.actionId);
                        }
                      },
                      children: [
                        UserActionsDropdown(
                          actionId: action.actionId!,
                        ),
                      ],
                    );
                  }))
        ],
      ),
    );
  }
}

class UserActionsDropdown extends StatelessWidget {
  UserActionsDropdown({super.key, required this.actionId});
  String actionId;
  @override
  Widget build(BuildContext context) {
    print(actionId);
    if (actionId == 'crs_enrl') {
      return UserEnrolledCoursesDropdown(
        actionId: actionId,
      );
    }
    // else if (actionId == 'crs_compl') {
    //   return Column(
    //     children: [
    //       FutureBuilder<List<dynamic>>(
    //           future: loggedInUserProvider.getAllCompletedCoursesList(),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.waiting) {
    //               return CircularProgressIndicator();
    //             } else if (snapshot.hasError) {
    //               return Text('Error: ${snapshot.error}');
    //             } else if (snapshot.hasData && snapshot.data != null) {
    //               return ListView.builder(
    //                 itemCount: snapshot.data!.length,
    //                 shrinkWrap: true,
    //                 itemBuilder: (context, index) {
    //                   print('SnapshotData: ${snapshot.data![index]}');
    //                   return Text('${snapshot.data![index]['course_name']}');
    //                 },
    //               );
    //             } else {
    //               return Text('No data');
    //             }
    //           })
    //     ],
    //   );
    // }
    else if (actionId == 'crs_compl') {
      return UserCompletedCoursesDropdown(
        actionId: actionId,
      );
    } else {
      return Text('No Data to show!');
    }
  }
}

class UserEnrolledCoursesDropdown extends StatelessWidget {
  String? actionId;
  UserEnrolledCoursesDropdown({this.actionId});
  (bool, double, int) getCourseCompletedPercentage({
    required CoursesProvider coursesProvider,
    required int index,
  }) {
    double courseCompletionPercentage = 0;
    int noOfExams = 0;
    bool isValid = false;
    print('Enrolled CoursesDropdown');
    print(actionId);
    allEnrolledCourses = LoggedInUserProvider.allEnrolledCoursesGlobal;
    allEnrolledCourses.forEach((course) {
      if (course["modules_completed"] != null) {
        int modulesCount = 0;

        for (int i = 0; i < coursesProvider.allCourses.length; i++) {
          var element = coursesProvider.allCourses[i];

          if (element.name == allEnrolledCourses![index]["course_name"]) {
            modulesCount = element.modulesCount!;
            noOfExams = element.examsCount!;
            isValid = true;
          }
        }

        int modulesCompletedCount =
            allEnrolledCourses![index]["modules_completed"] != null
                ? allEnrolledCourses![index]["modules_completed"].length
                : 0;
        if (isValid) {
          courseCompletionPercentage = modulesCompletedCount / modulesCount;
        }
      }
    });
    return (isValid, courseCompletionPercentage, noOfExams);
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    LoggedInUserProvider loggedInUserProvider =
        Provider.of<LoggedInUserProvider>(context, listen: false);
    return Column(
      children: [
        FutureBuilder<List>(
          future: loggedInUserProvider.currentUserCoursesGetter('crs_enrl'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            }
            return ListView.builder(
              itemCount: LoggedInUserProvider.allEnrolledCoursesGlobal.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                double courseCompletionPercentage = 0;
                bool isValid = false;
                int noOfExams = 0;
                var (a, b, c) = getCourseCompletedPercentage(
                  coursesProvider: coursesProvider,
                  index: index,
                );
                isValid = a;
                noOfExams = c;
                courseCompletionPercentage = b;
                return Container(
                  height: 120,
                  child: Column(
                    children: [
                      ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${allEnrolledCourses![index]['course_name']} ',
                              style: TextStyle(fontSize: 14),
                            ),
                            if (isValid)
                              Text(
                                  "${(courseCompletionPercentage * 100).ceil().toString()} %")
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            if (allEnrolledCourses![index]
                                    ["modules_completed"] !=
                                null)
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: 40,
                                    maxWidth:
                                        MediaQuery.of(context).size.width - 40),
                                child: Column(
                                  children: List.generate(
                                      allEnrolledCourses![index]
                                              ["modules_completed"]
                                          .length, (moduleIndex) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '-> ${allEnrolledCourses![index]["modules_completed"][moduleIndex]}',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (allEnrolledCourses![index]['exams_completed'] != null)
                        Row(
                          children: [
                            Text("Exams passed: "),
                            Text(
                              '${allEnrolledCourses![index]['exams_completed'].length} of ${noOfExams}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class UserCompletedCoursesDropdown extends StatelessWidget {
  String? actionId;
  UserCompletedCoursesDropdown({this.actionId});
  @override
  Widget build(BuildContext context) {
    LoggedInUserProvider loggedInUserProvider =
        Provider.of<LoggedInUserProvider>(context, listen: false);
    return Column(
      children: [
        FutureBuilder<List>(
          future: loggedInUserProvider.currentUserCoursesGetter('crs_compl'),
          builder: (context, snapshot) {
            print(
                'gbvvb: ${loggedInUserProvider.currentUserCoursesGetter('crs_compl')}');
            return ListView.builder(
              itemCount: LoggedInUserProvider.allCompletedCoursesGlobal.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                allCompletedCourses =
                    LoggedInUserProvider.allCompletedCoursesGlobal;
                return ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${allCompletedCourses![index]['course_name']} ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Icon(Icons.check_circle, color: Colors.green)
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
