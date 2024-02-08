import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/utilities/random_key_generator.dart';
import 'package:provider/provider.dart';

class TestCourse3Exam1Page extends StatefulWidget {
  @override
  _TestCourse3Exam1PageState createState() => _TestCourse3Exam1PageState();
}

class _TestCourse3Exam1PageState extends State<TestCourse3Exam1Page> {
  final List<Question> questions = [
    Question(
      questionText: 'Identify the language which is used in data science?',
      options: ['C++', 'R', 'Java', 'Ruby'],
      correctAnswerIndex: 3,
    ),
    Question(
      questionText: 'Choose whether the following statement is true or false:  Unstructured data is not organized',
      options: ['True', 'False', 'maybe true or false', 'cannot be determined'],
      correctAnswerIndex: 0,
    ),
    Question(
      questionText: 'A column is a  _________- representation of data.',
      options: ['Diagonal', 'Vertical', 'Top', 'horizontal0'],
      correctAnswerIndex: 1,
    ),
  ];

  String courseId2 = 'po76nm';
  String examId1 = 'ik54kj';
  int passing_score = 20;
  dynamic startTime;
  List<int> userAnswers = [-1, -1, -1]; // To store user's answers
  void initState() {
    super.initState();
    startTime = DateTime.now();
  }

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
                'startTime': startTime,
                'endTime': DateTime.now(),
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