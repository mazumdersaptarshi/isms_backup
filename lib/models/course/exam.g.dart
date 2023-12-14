// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
      courseId: json['courseId'] as String,
      examTitle: json['examTitle'] as String,
      examDescription: json['examDescription'] as String,
      examRequiredCorrectAnswers: json['examRequiredCorrectAnswers'] as int,
      examAllowedAttempts: json['examAllowedAttempts'] as int,
      examQuestions: (json['examQuestions'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'examTitle': instance.examTitle,
      'examDescription': instance.examDescription,
      'examRequiredCorrectAnswers': instance.examRequiredCorrectAnswers,
      'examAllowedAttempts': instance.examAllowedAttempts,
      'examQuestions': instance.examQuestions.map((e) => e.toJson()).toList(),
    };
