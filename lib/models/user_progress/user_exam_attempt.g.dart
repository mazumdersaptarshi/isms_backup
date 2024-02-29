// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exam_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExamAttempt _$UserExamAttemptFromJson(Map<String, dynamic> json) =>
    UserExamAttempt(
      attemptId: json['attemptId'] as String,
      userId: json['userId'] as String,
      courseId: json['courseId'] as String,
      examId: json['examId'] as String,
      startTime: const TimestampConverter().fromJson(json['startTime']),
      endTime: const TimestampConverter().fromJson(json['endTime']),
      result: $enumDecode(_$ExamAttemptResultEnumMap, json['result']),
      score: json['score'] as int,
      responses: json['responses'] as Map<String, dynamic>,
      status: $enumDecode(_$ExamAttemptStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$UserExamAttemptToJson(UserExamAttempt instance) =>
    <String, dynamic>{
      'attemptId': instance.attemptId,
      'userId': instance.userId,
      'courseId': instance.courseId,
      'examId': instance.examId,
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
      'result': _$ExamAttemptResultEnumMap[instance.result]!,
      'score': instance.score,
      'responses': instance.responses,
      'status': _$ExamAttemptStatusEnumMap[instance.status]!,
    };

const _$ExamAttemptResultEnumMap = {
  ExamAttemptResult.pass: 'pass',
  ExamAttemptResult.fail: 'fail',
};

const _$ExamAttemptStatusEnumMap = {
  ExamAttemptStatus.aborted: 'aborted',
  ExamAttemptStatus.completed: 'completed',
  ExamAttemptStatus.not_completed: 'not_completed',
};
