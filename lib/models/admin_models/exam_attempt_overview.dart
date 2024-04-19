import 'package:json_annotation/json_annotation.dart';

part 'exam_attempt_overview.g.dart'; // This file is generated automatically

@JsonSerializable()
class ExamAttemptOverview {
  int attemptId;
  String userId;
  String familyName;
  String givenName;
  String courseId;
  String examId;
  String examTitle;
  bool passed;
  int score;
  String date;

  ExamAttemptOverview({
    required this.attemptId,
    required this.userId,
    required this.familyName,
    required this.givenName,
    required this.courseId,
    required this.examId,
    required this.examTitle,
    required this.passed,
    required this.score,
    required this.date,
  });

  factory ExamAttemptOverview.fromJson(Map<String, dynamic> json) => _$ExamAttemptOverviewFromJson(json);

  // Method to convert ExamDeadline instance to a map
  Map<String, dynamic> toJson() => _$ExamAttemptOverviewToJson(this);
}
