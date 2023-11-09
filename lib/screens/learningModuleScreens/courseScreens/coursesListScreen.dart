import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../models/course.dart';
import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../sharedWidgets/bottomNavBar.dart';
import '../../../sharedWidgets/navIndexTracker.dart';
import '../../../themes/common_theme.dart';
import 'createCourseScreen.dart';

class CoursesDisplayScreen extends StatefulWidget {
  CoursesDisplayScreen({super.key});
  String userRole = "user";
  @override
  State<CoursesDisplayScreen> createState() => _CoursesDisplayScreenState();
}

class _CoursesDisplayScreenState extends State<CoursesDisplayScreen> {
  Map<String, dynamic> getUserCourseData(
      {required LoggedInState loggedInState, required Course course}) {
    int courseCompPercent = 0;

    if (loggedInState.loggedInUser.courses_completed != null &&
        loggedInState.loggedInUser.courses_completed.isNotEmpty) {
      loggedInState.loggedInUser.courses_completed.forEach((course_completed) {
        if (course_completed["courseID"] == course.id) {
          courseCompPercent = 100;
        }
      });
    }

    if (loggedInState.loggedInUser.courses_started != null &&
        loggedInState.loggedInUser.courses_started.isNotEmpty) {
      loggedInState.loggedInUser.courses_started.forEach((course_started) {
        if (course_started["courseID"] == course.id &&
            course_started["modules_completed"] != null) {
          courseCompPercent = ((course_started["modules_completed"].length /
                      course.modulesCount) *
                  100)
              .ceil();
        }
      });
    }

    return {"courseCompPercent": double.parse(courseCompPercent.toString())};
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    widget.userRole = loggedInState.currentUserRole;
    NavIndexTracker.setNavDestination(
        navDestination: NavDestinations.AllCoures, userRole: widget.userRole);

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    int tileMinWidth = 300;
    int tileMinheight = 300;
    double tileRatio = 16 / 9;
    // available width, in pixels
    double horizontalMargin = MediaQuery.sizeOf(context).width > 900 ? 200 : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns =
        max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length ?? 0;
    // grid width, in tiles
    int numberColumns =
        min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    // grid width, in pixels
    double gridWidth = screenWidth * numberColumns / maxColumns;
    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
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
                itemCount: coursesProvider.allCourses.length,
                itemBuilder: (context, courseIndex) {
                  return Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10),

                    child: CourseTile(
                      index: courseIndex,
                      title: coursesProvider.allCourses[courseIndex].name,
                      modulesCount: coursesProvider
                              .allCourses[courseIndex].modulesCount ??
                          0,
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
