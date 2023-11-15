// ignore_for_file: file_names

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:isms/sharedWidgets/loadingScreenWidget.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../themes/common_theme.dart';
import '../../../userManagement/loggedInState.dart';
import '../../../utilityFunctions/platformCheck.dart';
import '../../homePageFunctions/getCoursesList.dart';
import '../../login/loginScreen.dart';
import 'createCourseScreen.dart';

class MyLearningScreen extends StatefulWidget {
  const MyLearningScreen({super.key});

  @override
  State<MyLearningScreen> createState() => _MyLearningScreenState();
}

class _MyLearningScreenState extends State<MyLearningScreen> {
  String userRole = "user";
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;
    //List<dynamic> userEnrolledCourses = loggedInState.allEnrolledCoursesGlobal;

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    double tileMinWidth = 400;
    double tileRatio = 16 / 9;
    // available width, in pixels
    double horizontalMargin = MediaQuery.sizeOf(context).width > 900 ? 200 : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns =
        max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length;
    // grid width, in tiles
    int numberColumns =
        min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    // grid width, in pixels

    /*String? getLatestModuleName(Map<String, dynamic> courseItem) {
      int latestModuleIndex = (courseItem['modules_started'].length - 1) ?? 0;
      String? latestModuleName = (courseItem['modules_started']
              [latestModuleIndex]['module_name']) ??
          '';
      return latestModuleName ?? '';
    }*/

    //List<Widget> homePageWidgets = [Container(width: 100)];

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: Container(
        margin: EdgeInsets.only(
            top: 20, left: horizontalMargin, right: horizontalMargin),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getCoursesListForUser(
              context: context,
              loggedInState: loggedInState,
              coursesProvider: coursesProvider),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return CustomScrollView(
                slivers: [
                  SliverGrid.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: numberColumns,
                          childAspectRatio: tileRatio),
                      itemCount: snapshot.data!["widgetsList"].length,
                      itemBuilder: (context, courseIndex) {
                        return snapshot.data!["widgetsList"][courseIndex];
                      })
                ],
              );
            } else {
              return loadingWidget();
            }
          },
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
