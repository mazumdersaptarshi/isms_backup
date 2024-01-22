import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};
  Map<String, dynamic> _allUserData = {};

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

    _allUserData = Map.from(_allUsersData[uid]);
    return _allUserData;
  }

  Future<Map<String, dynamic>> getCoursesForUser(String uid) async {
    Map<String, dynamic> courses = {};

    await Future.delayed(Duration(seconds: 2));
    print('allUserData: ${_allUsersData}');

    courses = Map.from(_allUsersData[uid]['courses']);
    print(_allUsersData[uid]);

    // print('courses that user has enrolled: $courses');
    return courses;
  }

  ///This function gets all the Exams taken by the User for that particular  course
  Map<String, dynamic> getExamsProgressForCourseForUser(String uid, String courseId) {
    print('CourseID: $courseId');
    Map<String, dynamic> exam = {};
    Map<String, dynamic> exams = {};

    try {
      Map all_exams = _allUsersData[uid][DatabaseFields.exams.name];
      all_exams.forEach((key, value) {
        if (value.courseId == courseId) {
          // exams[key] = value;
          exams[value.examId] = value.attempts;
        }
      });
    } catch (e) {}
    // getExamAttemptsForCourseForUser(exams, 'de44qv');
    /**
     * Here we also get a list of exam IDs that the course has
     */

    // print(CourseProvider.getSectionsForCourse(courseId: courseId));
    return exams;
  }
}
