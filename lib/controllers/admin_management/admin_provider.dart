import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminProvider extends ChangeNotifier {
  static Map _allUsersData = {};

  AdminProvider() {
    getUsers();
    notifyListeners();
  }

  static Map getUsers() {
    _allUsersData = HiveService.getExistingLocalDataFromUsersBox();
    return _allUsersData;
  }

  static Future<Map<String, dynamic>> getCoursesForUser(String uid) async {
    Map<String, dynamic> courses = {};

    await Future.delayed(Duration(seconds: 2));
    print(_allUsersData);

    courses = Map.from(_allUsersData[uid]['courses']);
    print(_allUsersData[uid]);

    print(courses);
    return courses;
  }

  static Map getExamsForCourseForUser(String uid, String courseId) {
    Map exams = {};
    try {
      Map all_exams = _allUsersData[uid][HiveFieldKey.exams.name];

      all_exams.forEach((key, value) {
        if (value.courseId == courseId) {
          exams[key] = value;
        }
      });
    } catch (e) {}
    getExamAttemptsForCourseForUser(exams, 'de44qv');
    return exams;
  }

  static Map getExamAttemptsForCourseForUser(Map exams, String examId) {
    Map attempts = {};
    try {
      exams.forEach((key, value) {
        // print('attempt: ${value.attempts} for exam ${value.examId}');
        if (value.examId == examId) {
          // print('attempt: ${value.attempts} for exam ${value.examId}');
          value.attempts.forEach((key, value) {
            print('${value.attemptId},  ${value.score}');
          });
          // attempts[value.attempts.attemptId] = value.attempts;
        }
        // print(attempts);
      });
    } catch (e) {}
    return exams;
  }
}
