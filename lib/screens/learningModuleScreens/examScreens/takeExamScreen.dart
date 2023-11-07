// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/question.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../models/course.dart';
import '../../../models/module.dart';
import '../../../projectModules/courseManagement/coursesProvider.dart';

class TakeExamScreen extends StatefulWidget {
  const TakeExamScreen(
      {super.key, required this.exam,
      required this.course,
      required this.examtype,
      this.module});
  final EXAMTYPE examtype;
  final Course course;
  final Module? module;
  final NewExam exam;
  @override
  State<TakeExamScreen> createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen> {
  final List<NewQuestion> _questions = [];
  int _currentIndex = 0;
  List<Set<int>> _selectedAnswers = [];
  bool _showScore = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    shuffleQuestions();
    _selectedAnswers = List.generate(_questions.length, (index) => <int>{});
    if (kDebugMode) {
      print(widget.exam.questionAnswerSet);
    }
  }

  loadQuestions() {
    for (var element in widget.exam.questionAnswerSet) {
      List<String> options = [];
      List<int> correctAnswers = [];
      int index = 0;
      element['options'].forEach((option) {
        options.add(option['option_value']);
        if (option['option_bool'] == true) {
          correctAnswers.add(index);
        }
        index++;
      });
      NewQuestion newQuestion = NewQuestion(element['questionName'], options,
          correctAnswers, correctAnswers.length);
      _questions.add(newQuestion);
    }
  }

  void shuffleQuestions() {
    for (var q in _questions) {
      q.shuffledOptions.shuffle();
      q.shuffledCorrectAnswers = q.correctAnswers
          .map((index) => q.shuffledOptions.indexOf(q.options[index]))
          .toList();
    }
  }

  bool get areAnswersSelected {
    int correctAnswerCount =
        _questions[_currentIndex].shuffledCorrectAnswers.length;
    int selectedCount = _selectedAnswers[_currentIndex].length;

    if (correctAnswerCount > 1) {
      return selectedCount >= 1 && selectedCount <= correctAnswerCount;
    } else {
      return selectedCount == 1;
    }
  }

  void onButtonPress() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      setState(() {
        _showScore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    return Scaffold(
      appBar: AppBar(title: Text(_showScore ? 'Score' : 'Exam Module')),
      body: _showScore ? buildScoreWidget() : buildExamWidget(),
    );
  }

  Widget buildScoreWidget() {
    LoggedInState loggedInState = Provider.of<LoggedInState>(context);
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (Set.from(_questions[i].shuffledCorrectAnswers)
          .containsAll(_selectedAnswers[i])) {
        correctAnswers++;
      }
    }

    double percentageScore = (correctAnswers / _questions.length) * 100;

    if (percentageScore < 75) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Your Score is: $correctAnswers/${_questions.length}. You need to get 75% to pass.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                shuffleQuestions();
                _currentIndex = 0;
                _selectedAnswers =
                    List.generate(_questions.length, (index) => <int>{});
                _showScore = false;
              }),
              child: const Text('Retake Exam'),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Congratulations! Your Score is: $correctAnswers/${_questions.length}'),
            const SizedBox(height: 20),
            if (widget.examtype == EXAMTYPE.courseExam)
              ElevatedButton(
                onPressed: () async {
                  bool isAllExamsCompleted =
                      await loggedInState.setUserCourseExamCompleted(
                          coursesProvider: coursesProvider,
                          course: widget.course,
                          courseDetails: {
                            "courseID": widget.course.id,
                            "course_name": widget.course.name,
                            "course_modules_completed":
                                widget.course.modulesCount
                          },
                          examIndex: widget.exam.index);
                  if (isAllExamsCompleted) {
                    await loggedInState.setUserCourseCompleted(courseDetails: {
                      "courseID": widget.course.id,
                      "course_name": widget.course.name,
                      "course_modules_completed": widget.course.modulesCount
                    });
                  }
                  if (!context.mounted) return;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: Text(
                    "Mark Exam as Done- completed ${widget.exam.index}/${widget.course.exams.length}"),
              )
            else if (widget.examtype == EXAMTYPE.moduleExam)
              ElevatedButton(
                onPressed: () {
                  loggedInState.setUserModuleExamCompleted(
                    courseDetails: {
                      "courseID": widget.course.id,
                      "course_name": widget.course.name,
                      "module_title": widget.module?.title,
                    },
                    course: widget.course,
                    module: widget.module!,
                    coursesProvider: coursesProvider,
                    examIndex: widget.exam.index,
                  );

                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: const Text("Mark Quiz as Done"),
              ),
            ElevatedButton(
              onPressed: () => setState(() {
                shuffleQuestions();
                _currentIndex = 0;
                _selectedAnswers =
                    List.generate(_questions.length, (index) => <int>{});
                _showScore = false;
              }),
              child: const Text('Retry for Fun!'),
            ),
          ],
        ),
      );
    }
  }

  Widget buildExamWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _questions[_currentIndex].question,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Text(
            'Select ${_questions[_currentIndex].maxAllowedAnswers} answer(s)',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...List.generate(_questions[_currentIndex].shuffledOptions.length,
              (index) {
            return ListTile(
              title: Text(_questions[_currentIndex].shuffledOptions[index]),
              leading: Checkbox(
                value: _selectedAnswers[_currentIndex].contains(index),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      if (_selectedAnswers[_currentIndex].length <
                          _questions[_currentIndex].maxAllowedAnswers) {
                        _selectedAnswers[_currentIndex].add(index);
                      }
                    } else {
                      _selectedAnswers[_currentIndex].remove(index);
                    }
                  });
                },
              ),
            );
          }),
          ElevatedButton(
            onPressed: areAnswersSelected ? () => onButtonPress() : null,
            child:
                Text(_currentIndex < _questions.length - 1 ? 'Next' : 'Submit'),
          )
        ],
      ),
    );
  }
}
