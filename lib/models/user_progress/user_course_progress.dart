import 'package:json_annotation/json_annotation.dart';

import 'user_exam_progress.dart';

/// This class stores course progress for a single user and a single course, which is a direct mapping of each document
/// in the `userCourseProgress` Firebase collection.
///
/// Due to the inability to access keys inside maps stored in Firebase, each document is keyed on both
/// [userId] and [courseId], meaning that for every course assigned to a user, there will be a separate document
/// and therefore multiple instantiated [UserCourseProgress] objects.

class UserCourseProgress {
  final String userId;
  final String courseId;

  final String? courseTitle;
  final bool? courseCompleted;
  final String? currentSection;
  final List<String>? completedSections;
  final List<String>? completedExams;

  final List<String>? sectionsInCourse;

  final List<String>? examsInCourse;

  final List<UserExamProgress>? examsProgressList;

  UserCourseProgress(
      {required this.userId,
      required this.courseId,
      this.courseCompleted,
      this.currentSection,
      this.completedSections,
      this.completedExams,
      this.courseTitle,
      this.sectionsInCourse,
      this.examsInCourse,
      this.examsProgressList});
}
