// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
      courseId: json['courseId'] as String,
      examId: json['examId'] as String,
      examTitle: json['examTitle'] as String,
      examDescription: json['examDescription'] as String,
      examRequiredCorrectAnswers: json['examRequiredCorrectAnswers'] as int,
      examAllowedAttempts: json['examAllowedAttempts'] as int,
      examSections: (json['examSections'] as List<dynamic>)
          .map((e) => Section<dynamic>.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'examId': instance.examId,
      'examTitle': instance.examTitle,
      'examDescription': instance.examDescription,
      'examRequiredCorrectAnswers': instance.examRequiredCorrectAnswers,
      'examAllowedAttempts': instance.examAllowedAttempts,
      'examSections': instance.examSections.map((e) => e.toJson()).toList(),
    };
