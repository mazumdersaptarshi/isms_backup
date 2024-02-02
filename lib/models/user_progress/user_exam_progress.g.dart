// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_exam_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserExamProgress _$UserExamProgressFromJson(Map<String, dynamic> json) =>
    UserExamProgress(
      courseId: json['courseId'] as String?,
      examId: json['examId'] as String?,
      attempts: json['attempts'] as Map<String, dynamic>?,
      completionStatus: json['completionStatus'] as String?,
    );

Map<String, dynamic> _$UserExamProgressToJson(UserExamProgress instance) =>
    <String, dynamic>{
      'courseId': instance.courseId,
      'examId': instance.examId,
      'attempts': instance.attempts,
      'completionStatus': instance.completionStatus,
    };
