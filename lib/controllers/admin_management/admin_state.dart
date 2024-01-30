import 'dart:core';

import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};

  Map<String, dynamic> _userAllData = {};
  Map<String, dynamic> _lastLoadedUserSummaryMap = {'inProgressCourses': []};

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
    // print('allUserData: ${_allUsersData}');

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
        // 'completionStatus': courseProgressItem.value.completionStatus,
        'completedSections': courseProgressItem.value.completedSections,
        'completedExams': courseProgressItem.value.completedExams,
        'userExams': userExams,
        'completionStatus':
            courseProgressItem.value.completedSections.length + courseProgressItem.value.completedExams.length >=
                fetchedCourseSectionsLength + fetchedExamsCount,
      };
      print(
          'nbv: ${((courseProgressItem.value.completedSections).length + (courseProgressItem.value.completedExams).length) <= fetchedCourseSectionsLength + fetchedExamsCount}');
      if (((courseProgressItem.value.completedSections).length + (courseProgressItem.value.completedExams).length) <=
          fetchedCourseSectionsLength + fetchedExamsCount) {
        if (!_lastLoadedUserSummaryMap['inProgressCourses'].contains(fetchedCourse['courseId'])) {
          _lastLoadedUserSummaryMap['inProgressCourses'].add(fetchedCourse['courseId']);
        }
      }
      _lastLoadedUserSummaryMap['coursesEnrolled'] = _userAllData['courses'].length;
      _lastLoadedUserSummaryMap['examsTaken'] = _userAllData['exams'].length;
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
    });

    return userExamsProgress;
  }

  Map<String, dynamic> getSummaryMap({required Map userAllData, required String uid}) {
    Map allExams = _allUsersData[uid][DatabaseFields.exams.name];
    int totalScore = 0;
    int numberOfAttempts = 0;
    int inProgressCourses = 0;
    int completedCourses = 0;
    try {
      allExams.forEach((key, examItem) {
        examItem.attempts.forEach((key, value) {
          int score = value.toMap()['score'];
          totalScore += score;
          numberOfAttempts++;
        });
      });

      userAllData['courses'].forEach((courseId, courseData) {
        print(courseData.toMap());
        if (courseData.toMap()['completionStatus'] == true) {
          print(courseData);
          completedCourses++;
        } else {
          inProgressCourses++;
        }
      });
      double averageScore = numberOfAttempts > 0 ? totalScore / numberOfAttempts : 0;

      _lastLoadedUserSummaryMap['averageScore'] = double.parse(averageScore.toStringAsFixed(2));

      print(_lastLoadedUserSummaryMap['inProgressCourses'].length / _userAllData['courses'].length);
      _lastLoadedUserSummaryMap['inProgressCoursesPercent'] = double.parse(
          (_lastLoadedUserSummaryMap['inProgressCourses'].length / _userAllData['courses'].length).toStringAsFixed(2));

      print(_lastLoadedUserSummaryMap);
    } catch (e) {}

    return _lastLoadedUserSummaryMap;
  }
}
