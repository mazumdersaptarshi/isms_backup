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
  bool _isDataLoading = true;
  late dynamic _allFetchedExams;
  late dynamic _allFetchedCourses;
  Map<String, dynamic> _userAllData = {};

  AdminState._internal() {
    retrieveAllDataFromDatabase();
  }

  factory AdminState() {
    return _instance;
  }

  bool get dataIsLoading => _isDataLoading;

  dynamic get getAllFetchedExams => _allFetchedExams;

  dynamic get getAllFetchedCourses => _allFetchedCourses;

  Map get getAllUsersData => _allUsersData;

  Future<dynamic> retrieveAllDataFromDatabase() async {
    _isDataLoading = true;
    await Future.delayed(Duration(seconds: 0));
    _allUsersData = await HiveService.getExistingLocalDataFromUsersBox();
    _allFetchedExams = await ExamProvider.getAllExams();
    _allFetchedCourses = await CourseProvider.getAllCourses();

    _isDataLoading = false;

    return _allFetchedCourses;
    // Additional initialization tasks can be added here
  }

  Map<String, dynamic> getAllCoursesDataForCurrentUser(String uid) {
    _userAllData = Map.from(_allUsersData[uid]);
    Map<String, dynamic> userCoursesData =
        UserProgressAnalytics.buildUserCoursesDataMap(
      userAllData: _userAllData,
      allCoursesData: _allFetchedCourses,
      allExamsData: _allFetchedExams,
    );

    return userCoursesData;
  }

  ///This function gets all the Exams taken by the User for that particular  course
  Map<String, dynamic> getExamsProgressForCourseForUser(
      String uid, String courseId) {
    Map<String, dynamic> exams =
        UserProgressAnalytics.buildUserExamsDataMapForCourse(
            _allUsersData, uid, courseId);

    return exams;
  }
}
