import 'dart:core';

import 'package:isms/controllers/admin_management/users_analytics.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/user_progress_analytics.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};
  late List _allFetchedExams;
  late List _allFetchedCourses;
  Map<String, dynamic> _userAllData = {};

  AdminState._internal() {
    _allUsersData = HiveService.getExistingLocalDataFromUsersBox();
    _initializeAsync();
  }

  factory AdminState() {
    return _instance;
  }

  Future<void> _initializeAsync() async {
    _allFetchedExams = await ExamProvider.getAllExams();
    _allFetchedCourses = await CourseProvider.getAllCourses();
    // Additional initialization tasks can be added here
  }

  Map fetchUsersData() {
    return _allUsersData;
  }

  Future<Map<String, dynamic>> getAllDataForUser(String uid) async {
    await Future.delayed(Duration(seconds: 2));
    // print('allUserData: ${_allUsersData}');

    _userAllData = Map.from(_allUsersData[uid]);

    return _userAllData;
  }

  Future<Map<String, dynamic>> fetchAllDataForCurrentUser({required Map userAllData}) async {
    Map<String, dynamic> userData = await UserProgressAnalytics.buildUserCoursesDataMap(userAllData: userAllData);

    return userData;
  }

  ///This function gets all the Exams taken by the User for that particular  course
  Map<String, dynamic> getExamsProgressForCourseForUser(String uid, String courseId) {
    Map<String, dynamic> exams = {};
    exams = UserProgressAnalytics.buildExamsProgressMapForCourseForUser(_allUsersData, uid, courseId);

    return exams;
  }

  dynamic getAllUsersData() {
    return UsersAnalytics.showAllUsersData(allUsersData: _allUsersData, allCoursesData: _allFetchedCourses);
  }
}
