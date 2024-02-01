import 'package:json_annotation/json_annotation.dart';

/// This class is for tracking the progress of the exam for the User

part 'user_exam_progress.g.dart';

@JsonSerializable(explicitToJson: true)
class UserExamProgress {
  String? courseId;
  String? examId;
  Map<String, dynamic>? attempts;
  String? completionStatus;

  UserExamProgress({
    this.courseId,
    this.examId,
    this.attempts,
    this.completionStatus,
  });

  factory UserExamProgress.fromJson(Map<String, dynamic> json) => _$UserExamProgressFromJson(json);

  Map<String, dynamic> toJson() => _$UserExamProgressToJson(this);
}
