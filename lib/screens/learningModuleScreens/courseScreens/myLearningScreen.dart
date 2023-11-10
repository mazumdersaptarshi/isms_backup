import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../sharedWidgets/bottomNavBar.dart';
import '../../../sharedWidgets/navIndexTracker.dart';
import '../../../themes/common_theme.dart';
import '../../../userManagement/loggedInState.dart';
import '../../../utilityFunctions/platformCheck.dart';
import '../../homePageFunctions/getCoursesList.dart';
import '../../login/loginScreen.dart';
import 'createCourseScreen.dart';
import 'moduleScreens/modulesListScreen.dart';

class MyLearningScreen extends StatefulWidget {
  MyLearningScreen({super.key});
  String userRole = "user";
  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    widget.userRole = loggedInState.currentUserRole;
    List<dynamic> userEnrolledCourses = loggedInState.allEnrolledCoursesGlobal;
    NavIndexTracker.setNavDestination(
        navDestination: NavDestinations.AllCoures, userRole: widget.userRole);

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    double tileMinWidth = 400;
    double tileMinimumheight = 100;
    double tileRatio = 16 / 9;
    // available width, in pixels
    double horizontalMargin = MediaQuery.sizeOf(context).width > 900 ? 200 : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns =
        max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length ?? 0;
    int? numberOfModules;
    // grid width, in tiles
    int numberColumns =
        min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    // grid width, in pixels
    double gridWidth = screenWidth * numberColumns / maxColumns;

    String? currentModule = '';
    String? getLatestModuleName(Map<String, dynamic> courseItem) {
      int latestModuleIndex = (courseItem['modules_started'].length - 1) ?? 0;
      String? latestModuleName = (courseItem['modules_started']
              [latestModuleIndex]['module_name']) ??
          '';
      return latestModuleName ?? '';
    }

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(
        loggedInState,
      ),
      bottomNavigationBar:
          kIsWeb ? null : BottomNavBar(loggedInState: loggedInState),
      body: Container(
        margin: EdgeInsets.only(
            top: 20, left: horizontalMargin, right: horizontalMargin),
        child: CustomScrollView(
          slivers: [
            SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numberColumns, childAspectRatio: tileRatio),
                itemCount: userEnrolledCourses.length,
                itemBuilder: (context, courseIndex) {
                  return Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),

                    child: CourseTile(
                      index: courseIndex,
                      title: userEnrolledCourses[courseIndex]['course_name'],
                      modulesCount: userEnrolledCourses[courseIndex]
                              ['course_modules_count'] ??
                          1,

                      tileWidth: tileMinWidth,
                      latestModule: getLatestModuleName(
                              userEnrolledCourses[courseIndex]) ??
                          '',
                      // tileHeight: tileMinimumheight,
                      courseData: getUserCourseData(
                          loggedInState: loggedInState,
                          course: coursesProvider.allCourses[courseIndex]),

                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModulesListScreen(
                                      course: coursesProvider
                                          .allCourses[courseIndex],
                                    )));
                      },
                    ),
                  );
                })
          ],
        ),
      ),
      floatingActionButton: widget.userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCourseScreen()));
              },
              backgroundColor:
                  customTheme.floatingActionButtonTheme.backgroundColor,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}