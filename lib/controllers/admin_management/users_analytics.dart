import 'dart:math';

import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/services/hive/hive_adapters/user_course_progress.dart';
import 'package:isms/services/hive/hive_adapters/user_exam_progress.dart';

class UsersAnalytics {
  static Map _allCoursesExamsMap = {};

  static dynamic buildDataForGraph({
    required Map allUsersData,
    required dynamic allCoursesData,
    required dynamic allExamsData,
  }) {
    _initializeEmptyMapOfCoursesWithExams(allCoursesData: allCoursesData, allExamsData: allExamsData);

    Map convertedMap = _convertClassInstancesToMapsWithinUsersData(usersData: allUsersData);
    // print('res: $finalData');
    var finalData = _integrateUsersDataIntoCoursesExams(
      allCoursesExamsMap: _allCoursesExamsMap,
      usersData: convertedMap,
    );

    return finalData;
  }

  static Map getAllUsersList({required allUsersData}) {
    Map convertedUsersData = {};
    convertedUsersData = _convertClassInstancesToMapsWithinUsersData(usersData: allUsersData);
    return convertedUsersData;
  }

  //Helper Functions
  static Map _convertClassInstancesToMapsWithinUsersData({required Map usersData}) {
    Map<String, dynamic> convertedUsersData = {};

    usersData.forEach((userId, userData) {
      // Directly manipulate copies to avoid unnecessary variable assignments
      var convertedUserData = Map.from(userData)
        ..['courses'] = _convertCoursesDataToReadableMap(userData['courses'])
        ..['exams'] = _convertExamssDataToReadableMap(userData['exams']);

      convertedUsersData[userId] = convertedUserData;
    });
    return convertedUsersData;
  }

  static Map<String, dynamic> _convertCoursesDataToReadableMap(Map courses) {
    return courses.map((courseId, courseProgress) => MapEntry(
          courseId,
          courseProgress is UserCourseProgressHive ? courseProgress.toMap() : courseProgress,
        ));
  }

  static Map<String, dynamic> _convertExamssDataToReadableMap(Map exams) {
    return exams.map((examId, examProgress) {
      if (examProgress is UserExamProgressHive) {
        var examProgressMap = examProgress.toMap();
        examProgressMap['attempts'] = examProgressMap['attempts']
            .map((key, value) => MapEntry(key, value is UserAttempts ? value.toMap() : value));
        return MapEntry(examId, examProgressMap);
      }
      return MapEntry(examId, examProgress);
    });
  }

  static Map<String, dynamic> _integrateUsersDataIntoCoursesExams({
    required Map allCoursesExamsMap,
    required Map usersData,
  }) {
    Map<String, dynamic> examsAllUsersMap = {};

    usersData.forEach((userId, userData) {
      _integrateUserExamScoresAndDurations(
          userId: userId,
          userDetails: userData,
          allCoursesExamsMap: allCoursesExamsMap,
          examsAllUsersMap: examsAllUsersMap);
    });

    return examsAllUsersMap;
  }

  //
  static void _integrateUserExamScoresAndDurations(
      {required String userId,
      required Map userDetails,
      required Map allCoursesExamsMap,
      required Map examsAllUsersMap}) {
    var userExams = userDetails['exams'] as Map;
    userExams.forEach((examId, userExamDetails) {
      var courseId = userExamDetails['courseId'];
      if (allCoursesExamsMap[courseId]?.containsKey(examId) ?? false) {
        examsAllUsersMap[courseId] ??= {};
        examsAllUsersMap[courseId]![examId] ??= {};
        var examData = _summarizeUserExamPerformance(userExamDetails['attempts'], userDetails['username']);
        examsAllUsersMap[courseId]![examId]![userId] = examData;
      }
    });
  }

  static Map _summarizeUserExamPerformance(Map attempts, String userName) {
    List<int> scores = attempts.values.map((attempt) => attempt['score'] as int).toList();
    List<Duration> durations = _calculateDurations(attempts);

    return {
      'userName': userName,
      'totalScore': scores.fold(0, (a, b) => a + b),
      'averageScore': _calculateAverageScore(scores),
      'maxScore': scores.reduce(max),
      'minScore': scores.reduce(min),
      'maxDuration': durations.reduce((a, b) => a > b ? a : b),
      'minDuration': durations.reduce((a, b) => a < b ? a : b),
      'averageDuration': _calculateAverageDuration(durations),
    };
  }

  static List<Duration> _calculateDurations(Map attempts) {
    return attempts.values.map((attempt) {
      DateTime startTime = DateTime.parse(attempt['startTime']);
      DateTime endTime = DateTime.parse(attempt['endTime']);
      return endTime.difference(startTime);
    }).toList();
  }

  static double _calculateAverageScore(List<int> scores) {
    if (scores.isEmpty) return 0;
    return scores.reduce((a, b) => a + b) / scores.length;
  }

  static Duration _calculateAverageDuration(List<Duration> durations) {
    if (durations.isEmpty) return Duration.zero;
    double averageInSeconds = durations.fold(0, (sum, duration) => sum + duration.inSeconds) / durations.length;
    return Duration(seconds: averageInSeconds.round());
  }

  //

  static void _initializeEmptyMapOfCoursesWithExams({required List allCoursesData, required List allExamsData}) {
    allCoursesData.forEach((course) {
      var courseId = course['courseId'];
      _allCoursesExamsMap[courseId] = {};
    });

    allExamsData.forEach((exam) {
      var courseId = exam['courseId'];
      var examId = exam['examId'];
      if (_allCoursesExamsMap.containsKey(courseId)) {
        _allCoursesExamsMap[courseId]![examId] = [];
      }
    });
  }
}
