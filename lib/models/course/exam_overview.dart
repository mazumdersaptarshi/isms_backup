import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/exam.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'exam_overview.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class ExamOverview implements Exam {
  @override
  final String examId;
  @override
  final double examVersion;
  @override
  final String examTitle;
  @override
  final String examSummary;
  @override
  final String examDescription;
  @override
  final int examPassMark;
  @override
  final String examEstimatedCompletionTime;
  final bool examPassed;

  ExamOverview(
      {required this.examId,
      required this.examVersion,
      required this.examTitle,
      required this.examSummary,
      required this.examDescription,
      required this.examPassMark,
      required this.examEstimatedCompletionTime,
      required this.examPassed});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory ExamOverview.fromJson(Map<String, dynamic> json) => _$ExamOverviewFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$ExamOverviewToJson(this);
}
