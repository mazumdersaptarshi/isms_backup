// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../../models/course.dart';

String? getLatestModuleName(Map<String, dynamic> courseItem) {
  int latestModuleIndex = (courseItem['modules_started'].length - 1) ?? 0;
  String? latestModuleName =
      (courseItem['modules_started'][latestModuleIndex]['module_name']) ?? '';
  return latestModuleName ?? '';
}

Future<Map<String, dynamic>> getCoursesListForUser(
    {required BuildContext context,
    required LoggedInState loggedInState,
    required CoursesProvider coursesProvider}) async {
  await loggedInState.getUserCoursesData('crs_enrl');
  await loggedInState.getUserCoursesData('crs_compl');

  if (loggedInState.loggedInUser.courses_started == null ||
      loggedInState.loggedInUser.courses_started.length == 0) {
    List<Widget> recommendedCoursesList = await getRecommendedCoursesList(
        context: context,
        loggedInState: loggedInState,
        coursesProvider: coursesProvider);
    return {"hasEnrolledCourses": false, "widgetsList": recommendedCoursesList};
  } else {
    List<Widget> enrolledCoursesList = await getEnrolledCoursesList(
        context: context,
        loggedInState: loggedInState,
        coursesProvider: coursesProvider);
    return {"hasEnrolledCourses": true, "widgetsList": enrolledCoursesList};
  }
}

Future<List<Widget>> getEnrolledCoursesList(
    {required BuildContext context,
    required LoggedInState loggedInState,
    required CoursesProvider coursesProvider}) async {
  List<Widget> enrolledCoursesDisplayWidgets = [Container(width: 100)];

  List coursesStarted = loggedInState.loggedInUser.courses_started;
  debugPrint("TRY TO CREATE WIDGETSS       $coursesStarted");

  if (coursesStarted.isNotEmpty) {
    for (int i = coursesStarted.length - 1; i >= 0; i--) {
      debugPrint("TRY TO CREATE WIDGETSS ${coursesProvider.allCourses}");
      Course course = coursesProvider.allCourses
          .where((element) => element.id == coursesStarted[i]["courseID"])
          .first;

      enrolledCoursesDisplayWidgets.add(CourseTile(
        title: coursesStarted[i]["course_name"],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CoursePage(course: course)));
        },
        // tileHeight: 300,
        tileWidth: 400,
        courseData:
            getUserCourseData(loggedInState: loggedInState, course: course),
        index: i,
        subTitle: getLatestModuleName(coursesStarted[i]) ?? '',
        modulesCount: course.modulesCount ?? 0,
        // dateValue: course.dateCreated,
      ));
    }
  }

  return enrolledCoursesDisplayWidgets;
}

Future<List<Widget>> getRecommendedCoursesList(
    {required BuildContext context,
    required LoggedInState loggedInState,
    required CoursesProvider coursesProvider}) async {
  await loggedInState.getUserCoursesData('crs_enrl');
  List<Widget> recommenedCoursesDisplayWidgets = [Container(width: 100)];
  List<Course> coursesToRecommend = coursesProvider.allCourses.length < 4
      ? coursesProvider.allCourses
          .take(coursesProvider.allCourses.length)
          .toList()
      : coursesProvider.allCourses.take(4).toList();

  for (int i = 0; i < coursesToRecommend.length; i++) {
    Course courseToRecommend = coursesToRecommend[i];
    recommenedCoursesDisplayWidgets.add(CourseTile(
      title: courseToRecommend.name,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CoursePage(course: courseToRecommend)));
      },
      // tileHeight: 300,
      tileWidth: 400,
      courseData: null,
      index: i,
      subTitle: courseToRecommend.description,
      modulesCount: courseToRecommend.modulesCount ?? 0,
      // dateValue: course.dateCreated,
    ));
  }
  return recommenedCoursesDisplayWidgets;
}

Map<String, dynamic> getUserCourseData(
    {required LoggedInState loggedInState, required Course course}) {
  int courseCompPercent = 0;
  /*var courseCompletionDate;
  var courseStartDate;*/

  if (loggedInState.loggedInUser.courses_completed.isNotEmpty) {
    for (var courseCompleted in loggedInState.loggedInUser.courses_completed) {
      if (courseCompleted["courseID"] == course.id) {
        courseCompPercent = 100;
        debugPrint(
            "COURSE COMPLETED DATE : ${courseCompleted["course_name"]}, ${courseCompleted["completed_at"].runtimeType}");
        //courseCompletionDate = courseCompleted["completed_at"];
      }
    }
  }

  if (loggedInState.loggedInUser.courses_started.isNotEmpty) {
    for (var courseStarted in loggedInState.loggedInUser.courses_started) {
      if (courseStarted["courseID"] == course.id &&
          courseStarted["modules_completed"] != null) {
        courseCompPercent =
            ((courseStarted["modules_completed"].length / course.modulesCount) *
                    100)
                .ceil();
        //courseStartDate = courseStarted["started_at"];
      }
    }
  }

  return {"courseCompPercent": double.parse(courseCompPercent.toString())};
}
