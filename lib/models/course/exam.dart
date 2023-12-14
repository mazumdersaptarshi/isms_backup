import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/question.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'exam.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Exam {
  final String courseId;
  final String examTitle;
  final String examDescription;
  final int examRequiredCorrectAnswers;
  final int examAllowedAttempts;
  final List<Question> examQuestions;

  Exam({
      required this.courseId,
      required this.examTitle,
      required this.examDescription,
      required this.examRequiredCorrectAnswers,
      required this.examAllowedAttempts,
      required this.examQuestions});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation
  /// to JSON. The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}