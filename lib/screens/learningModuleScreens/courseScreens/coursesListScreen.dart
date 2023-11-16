// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../themes/common_theme.dart';
import '../../homePageFunctions/getCoursesList.dart';
import 'createCourseScreen.dart';

class CoursesDisplayScreen extends StatefulWidget {
  const CoursesDisplayScreen({super.key});
  @override
  State<CoursesDisplayScreen> createState() => _CoursesDisplayScreenState();
}

class _CoursesDisplayScreenState extends State<CoursesDisplayScreen> {
  String userRole = "user";
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    userRole = loggedInState.currentUserRole;

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    double tileMinWidth = 400;
    double tileRatio = 3 / 2;

    // available width, in pixels
    double horizontalMargin = MediaQuery.sizeOf(context).width > 900 ? 200 : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns =
        max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length;
    // grid width, in tiles
    int numberColumns = 1;
    // min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    if (itemCount <= 0) {
      numberColumns = 1;
    } else if (itemCount < 3 && maxColumns >= 3) {
      numberColumns = 3;
    } else {
      numberColumns =
          min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    }

    if (kDebugMode) {
      print('uuupop: ${coursesProvider.allCourses}');
    }
    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
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
                  return CourseTile(
                    index: courseIndex,
                    title: coursesProvider.allCourses[courseIndex].name,
                    modulesCount:
                        coursesProvider.allCourses[courseIndex].modulesCount,
                    tileWidth: tileMinWidth,
                    // tileHeight: tileMinimumheight,
                    courseData: getUserCourseData(
                        loggedInState: loggedInState,
                        course: coursesProvider.allCourses[courseIndex],
                        coursesProvider: coursesProvider),

                    subTitle:
                        coursesProvider.allCourses[courseIndex].description,
                    pageView: 'explore',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CoursePage(
                                    course:
                                        coursesProvider.allCourses[courseIndex],
                                  )));
                    },
                  );
                })
          ],
        ),
      ),
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateCourseScreen()));
              },
              backgroundColor:
                  customTheme.floatingActionButtonTheme.backgroundColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
