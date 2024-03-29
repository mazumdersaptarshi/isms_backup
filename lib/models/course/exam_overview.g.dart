// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamOverview _$ExamOverviewFromJson(Map<String, dynamic> json) => ExamOverview(
      examId: json['examId'] as String,
      examVersion: (json['examVersion'] as num).toDouble(),
      examTitle: json['examTitle'] as String,
      examSummary: json['examSummary'] as String,
      examDescription: json['examDescription'] as String,
      examPassMark: json['examPassMark'] as int,
      examEstimatedCompletionTime:
          json['examEstimatedCompletionTime'] as String,
      examPassed: json['examPassed'] as bool,
    );

Map<String, dynamic> _$ExamOverviewToJson(ExamOverview instance) =>
    <String, dynamic>{
      'examId': instance.examId,
      'examVersion': instance.examVersion,
      'examTitle': instance.examTitle,
      'examSummary': instance.examSummary,
      'examDescription': instance.examDescription,
      'examPassMark': instance.examPassMark,
      'examEstimatedCompletionTime': instance.examEstimatedCompletionTime,
      'examPassed': instance.examPassed,
    };
