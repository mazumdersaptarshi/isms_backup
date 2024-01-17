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
      if (existingCourseProgressData[DatabaseFields.completedSections.name] != null) {
        updatedCompletedSections = _updateCompletedSections(
            completedSections: existingCourseProgressData[DatabaseFields.completedSections.name],
            currentSection: progressData[DatabaseFields.currentSectionId.name]);
      } else {
        updatedCompletedSections = _updateCompletedSections(
            completedSections: [], currentSection: progressData[DatabaseFields.currentSectionId.name]);
      }
      // Update the progress data with the list of completed sections.
      progressData[DatabaseFields.completedSections.name] = updatedCompletedSections ?? [];
    } catch (e) {
      _logger.info(e);
    }

    _logger.info(progressData);
    // Finally, Update the user's course progress data by accessing the loggedInState.
    await loggedInState.updateUserProgress(fieldName: DatabaseFields.courses.name, key: courseId, data: progressData);
  }

  /// Updates the user's exam progress for a specific course and exam.
  /// This function handles updating existing exam attempt records or creating new ones.
  ///
  /// Args:
  ///   loggedInState (LoggedInState): The current logged-in state of the user.
  ///   courseId (String): The ID of the course related to the exam.
  ///   examId (String): The ID of the exam being attempted.
  ///   completionStatus (String?): The completion status of the exam.
  ///   attemptData (Map<String, dynamic>): Data related to the current attempt.
  static void updateUserExamProgress(
      {required LoggedInState loggedInState,
      required String courseId,
      required String examId,
      String? completionStatus,
      required Map<String, dynamic> newAttemptData}) async {
    Map<String, dynamic> existingExamAttemptsData = {};
    Map<String, dynamic> finalAttemptsMap = {};
    Map<String, dynamic> finalExamsMap = {};

    // Fetch existing user data from Hive service.
    _userData = await HiveService.getExistingLocalDataForUser(loggedInState.currentUser);
    // Retrieve existing exam attempts data for the specific course and exam.
    existingExamAttemptsData =
        _getExistingExamAttemptsForCourse(userData: _userData, courseId: courseId, examId: examId);

    // Determine if there's existing data to update or if new data needs to be created.
    finalAttemptsMap = existingExamAttemptsData.isNotEmpty
        ? _updateExistingAttemptsMap(
            existingAttempts: existingExamAttemptsData['attempts'], newAttemptData: newAttemptData)
        : _createNewAttemptsMap(newAttemptData: newAttemptData);

    // Prepare updated exams data map
    finalExamsMap = {
      DatabaseFields.courseId.name: courseId,
      DatabaseFields.examId.name: examId,
      DatabaseFields.attempts.name: finalAttemptsMap,
      DatabaseFields.completionStatus.name: completionStatus ?? 'not_completed',
    };
    // Update the user's exam progress data in Hive storage.
    await loggedInState.updateUserProgress(fieldName: 'exams', key: examId, data: finalExamsMap);
  }

  /// Helper method to extract the course progress data from the user's data.
  /// This method navigates through the user data to find and retrieve the course progress data.
  static Map<String, dynamic> _fetchCoursesMapFromUserData(
      {required Map<String, dynamic> userData, required courseId}) {
    Map<String, dynamic> coursesMap = {};
    try {
      // Iterate through user data to find and extract the course progress data.
      userData.forEach((key, userInfoItem) {
        if (key == DatabaseFields.courses.name) {
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

  /// Updates the existing attempts map with new attempt data.
  ///
  /// Args:
  ///   existingAttempts (Map<String, dynamic>): The current map of attempts.
  ///   newAttemptData (Map<String, dynamic>): The data for the new attempt to be added or updated.
  ///
  /// Returns:
  ///   Map<String, dynamic>: The updated map of attempts.
  static Map<String, dynamic> _updateExistingAttemptsMap({
    required Map<String, dynamic> existingAttempts,
    required Map<String, dynamic> newAttemptData,
  }) {
    try {
      // Update the specific attempt record in the existing attempts map.
      existingAttempts[newAttemptData[DatabaseFields.attemptId.name]] = UserAttempts.fromMap({
        DatabaseFields.attemptId.name: newAttemptData[DatabaseFields.attemptId.name],
        DatabaseFields.startTime.name: newAttemptData[DatabaseFields.startTime.name],
        DatabaseFields.endTime.name: newAttemptData[DatabaseFields.endTime.name],
        DatabaseFields.completionStatus.name: newAttemptData[DatabaseFields.completionStatus.name],
        DatabaseFields.score.name: newAttemptData[DatabaseFields.score.name],
        DatabaseFields.responses.name: newAttemptData[DatabaseFields.responses.name],
      });
    } catch (e) {
      // Log the error or handle it as necessary.
      _logger.warning('Error updating existing attempts map: $e');
    }

    return existingAttempts;
  }

  /// Creates a new attempts map from the provided attempt data.
  ///
  /// Args:
  ///   newAttemptData (Map<String, dynamic>): The data for the new attempt to be added.
  ///
  /// Returns:
  ///   Map<String, dynamic>: A new map of attempts containing only the provided attempt data.
  static Map<String, dynamic> _createNewAttemptsMap({
    required Map<String, dynamic> newAttemptData,
  }) {
    try {
      // Create a new map with a single attempt record.
      Map<String, dynamic> newAttemptDataMap = {
        newAttemptData[DatabaseFields.attemptId.name]: UserAttempts.fromMap({
          DatabaseFields.attemptId.name: newAttemptData[DatabaseFields.attemptId.name],
          DatabaseFields.startTime.name: newAttemptData[DatabaseFields.startTime.name],
          DatabaseFields.endTime.name: newAttemptData[DatabaseFields.endTime.name],
          DatabaseFields.completionStatus.name: newAttemptData[DatabaseFields.completionStatus.name],
          DatabaseFields.score.name: newAttemptData[DatabaseFields.score.name],
          DatabaseFields.responses.name: newAttemptData[DatabaseFields.responses.name],
        }),
      };

      return newAttemptDataMap;
    } catch (e) {
      // Log the error or handle it as necessary.
      _logger.warning('Error creating new attempts map: $e');
    }
    return {};
  }

  /// Retrieves the exam progress data for a specific course and exam from the user's data.
  ///
  /// Args:
  ///   userData (Map<String, dynamic>): The user data containing information about exams.
  ///   courseId (String): The ID of the course related to the exam.
  ///   examId (String): The ID of the exam for which progress data is needed.
  ///
  /// Returns:
  ///   Map<String, dynamic>: A map containing the progress data of the specified exam.
  static Map<String, dynamic> _getExistingExamAttemptsForCourse({
    required Map<String, dynamic> userData,
    required courseId,
    required examId,
  }) {
    Map<String, dynamic> examProgressMap = {};
    userData.forEach((key, userInfoItem) {
      if (key == DatabaseFields.exams.name) {
        if (userInfoItem != null) {
          userInfoItem.forEach((examId, examProgressInstance) {
            //Iterates through all items in the exams list, by their ID
            //We need to go a layer deeper and then filter only those exams that match the course ID
            if (examProgressInstance.courseId == courseId) examProgressMap = examProgressInstance.toMap();
          });
        }
      }
    });

    return examProgressMap;
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
