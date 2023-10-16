import 'package:isms/models/enums.dart';

class NewExam {
  int index;
  String examID;
  int passingMarks;
  String title;
  List questionAnswerSet;

  NewExam({
    this.index = 0,
    required this.examID,
    required this.passingMarks,
    required this.title,
    required this.questionAnswerSet,
  });

  Map<String, dynamic> toMap() {
    return {
      'index': index,
      'exam_ID': examID,
      'passing_marks': passingMarks,
      'title': title,
      'question_answer_set': questionAnswerSet,
    };
  }

  factory NewExam.fromMap(Map<String, dynamic> map) {
    return NewExam(
      index: map['index'],
      examID: map['exam_ID'],
      passingMarks: map['passing_marks'],
      title: map['title'],
      questionAnswerSet: map['question_answer_set'],
    );
  }
}

class QuestionAnswerSet {
  String questionName;
  String questionID;
  QUESTIONTYPE? type; // If you still want to keep the question type.
  List<Option> options;

  QuestionAnswerSet({
    required this.questionName,
    required this.questionID,
    required this.options,
    required this.type, // If you still want to keep the question type.
  });

  Map<String, dynamic> toMap() {
    return {
      'questionName': questionName,
      'questionID': questionID,
      'options': options.map((option) => option.toMap()).toList(),
      'type': EnumToString.getStringValue(
          type), // If you still want to keep the question type.
    };
  }

  factory QuestionAnswerSet.fromMap(Map<String, dynamic> map) {
    return QuestionAnswerSet(
      questionName: map['questionName'],
      questionID: map['questionID'],
      options: (map['options'] as List)
          .map((optionMap) => Option.fromMap(optionMap as Map<String, dynamic>))
          .toList(),
      type: EnumToString.fromString(QUESTIONTYPE.values, map['type']) ??
          QUESTIONTYPE.Checkbox, // If you still want to keep the question type.
    );
  }
}

class Option {
  int optionID;
  String optionText;
  bool optionBool;

  Option({
    required this.optionID,
    required this.optionText,
    required this.optionBool,
  });

  Map<String, dynamic> toMap() {
    return {
      'optionID': optionID,
      'optionText': optionText,
      'optionBool': optionBool,
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      optionID: map['optionID'],
      optionText: map['optionText'],
      optionBool: map['optionBool'],
    );
  }
}
