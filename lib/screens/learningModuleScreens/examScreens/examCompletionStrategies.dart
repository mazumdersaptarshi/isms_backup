// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:provider/provider.dart';

import '../../../models/course.dart';
import '../../../models/module.dart';
import '../../../models/newExam.dart';
import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../userManagement/loggedInState.dart';
import '../../homePage.dart';

abstract class ExamCompletionStrategy {
  ExamCompletionStrategy({required this.loggedInState}) {}
  LoggedInState loggedInState;
  Widget buildSumbitButton({required BuildContext context});

  Future<void> handleExamCompletion({required BuildContext context});
}

class CourseExamCompletionStrategy implements ExamCompletionStrategy {
  CourseExamCompletionStrategy(
      {required this.course, required this.exam, required this.loggedInState});

  Course course;
  NewExam exam;

  @override
  LoggedInState loggedInState;

  @override
  Widget buildSumbitButton({required BuildContext context}) {
    return ElevatedButton(
      onPressed: () async {
        await handleExamCompletion(context: context);
        if (!context.mounted) return;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CoursePage(course: course)));
      },
      child: Text(
          "Mark Exam as Done- completed ${exam.index}/${course.exams!.length}"),
    );
  }

  @override
  Future<void> handleExamCompletion({required BuildContext context}) async {
    final loggedInState = context.read<LoggedInState>();
    final coursesProvider = context.read<CoursesProvider>();
    DateTime startedAt = DateTime.now();
    for (var courses_started in loggedInState.loggedInUser.courses_started) {
      if (courses_started["courseID"] == course.id) {}
      startedAt = courses_started["started_at"].toDate();
    }
    Map<String, dynamic> courseDetailsMap = {
      "courseID": course.id,
      "course_name": course.name,
      "course_modules_count": course.modulesCount,
      "started_at": startedAt,
    };
    await loggedInState.setUserCourseExamCompleted(
      coursesProvider: coursesProvider,
      course: course,
      courseDetails: courseDetailsMap,
      examIndex: exam.index,
    );

    await loggedInState.setUserCourseCompleted(
        courseDetails: {...courseDetailsMap, "completed_at": DateTime.now()});
    if (!context.mounted) return;
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }
}

class ModuleExamCompletionStrategy implements ExamCompletionStrategy {
  ModuleExamCompletionStrategy(
      {required this.module,
      required this.course,
      required this.exam,
      required this.loggedInState}) {
    this.isModuleStarted = checkIfModuleStartedd();
  }

  Course course;
  NewExam exam;
  Module module;
  @override
  LoggedInState loggedInState;
  bool isModuleStarted = false;

  bool checkIfModuleStartedd() {
    bool flag = false;
    for (var courseStarted in loggedInState.loggedInUser.courses_started) {
      if (courseStarted["modules_started"] != null &&
          courseStarted["course_name"] == course.name) {
        courseStarted["modules_started"].forEach((moduleCompleted) {
          if (moduleCompleted["module_name"] == module.title) flag = true;
        });
      }
    }
    return flag;
  }

  @override
  Widget buildSumbitButton({required BuildContext context}) {
    if (isModuleStarted) {
      return ElevatedButton(
        onPressed: () async {
          handleExamCompletion(context: context).then((value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModuleDetails(
                        course: course,
                        module: module,
                        isModuleStarted: isModuleStarted)));
          });
        },
        child: Text(
            "Mark Module as Done- completed ${exam.index}/${module.exams!.length}"),
      );
    } else {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      Map<String, dynamic> courseDetailsMap = {
        "courseID": course.id,
        "course_name": course.name,
        "course_modules_count": course.modulesCount,
        "started_at": DateTime.now()
      };
      return ElevatedButton(
        onPressed: () async {
          await loggedInState.setUserCourseStarted(
              courseDetails: courseDetailsMap);
          await loggedInState.setUserCourseModuleStarted(
              courseDetails: courseDetailsMap,
              coursesProvider: coursesProvider,
              course: course,
              module: module);

          if (!context.mounted) return;
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SlidesDisplayScreen(
                        course: course,
                        module: module,
                      )));
        },
        child: const Text("Study the module first"),
      );
    }
  }

  void redirect(BuildContext context, Module module) {}

  @override
  Future<void> handleExamCompletion({required BuildContext context}) async {
    final loggedInState = context.read<LoggedInState>();
    final coursesProvider = context.read<CoursesProvider>();

    loggedInState.setUserModuleExamCompleted(
      courseDetails: {
        "courseID": course.id,
        "course_name": course.name,
        "course_modules_count": course.modulesCount
      },
      course: course,
      module: module!,
      coursesProvider: coursesProvider,
      examIndex: exam.index,
    ).then((val) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    });
  }
}
