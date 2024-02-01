import 'package:json_annotation/json_annotation.dart';

/// This class is for tracking the progress of the exam for the User

part 'user_attempt.g.dart';

@JsonSerializable(explicitToJson: true)
class UserAttempt {
  String? attemptId;
  String? startTime;
  String? endTime;
  String? completionStatus;
  int? score;

  List? responses;

  UserAttempt({
    this.attemptId,
    this.startTime,
    this.endTime,
    this.completionStatus,
    this.responses,
  });

  factory UserAttempt.fromJson(Map<String, dynamic> json) => _$UserAttemptFromJson(json);

  Map<String, dynamic> toJson() => _$UserAttemptToJson(this);
}
