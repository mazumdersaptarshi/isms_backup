class NewQuestion {
  final String question;
  final List<String> options;
  final List<int> correctAnswers;
  List<String> shuffledOptions;
  List<int> shuffledCorrectAnswers;
  int maxAllowedAnswers;

  NewQuestion(
      this.question, this.options, this.correctAnswers, this.maxAllowedAnswers)
      : shuffledOptions = List.from(options),
        shuffledCorrectAnswers = List.from(correctAnswers);
}
