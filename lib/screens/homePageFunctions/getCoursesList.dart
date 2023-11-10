import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../../models/course.dart';

Future<List<Widget>> getHomePageCoursesList(
    {required BuildContext context,
    required LoggedInState loggedInState,
    required CoursesProvider coursesProvider}) async {
  List<Widget> homePageWidgets = [];
  await loggedInState.getUserCoursesData('crs_enrl');
  await loggedInState.getUserCoursesData('crs_compl');
  List coursesStarted = loggedInState.loggedInUser.courses_started;
  print("TRY TO CREATE WIDGETSS       $coursesStarted");

  if (coursesStarted.isNotEmpty) {
    for (int i = coursesStarted.length - 1; i >= 0; i--) {
      print("TRY TO CREATE WIDGETSS ${coursesProvider.allCourses}");
      Course course = coursesProvider.allCourses
          .where((element) => element.id == coursesStarted[i]["courseID"])
          .first;
      // homePageWidgets.add(HomePageItem(
      //   title: courses_started[i]["course_name"],
      //   onTap: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ModulesListScreen(course: course)));
      //   },
      // ));
      homePageWidgets.add(CourseTile(
        title: coursesStarted[i]["course_name"],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ModulesListScreen(course: course)));
        },
        // tileHeight: 300,
        tileWidth: 400,
        courseData:
            getUserCourseData(loggedInState: loggedInState, course: course),
        index: i,
        modulesCount: course.modulesCount ?? 0,
      ));
    }
  }

  return homePageWidgets;
}

Map<String, dynamic> getUserCourseData(
    {required LoggedInState loggedInState, required Course course}) {
  int courseCompPercent = 0;
  var courseCompletionDate;
  var courseStartDate;

  if (loggedInState.loggedInUser.courses_completed.isNotEmpty) {
    for (var course_completed in loggedInState.loggedInUser.courses_completed) {
      if (course_completed["courseID"] == course.id) {
        courseCompPercent = 100;
        print(
            "COURSE COMPLETED DATE : ${course_completed["course_name"]}, ${course_completed["completed_at"].runtimeType}");
        courseCompletionDate = course_completed["completed_at"];
      }
    }
  }

  if (loggedInState.loggedInUser.courses_started.isNotEmpty) {
    for (var course_started in loggedInState.loggedInUser.courses_started) {
      if (course_started["courseID"] == course.id &&
          course_started["modules_completed"] != null) {
        courseCompPercent = ((course_started["modules_completed"].length /
                    course.modulesCount) *
                100)
            .ceil();
        courseStartDate = course_started["started_at"];
      }
    }
  }

  return {"courseCompPercent": double.parse(courseCompPercent.toString())};
}
