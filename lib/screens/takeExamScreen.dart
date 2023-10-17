import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/models/question.dart';
import 'package:isms/screens/examCreationScreen.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:provider/provider.dart';

import '../userManagement/userCourseOperations.dart';

class TakeExamScreen extends StatefulWidget {
  TakeExamScreen(
      {required this.exam,
      required this.courseIndex,
      required this.examtype,
      this.moduleIndex});
  EXAMTYPE examtype;
  int courseIndex;
  int? moduleIndex;
  NewExam exam;
  @override
  _TakeExamScreenState createState() => _TakeExamScreenState();
}

class _TakeExamScreenState extends State<TakeExamScreen> {
  List<NewQuestion> questions = [];
  int currentIndex = 0;
  List<Set<int>> selectedAnswers = [];
  bool showScore = false;

  @override
  void initState() {
    super.initState();
    loadQuestions();
    shuffleQuestions();
    selectedAnswers = List.generate(questions.length, (index) => <int>{});
    print(widget.exam.questionAnswerSet);
  }

  loadQuestions() {
    widget.exam.questionAnswerSet.forEach((element) {
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
      questions.add(newQuestion);
    });
    // return [
    //   NewQuestion('What is the capital of France?',
    //       ['London', 'Berlin', 'Paris', 'Madrid'], [2], 1),
    //   NewQuestion('Which planet is known as the Red Planet?',
    //       ['Earth', 'Mars', 'Jupiter', 'Venus'], [1], 1),
    //   NewQuestion(
    //       'Who wrote "Romeo and Juliet"?',
    //       [
    //         'Charles Dickens',
    //         'William Shakespeare',
    //         'George Orwell',
    //         'J.K. Rowling'
    //       ],
    //       [1],
    //       1),
    //   NewQuestion('Which of these is a prime number?', ['2', '15', '17', '19'],
    //       [0, 2, 3], 3),
    //   NewQuestion('What is the largest mammal?',
    //       ['Elephant', 'Blue Whale', 'Giraffe', 'Kangaroo'], [1], 1),
    // ];
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
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context);
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
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
                if (widget.examtype == EXAMTYPE.courseExam)
                  ElevatedButton(
                      onPressed: () {
                        setUserCourseCompleted(
                            customUserProvider: customUserProvider,
                            courseDetails: {
                              "courseID": coursesProvider
                                  .allCourses[widget.courseIndex].id,
                              "course_name": coursesProvider
                                  .allCourses[widget.courseIndex].name,
                            });
                      },
                      child: Text("Mark course as Done"))
                else if (widget.examtype == EXAMTYPE.moduleExam)
                  ElevatedButton(
                      onPressed: () {
                        setUserCourseModuleCompleted(
                            customUserProvider: customUserProvider,
                            courseDetails: {
                              "courseID": coursesProvider
                                  .allCourses[widget.courseIndex].id,
                              "course_name": coursesProvider
                                  .allCourses[widget.courseIndex].name
                            },
                            courseIndex: widget.courseIndex,
                            moduleIndex: widget.moduleIndex!,
                            coursesProvider: coursesProvider);
                      },
                      child: Text("Mark Module as Done")),
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
