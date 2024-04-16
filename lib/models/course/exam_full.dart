import 'package:isms/models/course/section_full.dart';
import 'package:json_annotation/json_annotation.dart';

import 'exam.dart';

part 'exam_full.g.dart';

@JsonSerializable(explicitToJson: true)
class ExamFull implements Exam {
  final String courseId;
  @override
  final String examId;
  @override
  final double examVersion;
  @override
  final String examTitle; // Ensure this is non-nullable
  @override
  final String examSummary;
  @override
  final String examDescription;
  @override
  final int examPassMark;
  @override
  final String examEstimatedCompletionTime;
  final List<SectionFull>? examSections;

  ExamFull({
    required this.courseId,
    required this.examId,
    required this.examVersion,
    this.examTitle = "No Title Available", // Provide a default non-null value
    this.examSummary = "No summary available",
    this.examDescription = "No description available",
    this.examPassMark = 0,
    this.examEstimatedCompletionTime = "Unknown duration",
    this.examSections,
  });

  factory ExamFull.fromJson(Map<String, dynamic> json) => _$ExamFullFromJson(json);

  Map<String, dynamic> toJson() => _$ExamFullToJson(this);
}
