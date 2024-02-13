// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exam_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExamAttempt _$UserExamAttemptFromJson(Map<String, dynamic> json) =>
    UserExamAttempt(
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      examId: json['examId'] as String,
      startTime: const TimestampConverter().fromJson(json['startTime']),
      endTime: const TimestampConverter().fromJson(json['endTime']),
      passed: json['passed'] as bool,
      score: json['score'] as int,
      responses: json['responses'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$UserExamAttemptToJson(UserExamAttempt instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'courseId': instance.courseId,
      'examId': instance.examId,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
      'passed': instance.passed,
      'score': instance.score,
      'responses': instance.responses,
    };
