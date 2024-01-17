import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/services/hive/config/config.dart';

class AdminState {
  static final AdminState _instance = AdminState._internal();
  Map _allUsersData = {};

  AdminState._internal() {
    _allUsersData = HiveService.getExistingLocalDataFromUsersBox();
  }

  factory AdminState() {
    return _instance;
  }

  Map fetchUsersData() {
    return _allUsersData;
  }

  Future<Map<String, dynamic>> getCoursesForUser(String uid) async {
    Map<String, dynamic> courses = {};

    await Future.delayed(Duration(seconds: 2));
    print(_allUsersData);

    courses = Map.from(_allUsersData[uid]['courses']);
    print(_allUsersData[uid]);

    print(courses);
    return courses;
  }

  Map<String, dynamic> getExamsForCourseForUser(String uid, String courseId) {
    print('CourseID: $courseId');
    Map<String, dynamic> exams = {};
    try {
      Map all_exams = _allUsersData[uid][DatabaseFields.exams.name];

      all_exams.forEach((key, value) {
        if (value.courseId == courseId) {
          exams[key] = value;
          print(value.courseId);
          print(value.examId);
          print(value.attempts);

          print('------------');
        }
      });
    } catch (e) {}
    // getExamAttemptsForCourseForUser(exams, 'de44qv');

    return exams;
  }

  static Map<String, dynamic> getExamAttemptsForCourseForUser(Map<String, dynamic> exams, String examId) {
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
