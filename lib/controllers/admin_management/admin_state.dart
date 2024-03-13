import 'dart:convert';
import 'dart:core';

import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/storage/postgres_client_service/postgres_client.dart';
import 'package:isms/controllers/user_management/user_progress_analytics.dart';
import 'package:http/http.dart' as http;
import 'package:isms/models/admin_models/user_summary.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/user_progress/user_course_progress.dart';
import 'package:isms/models/user_progress/user_exam_attempt.dart';
import 'package:isms/models/user_progress/user_exam_progress.dart';
import 'package:isms/sql/queries/query2.dart';
import 'package:isms/sql/queries/query3.dart';
import 'package:isms/sql/queries/query4.dart';
import 'package:isms/sql/queries/query5.dart';
import 'package:isms/sql/queries/query6.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};
  bool _isDataLoading = true;
  late dynamic _allFetchedExams;
  late dynamic _allFetchedCourses;

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

  String url = 'http://127.0.0.1:5000/api?query=';

  // String url = 'http://127.0.0.1:5000/api?query=';

  Future<dynamic> getUserProfileData(String uid) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query3, [uid]);
    http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    List<dynamic> jsonResponse = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(response.body);
    }
    return jsonResponse;
  }

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

  ///This function gets all the Exams taken by the User for that particular  course
  Map<String, dynamic> getExamsProgressForCourseForUser(String uid, String courseId) {
    Map<String, dynamic> exams = UserProgressAnalytics.buildUserExamsDataMapForCourse(_allUsersData, uid, courseId);

    return exams;
  }

  Future<dynamic> getAllUsers() async {
    List<UsersSummaryData> usersSummary = [];
    // await Future.delayed(Duration(seconds: 1));
    http.Response response = await http.get(Uri.parse(url + '${query4}'));

    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      List<dynamic> jsonResponse = jsonDecode(response.body);
      usersSummary = jsonResponse.map((user) {
        return UsersSummaryData(
          uid: user[0]['userId'],
          name: "${user[0]['givenName']} ${user[0]['familyName']}",
          // Assuming second and third elements are first and last name
          emailId: user[0]['email'],
          role: user[0]['accountRole'],
          coursesLearningCompletedPercentage: (user[0]['assignedCourses'] != null &&
                  user[0]['assignedCourses'] != 'null' &&
                  user[0]['assignedCourses'] > 0)
              ? double.parse(
                  ((user[0]['coursesLearningCompleted'] / user[0]['assignedCourses']) * 100).toStringAsFixed(2))
              : 0,
          coursesAssigned: user[0]['assignedCourses'],
          averageScore: double.parse((double.tryParse(user[0]['averageScore'].toString()) ?? 0).toStringAsFixed(2)),
          // Convert String to double
          examsTaken: user[0]['examsPassed'],
          examsPending: user[0]['assignedExams'] - user[0]['examsPassed'],
          lastLogin: user[0]['lastLogin'],
        );
      }).toList();
    } else {
      // Handle the case when the server did not return a 200 OK response
      print('Failed to load data');
    }
    // for (var userData in _allUsersSummaryData) {
    // }
    return usersSummary;
  }

  Future<dynamic> getUserSummary(String uid) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query2, [uid]);
    http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    List<UserSummary> userSummaryList = [];
    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      List<dynamic> jsonResponse = jsonDecode(response.body);

      jsonResponse.forEach((element) {
        userSummaryList.add(UserSummary(
            summaryTitle: 'Courses Assigned', value: element[0]['assignedCourses'], type: ValueType.number.name));
        userSummaryList.add(
            UserSummary(summaryTitle: 'Exams Passed', value: element[0]['examsPassed'], type: ValueType.number.name));
        userSummaryList.add(UserSummary(
            summaryTitle: 'Average Score', value: element[0]['averageScore'], type: ValueType.percentage.name));
        userSummaryList.add(UserSummary(
            summaryTitle: 'Pending Tasks',
            value: element[0]['assignedCourses'] -
                element[0]['coursesLearningCompleted'] +
                element[0]['assignedExams'] -
                element[0]['examsPassed'],
            type: ValueType.number.name));
      });
    }
    return userSummaryList;
  }

  Future<List<UserExamAttempt>> getExamAttemptsList(
      {required String userId, required String courseId, required String examId}) async {
    List<UserExamAttempt> userExamAttemptList = [];
    String sqlQuery = QueryBuilder.buildSqlQuery(query6, [userId, courseId, examId]);
    http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        userExamAttemptList.add(UserExamAttempt(
            attemptId: element[0]['attemptId'].toString(),
            userId: element[0]['userId'],
            courseId: element[0]['courseId'],
            examId: element[0]['examId'],
            startTime: DateTime.parse(element[0]['startedAt']),
            endTime: DateTime.parse(element[0]['finishedAt']),
            result: element[0]['passed'] ? ExamAttemptResult.pass : ExamAttemptResult.fail,
            score: element[0]['score'],
            responses: element[0]['responses'] ?? {},
            status: element[0]['passed'] ? ExamAttemptStatus.completed : ExamAttemptStatus.not_completed));
      });
    }
    return userExamAttemptList;
  }

  Future<List<UserCourseProgress>> getUserProgressOverview(String uid) async {
    await Future.delayed(Duration(seconds: 1));

    String sqlQuery = QueryBuilder.buildSqlQuery(query5, [uid]);
    http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    List<UserCourseProgress> userCourseProgressList = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        List<UserExamProgress> userExamsProgressList = [];

        if (element[0]['exams_details'] != null) {
          element[0]['exams_details'].forEach((item) {
            userExamsProgressList.add(UserExamProgress(
                userId: uid,
                courseId: element[0]['course_id'],
                examId: item['exam_id'],
                examTitle: item['exam_title'] ?? 'n/a',
                examStatus: item['passed'] ? ExamStatus.completed : ExamStatus.not_completed));
          });
        }

        userCourseProgressList.add(
          UserCourseProgress(
            userId: uid,
            courseId: element[0]['course_id'],
            courseTitle: element[0]['course_title'],
            courseLearningCompleted: element[0]['learning_status'] == 'Completed' ? true : false,
            completedSectionsCount: element[0]['completed_sections_count'] ?? 0,
            sectionsInCourseCount: element[0]['sections_in_course'] ?? 0,
            passedExamsCount: element[0]['passed_exams'] ?? 0,
            examsInCourseCount: element[0]['exams_in_course'] ?? 0,
            examsProgressList: userExamsProgressList,
          ),
        );
      });
    }
    return userCourseProgressList;
  }

  Future<dynamic> getAllUsersCoursesStatusOverview() async {}
}
