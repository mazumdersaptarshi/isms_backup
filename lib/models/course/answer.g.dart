// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      answerId: json['answerId'] as String,
      answerText: json['answerText'] as String,
      answerCorrect: json['answerCorrect'] as bool,
      answerExplanation: json['answerExplanation'] as String,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'answerId': instance.answerId,
      'answerText': instance.answerText,
      'answerCorrect': instance.answerCorrect,
      'answerExplanation': instance.answerExplanation,
    };
