class UserQuestionResponse {
  String questionId;
  List<String> selectedAnswerIds;
  bool isCorrect = false;

  UserQuestionResponse({required this.questionId, List<String>? selectedAnswerIds})
      : this.selectedAnswerIds = selectedAnswerIds ?? [];

  void updateResponse(List<String> answerIds, List<String> correctAnswerIds) {
    selectedAnswerIds = answerIds;
    isCorrect = _checkCorrectness(answerIds, correctAnswerIds);
  }

  bool _checkCorrectness(List<String> answerIds, List<String> correctAnswerIds) {
    if (answerIds.toSet().containsAll(correctAnswerIds) && answerIds.toSet().length == correctAnswerIds.length) {
      return true;
    }
    return false;
  }
}
