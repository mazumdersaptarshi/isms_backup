import 'package:flutter/cupertino.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:logging/logging.dart';

/// UserProgressState is a ChangeNotifier class that manages the progress of a user in courses and exams.
/// It serves as a proxy to the LoggedInState, using the current user's data to track progress.
class UserProgressState extends ChangeNotifier {
  /// Maps to store the progress data for courses and exams for a user.
  Map<String, dynamic> _courseProgress = {};
  Map<String, dynamic> _examProgress = {};

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
    Map<String, dynamic> userData =
        await HiveService.getExistingLocalDataForUser(
            loggedInState.currentUser);

    // Extract existing course progress data for the specified course, from the existing heap of data for the user
    Map<String, dynamic> existingCourseProgressData =
        _fetchCoursesMapFromUserData(userData: userData, courseId: courseId);
    List updatedCompletedSections = [];
    _logger.info(existingCourseProgressData.keys);
    try {
      // Update the list of completed sections based on the current section.
      // If course has not been started yet and the completed sections list is null
      // Then an empty list is returned for completedSections
      if (existingCourseProgressData[HiveFieldKey.completedSections.name] !=
          null) {
        updatedCompletedSections = _updateCompletedSections(
            completedSections:
                existingCourseProgressData[HiveFieldKey.completedSections.name],
            currentSection: progressData[HiveFieldKey.currentSection.name]);
      } else {
        updatedCompletedSections = _updateCompletedSections(
            completedSections: [],
            currentSection: progressData[HiveFieldKey.currentSection.name]);
      }
      // Update the progress data with the list of completed sections.
      progressData[HiveFieldKey.completedSections.name] =
          updatedCompletedSections ?? [];
    } catch (e) {
      _logger.info(e);
    }

    _logger.info(progressData);
    // Finally, Update the user's course progress data by accessing the loggedInState.
    await loggedInState.updateUserProgress(
        fieldName: HiveFieldKey.courses.name,
        key: courseId,
        data: progressData);
  }

  static void updateUserExamProgress(
      {required LoggedInState loggedInState,
      required String courseId,
      required String examId,
      required Map<String, dynamic> progressData}) async {
    print(progressData);
    Map<String, dynamic> userData =
        await HiveService.getExistingLocalDataForUser(
            loggedInState.currentUser);
    Map<String, dynamic> existingExamProgressData = {};
    existingExamProgressData = _fetchExamsMapFromUserData(
        userData: userData, courseId: courseId, examId: examId);
    print('existingExamProgressData: $existingExamProgressData');
    //Now check if this attempt Id exists or not
    _fetchAttemptFromUserData(
        attempts: existingExamProgressData['attempts'],
        attemptId: progressData['currentAttempt']);
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
  static Map<String, dynamic>? _fetchAttemptFromUserData(
      {required Map<String, dynamic> attempts, required String attemptId}) {
    attempts.forEach((attemptId, instanceOfUserAttempt) {
      print(instanceOfUserAttempt);
    });
  }

  static Map<String, dynamic> _fetchExamsMapFromUserData(
      {required Map<String, dynamic> userData,
      required courseId,
      required examId}) {
    Map<String, dynamic> examsMap = {};
    userData.forEach((key, userInfoItem) {
      if (key == HiveFieldKey.exams.name) {
        if (userInfoItem != null) {
          userInfoItem.forEach((examId, examProgressInstance) {
            examsMap = examProgressInstance.toMap();
            print(examsMap);
          });
        }
      }
    });

    return examsMap;
  }

  /// Helper method to update the list of completed sections for a course.
  /// It checks if the current section is already in the list and adds it if not.
  static List _updateCompletedSections(
      {required List completedSections, required String currentSection}) {
    print(completedSections);
    try {
      if (!completedSections.contains(currentSection)) {
        completedSections.add(currentSection);
      }
    } catch (e) {}

    return completedSections;
  }
}
