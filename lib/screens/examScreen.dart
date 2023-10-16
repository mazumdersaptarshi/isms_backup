import 'package:flutter/material.dart';
import 'package:isms/models/question.dart';

class ExamScreen extends StatefulWidget {
  @override
  _ExamScreenState createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  List<NewQuestion> questions = [];
  int currentIndex = 0;
  List<Set<int>> selectedAnswers = [];
  bool showScore = false;

  @override
  void initState() {
    super.initState();
    questions = loadQuestions();
    shuffleQuestions();
    selectedAnswers = List.generate(questions.length, (index) => <int>{});
  }

  List<NewQuestion> loadQuestions() {
    return [
      NewQuestion('What is the capital of France?',
          ['London', 'Berlin', 'Paris', 'Madrid'], [2], 1),
      NewQuestion('Which planet is known as the Red Planet?',
          ['Earth', 'Mars', 'Jupiter', 'Venus'], [1], 1),
      NewQuestion(
          'Who wrote "Romeo and Juliet"?',
          [
            'Charles Dickens',
            'William Shakespeare',
            'George Orwell',
            'J.K. Rowling'
          ],
          [1],
          1),
      NewQuestion('Which of these is a prime number?', ['2', '15', '17', '19'],
          [0, 2, 3], 3),
      NewQuestion('What is the largest mammal?',
          ['Elephant', 'Blue Whale', 'Giraffe', 'Kangaroo'], [1], 1),
    ];
  }

  void shuffleQuestions() {
    for (var q in questions) {
      q.shuffledOptions.shuffle();
      q.shuffledCorrectAnswers = q.correctAnswers
          .map((index) => q.shuffledOptions.indexOf(q.options[index]))
          .toList();
    }
  }

  bool get areAnswersSelected {
    int correctAnswerCount =
        questions[currentIndex].shuffledCorrectAnswers.length;
    int selectedCount = selectedAnswers[currentIndex].length;

    if (correctAnswerCount > 1) {
      return selectedCount >= 1 && selectedCount <= correctAnswerCount;
    } else {
      return selectedCount == 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showScore) {
      int correctAnswers = 0;
      for (int i = 0; i < questions.length; i++) {
        if (Set.from(questions[i].shuffledCorrectAnswers)
            .containsAll(selectedAnswers[i])) {
          correctAnswers++;
        }
      }

      double percentageScore = (correctAnswers / questions.length) * 100;

      if (percentageScore < 75) {
        return Scaffold(
          appBar: AppBar(title: Text('Retake Exam')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Your Score is: $correctAnswers/${questions.length}. You need to get 75% to pass.'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => setState(() {
                    shuffleQuestions();
                    currentIndex = 0;
                    selectedAnswers =
                        List.generate(questions.length, (index) => <int>{});
                    showScore = false;
                  }),
                  child: Text('Retake Exam'),
                )
              ],
            ),
          ),
        );
      } else {
        return Scaffold(
          appBar: AppBar(title: Text('Score')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Congratulations! Your Score is: $correctAnswers/${questions.length}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => setState(() {
                    shuffleQuestions();
                    currentIndex = 0;
                    selectedAnswers =
                        List.generate(questions.length, (index) => <int>{});
                    showScore = false;
                  }),
                  child: Text('Retry for Fun!'),
                )
              ],
            ),
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Exam Module')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              questions[currentIndex].question,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Select ${questions[currentIndex].maxAllowedAnswers} answer(s)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            ...List.generate(questions[currentIndex].shuffledOptions.length,
                (index) {
              return ListTile(
                title: Text(questions[currentIndex].shuffledOptions[index]),
                leading: Checkbox(
                  value: selectedAnswers[currentIndex].contains(index),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (selectedAnswers[currentIndex].length <
                            questions[currentIndex].maxAllowedAnswers) {
                          selectedAnswers[currentIndex].add(index);
                        }
                      } else {
                        selectedAnswers[currentIndex].remove(index);
                      }
                    });
                  },
                ),
              );
            }),
            ElevatedButton(
              onPressed: areAnswersSelected
                  ? () {
                      if (currentIndex < questions.length - 1) {
                        setState(() {
                          currentIndex++;
                        });
                      } else {
                        setState(() {
                          showScore = true;
                        });
                      }
                    }
                  : null,
              child:
                  Text(currentIndex < questions.length - 1 ? 'Next' : 'Submit'),
            )
          ],
        ),
      ),
    );
  }
}
