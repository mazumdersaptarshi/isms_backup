import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/storage/postgres_client_service/postgres_client.dart';
import 'package:isms/controllers/user_management/user_progress_analytics.dart';
import 'package:http/http.dart' as http;
import 'package:isms/models/admin_models/user_summary.dart';
import 'package:isms/models/admin_models/users_summary_data.dart';
import 'package:isms/models/charts/bar_charts/custom_bar_chart_data.dart';
import 'package:isms/models/charts/box_and_whisker_charts/custom_box_and_whisker_chart_data.dart';
import 'package:isms/models/charts/pie_charts/custom_pie_chart_data.dart';
import 'package:isms/models/course/course_info.dart';
import 'package:isms/models/course/exam_info.dart';
import 'package:isms/models/user_progress/user_course_progress.dart';
import 'package:isms/models/user_progress/user_exam_attempt.dart';
import 'package:isms/models/user_progress/user_exam_progress.dart';
import 'package:isms/sql/queries/query10.dart';
import 'package:isms/sql/queries/query11.dart';
import 'package:isms/sql/queries/query12.dart';
import 'package:isms/sql/queries/query13.dart';
import 'package:isms/sql/queries/query14.dart';
import 'package:isms/sql/queries/query15.dart';
import 'package:isms/sql/queries/query16.dart';
import 'package:isms/sql/queries/query17.dart';
import 'package:isms/sql/queries/query18.dart';
import 'package:isms/sql/queries/query2.dart';
import 'package:isms/sql/queries/query3.dart';
import 'package:isms/sql/queries/query4.dart';
import 'package:isms/sql/queries/query5.dart';
import 'package:isms/sql/queries/query6.dart';
import 'package:isms/sql/queries/query7.dart';
import 'package:isms/sql/queries/query8.dart';
import 'package:isms/sql/queries/query9.dart';
import 'package:isms/views/widgets/shared_widgets/selectable_item.dart';
import 'package:logging/logging.dart';

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
  String localGetURL = 'http://127.0.0.1:5000/get?flag=';
  String remoteGetURL =
      'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/get?flag=';
  List<dynamic> _allUsersCoursesOverviewJSON = [];
  static final Logger _logger = Logger('AdminState');

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
    // await Future.delayed(Duration(seconds: 10));
    // http.Response response = await http.get(Uri.parse(url + '${query4}'));
    // http.Response response = await http.get(Uri.parse(localGetURL + 'summary'));
    http.Response response = await http.get(Uri.parse(remoteGetURL + 'summary'));

    if (response.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      List<dynamic> jsonResponse = jsonDecode(response.body);
      usersSummary = jsonResponse.map((user) {
        return UsersSummaryData(
          uid: user[0]['userId'],
          name: "${user[0]['givenName']} ${user[0]['familyName']}",
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
      _logger.info('Failed to load data');
    }
    // for (var userData in _allUsersSummaryData) {
    // }
    return usersSummary;
  }

  Future<dynamic> getUserSummary(String uid) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query2, [uid]);
    // http.Response response = await http.get(Uri.parse(localGetURL + 'user_summary' + '&param1=$uid'));
    http.Response response = await http.get(Uri.parse(remoteGetURL + 'user_summary' + '&param1=$uid'));

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
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    // http.Response response = await http
    //     .get(Uri.parse(localGetURL + 'get_exam_attempts' + '&param1=$userId&param2=$courseId&param3=$examId'));
    http.Response response = await http
        .get(Uri.parse(remoteGetURL + 'get_exam_attempts' + '&param1=$userId&param2=$courseId&param3=$examId'));

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
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    // http.Response response = await http.get(Uri.parse(localGetURL + 'user_course_progress' + '&param1=$uid'));
    http.Response response = await http.get(Uri.parse(remoteGetURL + 'user_course_progress' + '&param1=$uid'));

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

  Future<dynamic> getAllUsersCoursesStatusOverview({required String examId, required String metric}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query7, [examId]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    // http.Response response = await http.get(Uri.parse(localGetURL + 'exams_scores_overview' '&param1=$examId'));
    http.Response response = await http.get(Uri.parse(remoteGetURL + 'exams_scores_overview' + '&param1=$examId'));

    List<CustomBarChartData> usersExamData = [];
    metric = (metric == '')
        ? 'avgScore'
        : (metric == null)
            ? 'avgScore'
            : metric;
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      _allUsersCoursesOverviewJSON = jsonResponse;
      jsonResponse.forEach((element) {
        usersExamData.add(CustomBarChartData(
            x: '${element[0]['givenName']} ${element[0]['familyName']}', y: (element[0][metric]).round()));
      });
    }
    return usersExamData;
  }

  List<CustomBarChartData> getFilteredUsersCoursesStatusOverview({
    required String examId,
    required String metric,
    required List<String> userIds,
  }) {
    List<CustomBarChartData> filteredUsersExamData = [];
    if (_allUsersCoursesOverviewJSON.isNotEmpty && userIds.isEmpty) {
      filteredUsersExamData = [];
      _allUsersCoursesOverviewJSON.forEach((element) {
        filteredUsersExamData.add(CustomBarChartData(
            x: '${element[0]['givenName']} ${element[0]['familyName']}', y: (element[0][metric]).round()));
      });
    } else if (_allUsersCoursesOverviewJSON.isNotEmpty) {
      filteredUsersExamData = [];

      _allUsersCoursesOverviewJSON.forEach((element) {
        if (userIds.contains(element[0]['userId'])) {
          filteredUsersExamData.add(CustomBarChartData(
              x: '${element[0]['givenName']} ${element[0]['familyName']}', y: (element[0][metric]).round()));
        }
      });
    }
    return filteredUsersExamData;
  }

  Future<dynamic> getAllUsersCoursesBW({required String examId}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query10, [examId]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    // http.Response response = await http.get(Uri.parse(localGetURL + 'users_scores_variation' '&param1=$examId'));
    http.Response response = await http.get(Uri.parse(remoteGetURL + 'users_scores_variation' + '&param1=$examId'));

    List<CustomBoxAndWhiskerChartData> usersExamDataBW = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        List<double> scoresList = [];
        element[0]['scores'].forEach((e) {
          scoresList.add(e.toDouble());
        });
        while (scoresList.length < 5) {
          scoresList.add(0.0);
        }
        usersExamDataBW.add(CustomBoxAndWhiskerChartData(
          x: '${element[0]['givenName']} ${element[0]['familyName']}',
          y: scoresList,
        ));
      });
    }
    return usersExamDataBW;
  }

  Future<dynamic> getCoursesList() async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query8, []);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'all_courses'));

    List<CourseInfo> coursesList = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        coursesList.add(CourseInfo(courseId: element[0]['courseId'], courseTitle: element[0]['courseTitle']));
      });
    }

    return coursesList;
  }

  Future<dynamic> getCoursesListForUser({required String uid}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query12, [uid]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'courses_list_for_user' + '&param1=$uid'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
    }
  }

  Future<dynamic> getExamsListForCourse({required String courseId}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query9, [courseId]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'exams_list_for_course' + '&param1=$courseId'));

    List<ExamInfo> examsListForCourse = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        examsListForCourse.add(ExamInfo(examId: element[0]['examId'], examTitle: element[0]['examTitle']));
      });
    }
    return examsListForCourse;
  }

  Future<dynamic> getExamOverallResults({required String examId}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query11, [examId]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'exams_overall_results' + '&param1=$examId'));

    List<CustomPieChartData> pieChartData = [];
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        pieChartData.add(CustomPieChartData(label: 'Failed', percent: element[0]['failed'], color: Colors.red));
        pieChartData.add(CustomPieChartData(label: 'Passed', percent: element[0]['passed'], color: Colors.lightGreen));
        pieChartData.add(
            CustomPieChartData(label: 'Not  Started', percent: element[0]['not_started'], color: Colors.orangeAccent));
      });
    }
    return pieChartData;
  }

  Future<dynamic> getExamOverallResultsForUser({required String uid}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query13, [uid]);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'user_exams_overall_results' + '&param1=$uid'));

    List<CustomPieChartData> pieChartData = [];

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      jsonResponse.forEach((element) {
        pieChartData.add(CustomPieChartData(label: 'Failed', percent: element[0]['failed'], color: Colors.redAccent));
        pieChartData.add(CustomPieChartData(label: 'Passed', percent: element[0]['passed'], color: Colors.lightGreen));
        pieChartData.add(
            CustomPieChartData(label: 'Not Started', percent: element[0]['notStarted'], color: Colors.orangeAccent));
      });
    }
    return pieChartData;
  }

  Future<dynamic> getAllDomainUsers() async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query15, []);
    // http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    http.Response response = await http.get(Uri.parse(localGetURL + 'domain_users'));

    if (response.statusCode == 200) {}
  }

  Future<dynamic> createOrUpdateUserCourseAssignments({
    required List<SelectableItem> courses,
    required List<SelectableItem> users,
    required bool enabled,
    String? deadline, // Now nullable
    String? years, // Separate years and months, both nullable
    String? months,
  }) async {
    List<String> valueRows = [];
    List<String> userIDs = [];
    List<String> courseIDs = [];

    for (SelectableItem user in users) {
      for (SelectableItem course in courses) {
        // Construct the recurring interval part based on what's provided
        String recurringIntervalValue = '';
        if (years != null && years.isNotEmpty && years != 'null') {
          recurringIntervalValue += '$years years ';
        }
        if (months != null && months.isNotEmpty && months != 'null') {
          recurringIntervalValue += '$months months';
        }
        recurringIntervalValue = recurringIntervalValue.trim(); // Remove trailing space
        userIDs.add(user.itemId);
        courseIDs.add(course.itemId);
        String valueRow =
            "('${user.itemId}', '${course.itemId}', ${enabled ? 'TRUE' : 'FALSE'}, ${deadline != null ? '\'$deadline\'::date' : 'NULL'}, NOW(), ${recurringIntervalValue.isNotEmpty ? 'INTERVAL \'$recurringIntervalValue\'' : 'NULL'})";
        valueRows.add(valueRow);
      }
    }

    String values = valueRows.join(", ");
    String sqlQuery = """
    INSERT INTO user_course_assignments (
        user_id,
        course_id,
        enabled,
        completion_deadline,
        completion_tracking_period_start,
        recurring_completion_required_interval
    ) VALUES
    $values
    ON CONFLICT (user_id, course_id) DO UPDATE
    SET
        enabled = EXCLUDED.enabled,
        completion_deadline = EXCLUDED.completion_deadline,
        completion_tracking_period_start = EXCLUDED.completion_tracking_period_start,
        recurring_completion_required_interval = EXCLUDED.recurring_completion_required_interval;
    """;

    _logger.info(sqlQuery);
    var message = executePostSqlQuery(sqlQuery);
    return message;
  }

  Future<dynamic> executePostSqlQuery(String sqlQuery) async {
    const url = 'http://127.0.0.1:5000/post';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'query': sqlQuery},
      );
      final responseBody = json.decode(response.body);
      _logger.info(' ${responseBody}');
      if (responseBody.toString().contains('error') || responseBody.toString().contains('invalid')) {
        return '''Error :( 
Please select all the appropriate fields properly!''';
      } else {
        return responseBody;
      }
    } catch (error) {
      _logger.info('An error occurred: $error');
    }
    return 'An Unexpected error Occured :(';
  }

  Future<dynamic> getUserCourseAssignments({required String uid}) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query17, [uid]);
    http.Response response = await http.get(Uri.parse(url + '${sqlQuery}'));
    if (response.statusCode == 200) {
      return response.body;
    }
    return [];
  }

  Future<dynamic> createOrUpdateUserCourseAssignmentss({
    required List<SelectableItem> courses,
    required List<SelectableItem> users,
    required bool enabled,
    String? deadline, // Now nullable
    String? years, // Separate years and months, both nullable
    String? months,
  }) async {
    List<String> valueRows = [];
    for (SelectableItem user in users) {
      for (SelectableItem course in courses) {
        // Construct the recurring interval part based on what's provided
        String recurringIntervalValue = '';
        if (years != null && years.isNotEmpty && years != 'null') {
          recurringIntervalValue += '$years years ';
        }
        if (months != null && months.isNotEmpty && months != 'null') {
          recurringIntervalValue += '$months months';
        }
        recurringIntervalValue = recurringIntervalValue.trim(); // Remove trailing space
        String localGetURL = 'http://127.0.0.1:5000/test?flag=';
        http.Response response = await http.get(Uri.parse(localGetURL +
            'insert_update_user_course_assignment' +
            '&param1=${[
              users,
              courses,
              enabled ? 'TRUE' : 'FALSE',
              deadline != null ? '\'$deadline\'::date' : 'NULL',
              'NOW()',
              months
            ]}'));

        String valueRow =
            "('${user.itemId}', '${course.itemId}', ${enabled ? 'TRUE' : 'FALSE'}, ${deadline != null ? '\'$deadline\'::date' : 'NULL'}, NOW(), ${recurringIntervalValue.isNotEmpty ? 'INTERVAL \'$recurringIntervalValue\'' : 'NULL'})";
        valueRows.add(valueRow);
      }
    }

    String values = valueRows.join(", ");

    http.Response response = await http.get(Uri.parse(localGetURL + 'domain_users'));

    // var message = executePostSqlQuery(sqlQuery);
    // return message;
  }
}
