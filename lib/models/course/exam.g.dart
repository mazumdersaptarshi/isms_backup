// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
      courseId: json['courseId'] as String,
      examId: json['examId'] as String,
      examTitle: json['examTitle'] as String,
      examSummary: json['examSummary'] as String,
      examDescription: json['examDescription'] as String,
      examPassMark: json['examPassMark'] as int,
      examEstimatedTime: json['examEstimatedTime'] as int,
      examSections: (json['examSections'] as List<dynamic>)
          .map((e) => Section.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'examId': instance.examId,
      'examTitle': instance.examTitle,
      'examSummary': instance.examSummary,
      'examDescription': instance.examDescription,
      'examPassMark': instance.examPassMark,
      'examEstimatedTime': instance.examEstimatedTime,
      'examSections': instance.examSections.map((e) => e.toJson()).toList(),
    };
