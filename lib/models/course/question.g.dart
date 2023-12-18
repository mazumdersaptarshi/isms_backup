// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      questionId: json['questionId'] as String,
      questionType: json['questionType'] as String,
      questionText: json['questionText'] as String,
      questionAnswers: (json['questionAnswers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'questionId': instance.questionId,
      'questionType': instance.questionType,
      'questionText': instance.questionText,
      'questionAnswers':
          instance.questionAnswers.map((e) => e.toJson()).toList(),
    };
