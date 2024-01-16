import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/services/hive/hive_adapters/user_exam_progress.dart';
import 'package:logging/logging.dart';

/// UserProgressState is a ChangeNotifier class that manages the progress of a user in courses and exams.
/// It serves as a proxy to the LoggedInState, using the current user's data to track progress.

class UserProgressState extends ChangeNotifier {
  /// Maps to store the progress data for courses and exams for a user.
  Map<String, dynamic> _courseProgress = {};
  Map<String, dynamic> _examProgress = {};
  static Map<String, dynamic> _userData = {};

  /// Logger for logging information, warnings, and errors.
  static final Logger _logger = Logger('UserProgressState');

  /// Constructor to initialize UserProgressState with a specific user ID.
  /// Additional initialization logic can be added if required.
  UserProgressState({required String userId}) {
    //If any progress data needs to be initialized, it can be done here
  }

  /// Static method to update the course progress for a specific user.
  /// This method fetches the current user data and updates it with the new progress data.
  static Future<void> updateUserCourseProgress(
      {required LoggedInState loggedInState,
      required String courseId,
      required Map<String, dynamic> progressData}) async {
    // Fetch existing local data for the current user.
    Map<String, dynamic> userData = await HiveService.getExistingLocalDataForUser(loggedInState.currentUser);

    // Extract existing course progress data for the specified course, from the existing heap of data for the user
    Map<String, dynamic> existingCourseProgressData =
        _fetchCoursesMapFromUserData(userData: userData, courseId: courseId);
    List updatedCompletedSections = [];
    _logger.info(existingCourseProgressData.keys);
    try {
      // Update the list of completed sections based on the current section.
      // If course has not been started yet and the completed sections list is null
      // Then an empty list is returned for completedSections
      if (existingCourseProgressData[HiveFieldKey.completedSections.name] != null) {
        updatedCompletedSections = _updateCompletedSections(
            completedSections: existingCourseProgressData[HiveFieldKey.completedSections.name],
            currentSection: progressData[HiveFieldKey.currentSectionId.name]);
      } else {
        updatedCompletedSections = _updateCompletedSections(
            completedSections: [], currentSection: progressData[HiveFieldKey.currentSectionId.name]);
      }
      // Update the progress data with the list of completed sections.
      progressData[HiveFieldKey.completedSections.name] = updatedCompletedSections ?? [];
    } catch (e) {
      _logger.info(e);
    }

    _logger.info(progressData);
    // Finally, Update the user's course progress data by accessing the loggedInState.
    await loggedInState.updateUserProgress(fieldName: HiveFieldKey.courses.name, key: courseId, data: progressData);
  }

  static void updateUserExamProgress(
      {required LoggedInState loggedInState,
      required String courseId,
      required String examId,
      String? completionStatus,
      required Map<String, dynamic> attemptData}) async {
    _logger.info('attempt_data: ${attemptData}');
    Map<String, dynamic> existingExamProgressData = {};

    _userData = await HiveService.getExistingLocalDataForUser(loggedInState.currentUser);

    existingExamProgressData = _fetchExamsMapFromUserData(userData: _userData, courseId: courseId, examId: examId);
    _logger.info('existingExamProgressData: $existingExamProgressData');
    _logger.info(existingExamProgressData['attempts']);
    if (existingExamProgressData.isNotEmpty) {
      // If there is existing exam data, update the attempts with the new attempt data.
      Map<String, dynamic>? updatedAttempts =
          _updateAttemptInUserData(attempts: existingExamProgressData['attempts'], attemptData: attemptData);

      Map<String, dynamic> updatedExamData = {
        'courseId': courseId,
        'examId': examId,
        'attempts': updatedAttempts,
        'completionStatus': 'not_completed',
      };
      await loggedInState.updateUserProgress(fieldName: 'exams', key: examId, data: updatedExamData);
      existingExamProgressData.forEach((key, value) {
        if (key == 'attempts') {
          print(value);
        }
      });
    } else {
      // If there is no existing exam data, create a new record for this attempt.

      Map<String, dynamic> newAttemptData = {
        attemptData['attemptId']: UserAttempts.fromMap({
          'attemptId': attemptData['attemptId'],
          'startTime': attemptData['startTime'],
          'endTime': attemptData['endTime'],
          'completionStatus': attemptData['completionStatus'],
          'score': attemptData['score'],
          'responses': attemptData['responses'],
        }),
      };

      Map<String, dynamic> newExamData = {
        'courseId': courseId,
        'examId': examId,
        'attempts': newAttemptData,
        'completionStatus': 'not_completed',
      };
      await loggedInState.updateUserProgress(fieldName: 'exams', key: examId, data: newExamData);
    }
  }

  /// Helper method to extract the course progress data from the user's data.
  /// This method navigates through the user data to find and retrieve the course progress data.
  static Map<String, dynamic> _fetchCoursesMapFromUserData(
      {required Map<String, dynamic> userData, required courseId}) {
    Map<String, dynamic> coursesMap = {};
    try {
      // Iterate through user data to find and extract the course progress data.
      userData.forEach((key, userInfoItem) {
        if (key == HiveFieldKey.courses.name) {
          if (userInfoItem != null) {
            userInfoItem.forEach((courseId, courseProgressInstance) {
              // Convert course progress instance, which is an Instance of type UserCourseProgressHive, to a map.
              coursesMap = courseProgressInstance.toMap();
            });
          }
        }
      });
    } catch (e) {}

    return coursesMap;
  }

  //In progress...
  static Map<String, dynamic>? _updateAttemptInUserData(
      {required Map<String, dynamic> attempts, required Map<String, dynamic> attemptData}) {
    attempts[attemptData['attemptId']] = UserAttempts.fromMap({
      'attemptId': attemptData['attemptId'],
      'startTime': attemptData['startTime'],
      'endTime': attemptData['endTime'],
      'completionStatus': attemptData['completionStatus'],
      'score': attemptData['score'],
      'responses': attemptData['responses'],
    });

    return attempts;
  }

  static Map<String, dynamic> _fetchExamsMapFromUserData(
      {required Map<String, dynamic> userData, required courseId, required examId}) {
    Map<String, dynamic> examsMap = {};
    print(userData);
    userData.forEach((key, userInfoItem) {
      if (key == HiveFieldKey.exams.name) {
        if (userInfoItem != null) {
          userInfoItem.forEach((examId, examProgressInstance) {
            examsMap = examProgressInstance.toMap();
          });
        }
      }
    });

    return examsMap;
  }

  /// Helper method to update the list of completed sections for a course.
  /// It checks if the current section is already in the list and adds it if not.
  static List _updateCompletedSections({required List completedSections, required String currentSection}) {
    print(completedSections);
    try {
      if (!completedSections.contains(currentSection)) {
        completedSections.add(currentSection);
      }
    } catch (e) {}

    return completedSections;
  }
}
