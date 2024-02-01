import 'package:json_annotation/json_annotation.dart';

/// This class is for tracking the progress of the course for the User

part 'user_course_progress.g.dart';

@JsonSerializable(explicitToJson: true)
class UserCourseProgress {
  String? courseId;
  String? completionStatus;
  String? currentSection;
  List? completedSections;
  List? completedExams;

  UserCourseProgress({
    this.courseId,
    this.completionStatus,
    this.currentSection,
    this.completedSections,
    this.completedExams,
  });

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) => _$UserCourseProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserCourseProgressToJson(this);
}
