// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
// import 'package:isms/screens/analyticsSharedWidgets/courseDropdownWidget.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/userManagement/userprofileHeaderWidget.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import '../../sharedWidgets/analyticsSharedWidgets/courseDropdownWidget.dart';
import '../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
// import '../analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';

List allEnrolledCourses = [];
List allCompletedCourses = [];

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool hasCheckedForChangedDependencies = false;
  final List<UserActions> userActions = [
    // UserActions(
    // //     name: 'Dashboard', icon: Icons.dashboard, actionId: 'dashboard'),
    // UserActions(name: 'Reports', icon: Icons.description, actionId: 'reports'),
    UserActions(
        name: 'Courses Enrolled', icon: Icons.school, actionId: 'crs_enrl'),
    UserActions(
        name: 'Courses Completed', icon: Icons.check, actionId: 'crs_compl'),
    // UserActions(name: 'Exams', icon: Icons.assignment, actionId: 'exms'),
    // UserActions(name: 'Logout', icon: Icons.exit_to_app, actionId: 'logout'),
  ];

  @override
  void initState() {
    super.initState();
    allEnrolledCourses = [];
    allCompletedCourses = [];
  }

  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    return Scaffold(
      backgroundColor: primaryColor.shade100,
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurpleAccent.shade100,
            expandedHeight: 300.0,
            automaticallyImplyLeading: false,
            flexibleSpace: const FlexibleSpaceBar(
                background: UserProfileHeaderWidget(
              view: 'user',
            )),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(userActions.length, (index) {
                  final action = userActions[index];
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: (MediaQuery.of(context).size.width > 1000
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width) *
                          0.98,
                      // maxWidth: MediaQuery.of(context).size.width * 0.9,
                    ),
                    child: ExpansionTile(
                      leading: Icon(action.icon),
                      title: Text(action.name!),
                      onExpansionChanged: (expanded) async {
                        if (expanded) {
                          // await loggedInState
                          //     .getUserCoursesData(action.actionId);
                        }
                      },
                      children: [
                        UserActionsDropdown(
                          actionId: action.actionId!,
                          loggedInState: loggedInState,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
    );
  }
}

class UserActionsDropdown extends StatelessWidget {
  const UserActionsDropdown(
      {super.key, required this.actionId, required this.loggedInState});
  final String actionId;
  final LoggedInState loggedInState;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(actionId);
    }
    if (actionId == 'crs_enrl') {
      return UserEnrolledCoursesDropdown(
        actionId: actionId,
        loggedInState: loggedInState,
      );
    } else if (actionId == 'crs_compl') {
      return UserCompletedCoursesDropdown(
        actionId: actionId,
      );
    } else {
      return const Text('No Data to show!');
    }
  }
}

class UserEnrolledCoursesDropdown extends StatelessWidget {
  final String? actionId;

  final LoggedInState loggedInState;
  const UserEnrolledCoursesDropdown(
      {super.key, this.actionId, required this.loggedInState});

  (bool, double, int) getCourseCompletedPercentage({
    required CoursesProvider coursesProvider,
    required int index,
  }) {
    double courseCompletionPercentage = 0;
    int noOfExams = 0;
    bool isValid = false;
    debugPrint('Enrolled CoursesDropdown');
    if (kDebugMode) {
      print(actionId);
    }

    allEnrolledCourses = loggedInState.allEnrolledCoursesGlobal;

    for (var _ in allEnrolledCourses) {
      int modulesCount = 0;

      for (int i = 0; i < coursesProvider.allCourses.length; i++) {
        var element = coursesProvider.allCourses[i];

        if (element.name == allEnrolledCourses[index]["course_name"]) {
          modulesCount = element.modulesCount!;
          noOfExams = element.examsCount!;
          isValid = true;
        }
      }

      int modulesCompletedCount =
          allEnrolledCourses[index]["modules_completed"] != null
              ? allEnrolledCourses[index]["modules_completed"].length
              : 0;
      if (isValid) {
        courseCompletionPercentage = modulesCompletedCount / modulesCount;
      }
    }
    return (isValid, courseCompletionPercentage, noOfExams);
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    LoggedInState loggedInState =
        Provider.of<LoggedInState>(context, listen: false);

    return Column(
      children: [
        FutureBuilder<List>(
          future: loggedInState.getUserCoursesData('crs_enrl'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No data available');
            }
            return ListView.builder(
              itemCount: loggedInState.allEnrolledCoursesGlobal.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                // ignore: unused_local_variable
                double courseCompletionPercentage = 0;
                // ignore: unused_local_variable
                bool isValid = false;
                // ignore: unused_local_variable
                int noOfExams = 0;
                var (a, b, c) = getCourseCompletedPercentage(
                  coursesProvider: coursesProvider,
                  index: index,
                );
                isValid = a;
                noOfExams = c;
                courseCompletionPercentage = b;

                return UserCourseStartedDetailsWidget(
                  courseItem: allEnrolledCourses[index],
                  coursesProvider: coursesProvider,
                  index: index,
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
  final String? actionId;
  const UserCompletedCoursesDropdown({super.key, this.actionId});
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState =
        Provider.of<LoggedInState>(context, listen: false);
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FutureBuilder<List>(
            future: loggedInState.getUserCoursesData('crs_compl'),
            builder: (context, snapshot) {
              if (loggedInState.allCompletedCoursesGlobal.isNotEmpty) {
                return ListView.builder(
                  itemCount: loggedInState.allCompletedCoursesGlobal.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemBuilder: (context, index) {
                    allCompletedCourses =
                        loggedInState.allCompletedCoursesGlobal;
                    debugPrint(
                        'ALLCOMPLETEDCOURSESGLOBAL: ${loggedInState.allCompletedCoursesGlobal}');
                    return CourseDropdownWidget(
                      courseItem: allCompletedCourses[index],
                      detailType: 'courses_completed',
                    );
                  },
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
        ],
      ),
    );
  }
}
