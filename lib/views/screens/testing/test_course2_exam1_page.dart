import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/utilities/random_key_generator.dart';
import 'package:provider/provider.dart';

class TestCourse2Exam1Page extends StatefulWidget {
  @override
  _TestCourse2Exam1PageState createState() => _TestCourse2Exam1PageState();
}

class _TestCourse2Exam1PageState extends State<TestCourse2Exam1Page> {
  final List<Question> questions = [
    Question(
      questionText: 'What is the output of print(0.1 + 0.2 == 0.3)?',
      options: ['True', 'False', 'Error', 'None'],
      correctAnswerIndex: 1,
    ),
    Question(
      questionText: 'How do you insert COMMENTS in Python code?',
      options: ['# comment', '// comment', '/* comment */', '<!-- comment -->'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'Which of the following is a correct variable declaration in Python?',
      options: ['int a = 10', 'a = 10', 'var a = 10', 'let a = 10'],
      correctAnswerIndex: 1,
    ),
  ];

  String courseId2 = 'tt89mn';
  String examId1 = 'rt89nb';
  int passing_score = 20;
  List<int> userAnswers = [-1, -1, -1]; // To store user's answers

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Web Development Quiz'),
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    questions[index].questionText,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 10.0),
                  ...questions[index].options.asMap().entries.map((option) {
                    return RadioListTile<int>(
                      title: Text(
                        option.value,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: option.key,
                      groupValue: userAnswers[index],
                      onChanged: (value) {
                        setState(() {
                          userAnswers[index] = value!;
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          int score = 0;
          for (int i = 0; i < questions.length; i++) {
            if (userAnswers[i] == questions[i].correctAnswerIndex) {
              score++;
            }
          }
          UserProgressState.updateUserExamProgress(
              loggedInState: loggedInState,
              courseId: courseId2,
              examId: examId1,
              newAttemptData: {
                'attemptId': randomKeyGenerator(),
                'startTime': DateTime.now(),
                'endTime': '',
                'completionStatus': 'completed',
                'score': ((score / questions.length) * 100).toInt(),
                'result': 'PASS',
                'responses': [],
              });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Result'),
              content: Text('You scored $score out of ${questions.length}'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class Question {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  Question({required this.questionText, required this.options, required this.correctAnswerIndex});
}
