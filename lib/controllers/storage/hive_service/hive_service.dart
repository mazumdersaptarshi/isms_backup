import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:isms/services/hive/hive_adapters/user_course_progress.dart';

class HiveService {
  static final String _usersBoxName = 'users';
  static final String _coursesFieldName = 'courses';

  static Future<void> updateCurrentCourseProgress(
      Map<String, dynamic> currentProgressData, User currentUser) async {
    var box = await _openUsersBox();
    var existingUserData = await _getExistingUserData(currentUser, box);
    if (existingUserData != null) {
      _updateCourseProgress(existingUserData, currentProgressData);
      await _saveUserData(currentUser, existingUserData, box);
    } else {
      // Handle the scenario when no existing data is found
      // This could involve logging an error, returning a failure status, etc.
    }
  }

  static Future<Box> _openUsersBox() async {
    return await Hive.openBox(_usersBoxName);
  }

  static Future<Map<String, dynamic>?> _getExistingUserData(
      User currentUser, Box box) async {
    try {
      return await box.get(currentUser.uid);
    } catch (e) {
      // Properly handle the error, log it, or take necessary actions
      return null;
    }
  }

  static void _updateCourseProgress(Map<String, dynamic> existingUserData,
      Map<String, dynamic> progressData) {
    var currentCourseProgress = UserCourseProgressHive(
      courseId: progressData['courseId'],
      courseName: progressData['courseName'],
      completionStatus: progressData['completionStatus'],
      currentSectionId: progressData['currentSectionId'],
      currentSection: progressData['currentSection'],
      // additional fields if necessary
    );
    existingUserData[_coursesFieldName][progressData['courseId']] =
        currentCourseProgress;
  }

  static Future<void> _saveUserData(
      User currentUser, Map<String, dynamic> userData, Box box) async {
    await box.put(currentUser.uid, userData);
    // Optionally, include logging or additional checks here
  }
}
