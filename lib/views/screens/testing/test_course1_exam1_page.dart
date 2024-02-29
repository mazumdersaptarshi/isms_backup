import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:isms/utilities/random_key_generator.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class TestCourse1Exam1Page extends StatefulWidget {
  @override
  _TestCourse1Exam1PageState createState() => _TestCourse1Exam1PageState();
}

class _TestCourse1Exam1PageState extends State<TestCourse1Exam1Page> {
  final List<TestQuestion> questions = [
    TestQuestion(
      questionText: 'Which HTML tag is used to define an internal style sheet?',
      options: ['<style>', '<script>', '<css>', '<link>'],
      correctAnswerIndex: 0,
    ),
    TestQuestion(
      questionText: 'Which is not a JavaScript data type?',
      options: ['Undefined', 'Number', 'Boolean', 'Float'],
      correctAnswerIndex: 3,
    ),
    TestQuestion(
      questionText: 'What does CSS stand for?',
      options: ['Colorful Style Sheets', 'Computer Style Sheets', 'Cascading Style Sheets', 'Creative Style Sheets'],
      correctAnswerIndex: 2,
    ),
  ];
  String courseId1 = 'ip78hd';
  String examId1 = 'de44qv';
  dynamic startTime;
  int passing_score = 20;

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
          double score = 0;
          for (int i = 0; i < questions.length; i++) {
            if (userAnswers[i] == questions[i].correctAnswerIndex) {
              score++;
            }
          }

          UserProgressState.updateUserExamProgress(
              loggedInState: loggedInState,
              courseId: courseId1,
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
          // await loggedInState.updateUserProgress(fieldName: 'exams', key: examId1, data: {
          //   'courseId': courseId1,
          //   'examId': examId1,
          //   'attempts': attempts1,
          //   'completionStatus': 'not_completed',
          // });

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

class TestQuestion {
  String questionText;
  List<String> options;
  int correctAnswerIndex;

  TestQuestion({required this.questionText, required this.options, required this.correctAnswerIndex});
}
