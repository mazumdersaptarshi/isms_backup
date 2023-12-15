// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/views/widgets/user_screens_widgets/user_actions.dart';
// import 'package:isms/screens/analyticsSharedWidgets/course_dropdown_widget.dart';
// import 'package:isms/screens/login/login_screen.dart';
// import 'package:isms/themes/common_theme.dart';
// import 'package:isms/userManagement/logged_in_state.dart';
// import 'package:isms/userManagement/user_profile_header_widget.dart';
// import 'package:isms/utilityFunctions/getCourseCompletedPercentage.dart';
// import 'package:isms/utilityFunctions/platform_check.dart';
import 'package:provider/provider.dart';

import '../../../controllers/theme_management/common_theme.dart';
import '../../../controllers/user_management/logged_in_state.dart';
// import '../../../sharedWidgets/analyticsSharedWidgets/course_dropdown_widget.dart';
// import '../../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
// import '../../sharedWidgets/analyticsSharedWidgets/course_dropdown_widget.dart';
// import '../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';

import '../../../utilities/platform_check.dart';
import '../../widgets/user_screens_widgets/user_profile_header_widget.dart';
import '../authentication/login_screen.dart';
// import '../../controllers/themes/common_theme.dart';
// import '../../controllers/userManagement/logged_in_state.dart';
// import '../../controllers/userManagement/user_profile_header_widget.dart';
// import '../../sharedWidgets/analyticsSharedWidgets/course_dropdown_widget.dart';
// import '../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
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

  refreshCallback() {
    setState(() {});
  }
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
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
              refreshCallback: refreshCallback,
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
                      children: [],
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
