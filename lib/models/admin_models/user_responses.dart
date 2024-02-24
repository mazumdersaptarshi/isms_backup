class Question {
  final String questionText;
  final List<Answer> answers;
  final int userSelectedAnswerIndex; // Index of the user's selected answer

  Question(
      {required this.questionText,
      required this.answers,
      required this.userSelectedAnswerIndex});
}

class Answer {
  final String answerText;
  final bool isCorrect;

  Answer({required this.answerText, required this.isCorrect});
}
