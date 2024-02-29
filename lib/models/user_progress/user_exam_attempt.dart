import 'package:json_annotation/json_annotation.dart';

import 'package:isms/utilities/timestamp_converter.dart';

part 'user_exam_attempt.g.dart';

enum ExamAttemptStatus { aborted, completed, not_completed }

enum ExamAttemptResult { pass, fail }

/// This class stores an individual exam attempt progress for a single user and a single course,
/// which is a direct mapping of each document in the `userExamAttempts` Firebase collection.
///
/// Each document is an atomic representation of an exam attempt so is keyed on [userId], [courseId] and [examId].
@JsonSerializable(explicitToJson: true, converters: [TimestampConverter()])
class UserExamAttempt {
  final String attemptId;
  final String userId;
  final String courseId;
  final String examId;
  final DateTime startTime;
  final DateTime endTime;
  final ExamAttemptResult result;
  final int score;
  final Map<String, dynamic> responses;

  final ExamAttemptStatus status;

  UserExamAttempt(
      {required this.attemptId,
      required this.userId,
      required this.courseId,
      required this.examId,
      required this.startTime,
      required this.endTime,
      required this.result,
      required this.score,
      required this.responses,
      required this.status});

  factory UserExamAttempt.fromJson(Map<String, dynamic> json) => _$UserExamAttemptFromJson(json);

  Map<String, dynamic> toJson() => _$UserExamAttemptToJson(this);
}
