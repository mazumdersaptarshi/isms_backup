// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/question.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCompletionStrategies.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../models/course.dart';
import '../../../models/module.dart';
import '../../../sharedWidgets/navIndexTracker.dart';
import '../../../utilityFunctions/platformCheck.dart';

class TakeExamScreen extends StatefulWidget {
  const TakeExamScreen(
      {super.key,
      required this.exam,
      required this.course,
      required this.examtype,
      this.module,
      required this.examCompletionStrategy});
  final EXAMTYPE examtype;
  final Course course;
  final Module? module;
  final NewExam exam;
  final ExamCompletionStrategy examCompletionStrategy;
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
    debugPrint("LOADING QUESTIONS");
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
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);
    LoggedInState loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showScore ? 'Score' : 'Exam Module',
          style: const TextStyle(color: white),
        ),
        backgroundColor: Colors.deepPurpleAccent.shade100,
      ),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: _showScore ? buildScoreWidget() : buildExamWidget(),
    );
  }

  Widget buildScoreWidget() {
    //LoggedInState loggedInState = Provider.of<LoggedInState>(context);
    //CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    int correctAnswers = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (Set.from(_questions[i].shuffledCorrectAnswers)
          .containsAll(_selectedAnswers[i])) {
        correctAnswers++;
      }
    }

    double percentageScore = (correctAnswers / _questions.length) * 100;
    double failedScore = 100 - percentageScore;

    if (percentageScore < 75) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Text(
                    'Your Score is: $correctAnswers/${_questions.length}. You need to get 75% to pass.'),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: PieChart(PieChartData(centerSpaceRadius: 40, sections: [
                  PieChartSectionData(
                    value: percentageScore,
                    title: '${percentageScore.toStringAsFixed(1)}%',
                    radius: 80,
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                  PieChartSectionData(
                      value: failedScore,
                      title: '${failedScore.toStringAsFixed(1)}%',
                      color: const Color.fromARGB(255, 255, 167, 167),
                      radius: 75),
                ])),
              ),
              const SizedBox(height: 150),
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
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'Congratulations! Your Score is: $correctAnswers/${_questions.length}',
                ),
              ),
              SizedBox(
                height: 50,
                width: 50,
                child: PieChart(PieChartData(centerSpaceRadius: 40, sections: [
                  PieChartSectionData(
                    value: percentageScore,
                    title: '${percentageScore.toStringAsFixed(1)}%',
                    radius: 80,
                    color: Colors.deepPurpleAccent.shade100,
                  ),
                  PieChartSectionData(
                      value: failedScore,
                      title: '${failedScore.toStringAsFixed(1)}%',
                      color: const Color.fromARGB(255, 255, 167, 167),
                      radius: 75),
                ])),
              ),
              const SizedBox(height: 100),
              widget.examCompletionStrategy.buildSumbitButton(context: context),
              const SizedBox(height: 20),
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
        ),
      );
    }
  }

  Widget buildExamWidget() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.deepPurpleAccent.shade100,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _questions[_currentIndex].question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, color: white),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Select ${_questions[_currentIndex].maxAllowedAnswers} answer(s)',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(_questions[_currentIndex].shuffledOptions.length,
              (index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                surfaceTintColor: white,
                elevation: 4,
                shadowColor: secondaryColor,
                shape: customCardShape,
                child: ListTile(
                  title: Text(_questions[_currentIndex].shuffledOptions[index]),
                  leading: Checkbox(
                    fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.disabled)) {
                        return Colors.grey; // Fill color for the disabled state
                      }
                      if (states.contains(MaterialState.selected)) {
                        return secondaryColor; // Fill color when the checkbox is checked
                      }
                      return white; // Fill color when the checkbox is unchecked
                    }),
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
                ),
              ),
            );
          }),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            style: customElevatedButtonStyle(),
            onPressed: areAnswersSelected ? () => onButtonPress() : null,
            child: Text(
              _currentIndex < _questions.length - 1 ? 'Next' : 'Submit',
              style: const TextStyle(color: white),
            ),
          )
        ],
      ),
    );
  }
}
