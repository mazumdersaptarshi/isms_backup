// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttempt _$UserAttemptFromJson(Map<String, dynamic> json) => UserAttempt(
      attemptId: json['attemptId'] as String?,
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      completionStatus: json['completionStatus'] as String?,
      responses: json['responses'] as List<dynamic>?,
    )..score = json['score'] as int?;

Map<String, dynamic> _$UserAttemptToJson(UserAttempt instance) =>
    <String, dynamic>{
      'attemptId': instance.attemptId,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'completionStatus': instance.completionStatus,
      'score': instance.score,
      'responses': instance.responses,
    };
