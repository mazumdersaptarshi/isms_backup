// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../themes/common_theme.dart';
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

    int tileMinWidth = 300;
    double tileRatio = 16 / 9;
    // available width, in pixels
    double screenWidth = MediaQuery.sizeOf(context).width * 0.7;
    // number of tiles that can fit vertically on the screen
    int maxColumns = max((screenWidth / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length;
    // grid width, in tiles
    int numberColumns = min(itemCount, maxColumns);
    // grid width, in pixels
    double gridWidth = screenWidth * numberColumns / maxColumns;
    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: MediaQuery.sizeOf(context).width <= 700
            ? ListView.builder(
                itemCount: coursesProvider.allCourses.length,
                itemBuilder: (context, courseIndex) {
                  return CourseTile(
                    index: courseIndex,
                    title: coursesProvider.allCourses[courseIndex].name,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModulesListScreen(
                                    course:
                                        coursesProvider.allCourses[courseIndex],
                                  )));
                    },
                  );
                },
              )
            : Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  // width: MediaQuery.sizeOf(context).width * 0.7,
                  width: gridWidth,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberColumns,
                          childAspectRatio: tileRatio),
                      itemCount: coursesProvider.allCourses.length,
                      itemBuilder: (context, courseIndex) {
                        return CourseTile(
                          index: courseIndex,
                          title: coursesProvider.allCourses[courseIndex].name,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ModulesListScreen(
                                          course: coursesProvider
                                              .allCourses[courseIndex],
                                        )));
                          },
                        );
                      }),
                ),
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
