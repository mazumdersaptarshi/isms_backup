import 'package:json_annotation/json_annotation.dart';

part 'user_course_progress.g.dart';

/// This class stores course progress for a single user and a single course, which is a direct mapping of each document
/// in the `userCourseProgress` Firebase collection.
///
/// Due to the inability to access keys inside maps stored in Firebase, each document is keyed on both
/// [userId] and [courseId], meaning that for every course assigned to a user, there will be a separate document
/// and therefore multiple instantiated [UserCourseProgress] objects.
@JsonSerializable(explicitToJson: true)
class UserCourseProgress {
  final String userId;
  final String courseId;
  final bool courseCompleted;
  final String currentSection;
  final List<String> completedSections;
  final List<String> completedExams;

  UserCourseProgress({
    required this.userId,
    required this.courseId,
    required this.courseCompleted,
    required this.currentSection,
    required this.completedSections,
    required this.completedExams,
  });

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) => _$UserCourseProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserCourseProgressToJson(this);
}
