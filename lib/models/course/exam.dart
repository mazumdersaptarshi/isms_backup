import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/section.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'exam.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Exam {
  final String courseId;
  final String examId;
  final String examTitle;
  final String examDescription;
  final int examPassMark;
  final int examEstimatedTime;
  final List<Section> examSections;

  Exam({
      required this.courseId,
      required this.examId,
      required this.examTitle,
      required this.examDescription,
      required this.examPassMark,
      required this.examEstimatedTime,
      required this.examSections});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation
  /// to JSON. The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}