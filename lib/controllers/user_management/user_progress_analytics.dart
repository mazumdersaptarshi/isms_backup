import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';

class UserProgressAnalytics {
  static Map<String, dynamic> _lastLoadedUserSummaryMap = {'inProgressCourses': []};

  static Map<String, dynamic> buildUserCoursesDataMap({
    required Map userAllData,
    required dynamic allCoursesData,
    required dynamic allExamsData,
  }) {
    Map<String, dynamic> coursesDetails = {};
    int totalScore = 0;
    int numberOfAttempts = 0;
    Map userCourses = userAllData['courses'];
    Map userExams = userAllData['exams'];
    for (var courseProgressItem in userCourses.entries) {
      //gets the course details from the database

      Map fetchedCourse = {};
      List fetchedCourseExams = [];

      for (Map<String, dynamic> course in allCoursesData) {
        if (course['courseId'] == courseProgressItem.key) {
          fetchedCourse = course;
        }
      }

      for (var exam in allExamsData) {
        if (exam['courseId'] == courseProgressItem.key) {
          fetchedCourseExams.add(exam);
        }
      }
      int fetchedCourseSectionsLength = fetchedCourse['courseSections'].length;
      int fetchedExamsCount = fetchedCourseExams.length;

      coursesDetails[courseProgressItem.key] = {
        'courseId': fetchedCourse['courseId'],
        'courseName': fetchedCourse['courseName'],
        'courseSections': fetchedCourse['courseSections'],
        'courseItemsLength': fetchedCourseSectionsLength + fetchedExamsCount,
        'courseExams': fetchedCourseExams,
        'completedSections': courseProgressItem.value.completedSections,
        'completedExams': courseProgressItem.value.completedExams,
        'userExams': userExams,
        'completionStatus':
            courseProgressItem.value.completedSections.length + courseProgressItem.value.completedExams.length >=
                fetchedCourseSectionsLength + fetchedExamsCount,
      };

      if (((courseProgressItem.value.completedSections).length + (courseProgressItem.value.completedExams).length) <
          fetchedCourseSectionsLength + fetchedExamsCount) {
        if (!_lastLoadedUserSummaryMap['inProgressCourses'].contains(fetchedCourse['courseId'])) {
          _lastLoadedUserSummaryMap['inProgressCourses'].add(fetchedCourse['courseId']);
        }
      } else {
        if (_lastLoadedUserSummaryMap['inProgressCourses'].contains(fetchedCourse['courseId'])) {
          _lastLoadedUserSummaryMap['inProgressCourses'].removeWhere((item) => item == fetchedCourse['courseId']);
        }
      }
      _lastLoadedUserSummaryMap['coursesEnrolled'] = userAllData['courses'].length;
      _lastLoadedUserSummaryMap['examsTaken'] = userAllData['exams'].length;
    }
    userExams.forEach((key, examItem) {
      examItem.attempts.forEach((key, value) {
        int score = 0;
        if (value is UserAttempts) {
          score = value.toMap()['score'];
        } else {
          score = value['score'];
        }
        totalScore += score;
        numberOfAttempts++;
      });
    });
    double averageScore = numberOfAttempts > 0 ? totalScore / numberOfAttempts : 0;

    _lastLoadedUserSummaryMap['averageScore'] = double.parse(averageScore.toStringAsFixed(2));

    _lastLoadedUserSummaryMap['inProgressCoursesPercent'] = double.parse(
        (_lastLoadedUserSummaryMap['inProgressCourses'].length / userAllData['courses'].length).toStringAsFixed(2));

    Map<String, dynamic> userDetailsMap = {'coursesDetails': coursesDetails, 'summary': _lastLoadedUserSummaryMap};
    return userDetailsMap;
  }

  // static Map<String, dynamic> buildUserExamsDataMapForCourse(Map allUsersData, String uid, String courseId) {
  //   Map<String, dynamic> exams = {};
  //
  //   try {
  //     Map all_exams = allUsersData[uid][DatabaseFields.exams.name];
  //     all_exams.forEach((key, value) {
  //       if (value.courseId == courseId) {
  //         exams[value.examId] = value.attempts;
  //       }
  //     });
  //   } catch (e) {}
  //
  //   exams = _buildExamsMapForCourseForUser(exams: exams);
  //   return exams;
  // }

  // static Map<String, dynamic> _buildExamsMapForCourseForUser({required Map<String, dynamic> exams}) {
  //   Map<String, dynamic> userExamsProgress = {};
  //   exams.forEach((examId, value) {
  //     Map<String, dynamic> examData = ExamProvider.getExamByIDLocal(examId: examId);
  //     List listOfAttempts = [];
  //     value.forEach((key, value) {
  //       if (value is UserAttempts) {
  //         listOfAttempts.add(value.toMap());
  //       } else {
  //         listOfAttempts.add(value);
  //       }
  //     });
  //     userExamsProgress[examId] = {
  //       'examId': examId,
  //       'examTitle': examData['examTitle'],
  //       'attempts': listOfAttempts,
  //     };
  //   });
  //
  //   return userExamsProgress;
  // }

  static Map<String, dynamic> getSummaryMapForUser(
      {required Map allUsersData, required Map userAllData, required String uid}) {
    return _lastLoadedUserSummaryMap;
  }
}
