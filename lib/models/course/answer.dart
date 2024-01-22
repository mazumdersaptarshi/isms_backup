import 'package:json_annotation/json_annotation.dart';

/// This allows the class to access private members in the generated file.
/// The value for this is `*.g.dart`, where the asterisk denotes the source file name.
part 'answer.g.dart';

/// An annotation for the code generator to know that this class needs the JSON serialisation logic to be generated.
@JsonSerializable(explicitToJson: true)
class Answer {
  final String answerId;
  final String answerText;
  final bool answerCorrect;

  Answer({required this.answerId, required this.answerText, required this.answerCorrect});

  /// A necessary factory constructor for creating a new class instance from a map.
  /// Pass the map to the generated constructor, which is named after the source class.
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialisation to JSON.
  /// The implementation simply calls the private, generated helper method.
  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
