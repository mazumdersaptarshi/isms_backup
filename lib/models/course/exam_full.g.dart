// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_full.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamFull _$ExamFullFromJson(Map<String, dynamic> json) => ExamFull(
      courseId: json['courseId'] as String,
      examId: json['examId'] as String,
      examVersion: (json['examVersion'] as num).toDouble(),
      examTitle: json['examTitle'] as String? ?? "No Title Available",
      examSummary: json['examSummary'] as String? ?? "No summary available",
      examDescription:
          json['examDescription'] as String? ?? "No description available",
      examPassMark: json['examPassMark'] as int? ?? 0,
      examEstimatedCompletionTime:
          json['examEstimatedCompletionTime'] as String? ?? "Unknown duration",
      examSections: (json['examSections'] as List<dynamic>?)
          ?.map((e) => SectionFull.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamFullToJson(ExamFull instance) => <String, dynamic>{
      'courseId': instance.courseId,
      'examId': instance.examId,
      'examVersion': instance.examVersion,
      'examTitle': instance.examTitle,
      'examSummary': instance.examSummary,
      'examDescription': instance.examDescription,
      'examPassMark': instance.examPassMark,
      'examEstimatedCompletionTime': instance.examEstimatedCompletionTime,
      'examSections': instance.examSections?.map((e) => e.toJson()).toList(),
    };
