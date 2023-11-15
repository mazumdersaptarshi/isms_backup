import 'package:flutter/material.dart';
import 'package:isms/models/UserActions.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
// import 'package:isms/screens/analyticsSharedWidgets/courseDropdownWidget.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/userManagement/userprofileHeaderWidget.dart';
import 'package:isms/utilityFunctions/getCourseCompletedPercentage.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import '../../sharedWidgets/analyticsSharedWidgets/courseDropdownWidget.dart';
import '../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
// import '../analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';

List allEnrolledCourses = [];
List allCompletedCourses = [];

class UserProfilePage extends StatefulWidget {
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

  refreshCallback() {
    setState(() {
      print("Refresshhhh ");
    });
  }
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade100,
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.deepPurpleAccent.shade100,
            expandedHeight: 300.0,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
                background: UserProfileHeaderWidget(
              view: 'user',
              refreshCallback: refreshCallback(),
            )),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: BoxDecoration(
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
                      maxWidth: MediaQuery.of(context).size.width >
                              SCREEN_COLLAPSE_WIDTH
                          ? MediaQuery.of(context).size.width * 0.5
                          : MediaQuery.of(context).size.width,
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
    );
  }
}

class UserActionsDropdown extends StatelessWidget {
  UserActionsDropdown(
      {super.key, required this.actionId, required this.loggedInState});
  String actionId;
  LoggedInState loggedInState;
  @override
  Widget build(BuildContext context) {
    print(actionId);
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
      return Text('No Data to show!');
    }
  }
}

class UserEnrolledCoursesDropdown extends StatelessWidget {
  String? actionId;

  LoggedInState loggedInState;
  UserEnrolledCoursesDropdown({this.actionId, required this.loggedInState});

  (bool, double, int) getCourseCompletedPercentage({
    required CoursesProvider coursesProvider,
    required int index,
  }) {
    double courseCompletionPercentage = 0;
    int noOfExams = 0;
    bool isValid = false;
    print('Enrolled CoursesDropdown');
    print(actionId);

    allEnrolledCourses = loggedInState.allEnrolledCoursesGlobal;

    allEnrolledCourses.forEach((course) {
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
    });
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
              return CircularProgressIndicator();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data available');
            }
            return ListView.builder(
              itemCount: loggedInState.allEnrolledCoursesGlobal.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
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

                return UserCourseStartedDetailsWidget(
                  courseItem: allEnrolledCourses![index],
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
  String? actionId;
  UserCompletedCoursesDropdown({this.actionId});
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState =
        Provider.of<LoggedInState>(context, listen: false);
    CoursesProvider coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    return Column(
      children: [
        FutureBuilder<List>(
          future: loggedInState.getUserCoursesData('crs_compl'),
          builder: (context, snapshot) {
            if (loggedInState.allCompletedCoursesGlobal.length > 0) {
              return ListView.builder(
                itemCount: loggedInState.allCompletedCoursesGlobal.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (context, index) {
                  allCompletedCourses = loggedInState.allCompletedCoursesGlobal;
                  print(
                      'ALLCOMPLETEDCOURSESGLOBAL: ${loggedInState.allCompletedCoursesGlobal}');

                  return CourseDropdownWidget(
                    courseItem: allCompletedCourses![index],
                    courseDetailsData: getCourseCompletedPercentage(
                        allCompletedCourses![index], coursesProvider, index),
                    detailType: 'courses_completed',
                  );
                },
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ],
    );
  }
}
