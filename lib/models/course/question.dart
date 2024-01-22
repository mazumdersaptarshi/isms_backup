import 'package:json_annotation/json_annotation.dart';

import 'package:isms/models/course/answer.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'question.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Question {
  final String questionId;
  final String questionType;
  final String questionText;
  final List<Answer> questionAnswers;

  Question(
      {required this.questionId,
      required this.questionType,
      required this.questionText,
      required this.questionAnswers});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}
