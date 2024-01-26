import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};

  Map<String, dynamic> _userAllData = {};

  AdminState._internal() {
    _allUsersData = HiveService.getExistingLocalDataFromUsersBox();
  }

  factory AdminState() {
    return _instance;
  }

  Map fetchUsersData() {
    return _allUsersData;
  }

  Future<Map<String, dynamic>> getAllDataForUser(String uid) async {
    await Future.delayed(Duration(seconds: 2));
    print('allUserData: ${_allUsersData}');

    _userAllData = Map.from(_allUsersData[uid]);
    return _userAllData;
  }

  Future<Map<String, dynamic>> buildUserCoursesDetailsMapUserDetailsPage({required Map userAllData}) async {
    Map<String, dynamic> coursesDetails = {};

    Map userCourses = userAllData['courses'];
    Map userExams = userAllData['exams'];
    for (var courseProgressItem in userCourses.entries) {
      //gets the course details from the database
      Map fetchedCourse = await CourseProvider.getCourseByID(courseId: courseProgressItem.key);
      int fetchedCourseSectionsLength =
          await CourseProvider.getSectionsCountForCourse(courseId: courseProgressItem.key);
      int fetchedExamsCount = await ExamProvider.getExamsCountForCourse(courseId: courseProgressItem.key);
      List fetchedCourseExams = await ExamProvider.getExamsByCourseId(courseId: courseProgressItem.key);

      coursesDetails[courseProgressItem.key] = {
        'courseId': fetchedCourse['courseId'],
        'courseName': fetchedCourse['courseName'],
        'courseSections': fetchedCourse['courseSections'],
        'courseItemsLength': fetchedCourseSectionsLength + fetchedExamsCount,
        'courseExams': fetchedCourseExams,
        'completionStatus': courseProgressItem.value.completionStatus,
        'completedSections': courseProgressItem.value.completedSections,
        'completedExams': courseProgressItem.value.completedExams,
        'userExams': userExams,
      };
    }
    return coursesDetails;
  }

  ///This function gets all the Exams taken by the User for that particular  course
  Map<String, dynamic> getExamsProgressForCourseForUser(String uid, String courseId) {
    print('CourseID: $courseId');
    Map<String, dynamic> exams = {};

    try {
      Map all_exams = _allUsersData[uid][DatabaseFields.exams.name];
      all_exams.forEach((key, value) {
        if (value.courseId == courseId) {
          exams[value.examId] = value.attempts;
        }
      });
    } catch (e) {}

    exams = buildExamsMapForCourseForUser(exams: exams);
    return exams;
  }

  Map<String, dynamic> buildExamsMapForCourseForUser({required Map<String, dynamic> exams}) {
    Map<String, dynamic> userExamsProgress = {};
    exams.forEach((examId, value) async {
      Map<String, dynamic> examData = ExamProvider.getExamByIDLocal(examId: examId);
      List listOfAttempts = [];
      value.forEach((key, value) {
        listOfAttempts.add(value.toMap());
      });
      userExamsProgress[examId] = {
        'examId': examId,
        'examTitle': examData['examTitle'],
        'attempts': listOfAttempts,
      };

      print('__________');
    });
    return userExamsProgress;
  }
}
