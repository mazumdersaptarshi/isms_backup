import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

import '../../../../models/admin_models/user_responses.dart';

class AdminTestResponsesPage extends StatelessWidget {
  List<Question> getSampleQuestions() {
    return [
      Question(
        questionText: "What is Python primarily used for?",
        answers: [
          Answer(answerText: "Web development", isCorrect: true),
          Answer(answerText: "Mobile development", isCorrect: false),
          Answer(answerText: "Game development", isCorrect: false),
          Answer(answerText: "System administration", isCorrect: false),
        ],
        userSelectedAnswerIndex: 0, // Correct
      ),
      Question(
        questionText: "Which of the following is a mutable data type?",
        answers: [
          Answer(answerText: "Tuple", isCorrect: false),
          Answer(answerText: "String", isCorrect: false),
          Answer(answerText: "List", isCorrect: true),
          Answer(answerText: "Integer", isCorrect: false),
        ],
        userSelectedAnswerIndex: 2, // Correct
      ),
      Question(
        questionText: "How do you start a comment in Python?",
        answers: [
          Answer(answerText: "//", isCorrect: false),
          Answer(answerText: "#", isCorrect: true),
          Answer(answerText: "/*", isCorrect: false),
          Answer(answerText: "<!--", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Incorrect
      ),
      Question(
        questionText: "What does the 'len()' function return?",
        answers: [
          Answer(answerText: "The length of an object", isCorrect: true),
          Answer(answerText: "The size of an object", isCorrect: false),
          Answer(answerText: "The type of an object", isCorrect: false),
          Answer(answerText: "The value of an object", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Incorrect
      ),
      Question(
        questionText: "Which keyword is used to define a function in Python?",
        answers: [
          Answer(answerText: "func", isCorrect: false),
          Answer(answerText: "def", isCorrect: true),
          Answer(answerText: "function", isCorrect: false),
          Answer(answerText: "define", isCorrect: false),
        ],
        userSelectedAnswerIndex: 3, // Incorrect
      ),
      Question(
        questionText: "What data type is the result of: 3 / 2?",
        answers: [
          Answer(answerText: "Integer", isCorrect: false),
          Answer(answerText: "Float", isCorrect: true),
          Answer(answerText: "String", isCorrect: false),
          Answer(answerText: "Boolean", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Correct
      ),
      Question(
        questionText: "Which function converts a string into an integer?",
        answers: [
          Answer(answerText: "int()", isCorrect: true),
          Answer(answerText: "str()", isCorrect: false),
          Answer(answerText: "float()", isCorrect: false),
          Answer(answerText: "bool()", isCorrect: false),
        ],
        userSelectedAnswerIndex: 2, // Incorrect
      ),
      Question(
        questionText: "Which operator is used in Python to check if two variables are equal?",
        answers: [
          Answer(answerText: "=", isCorrect: false),
          Answer(answerText: "==", isCorrect: true),
          Answer(answerText: "equals", isCorrect: false),
          Answer(answerText: "is", isCorrect: false),
        ],
        userSelectedAnswerIndex: 3, // Incorrect
      ),
      Question(
        questionText: "What is the correct way to create a list?",
        answers: [
          Answer(answerText: "list = list()", isCorrect: false),
          Answer(answerText: "list = []", isCorrect: true),
          Answer(answerText: "list = {}", isCorrect: false),
          Answer(answerText: "list = ()", isCorrect: false),
        ],
        userSelectedAnswerIndex: 0, // Incorrect
      ),
      Question(
        questionText: "How is a dictionary item removed?",
        answers: [
          Answer(answerText: "del dict[item]", isCorrect: true),
          Answer(answerText: "dict.remove(item)", isCorrect: false),
          Answer(answerText: "dict.delete(item)", isCorrect: false),
          Answer(answerText: "remove.dict[item]", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Incorrect
      ),
      Question(
        questionText: "What is the output of print(type(10))?",
        answers: [
          Answer(answerText: "<class 'int'>", isCorrect: true),
          Answer(answerText: "<class 'str'>", isCorrect: false),
          Answer(answerText: "<class 'float'>", isCorrect: false),
          Answer(answerText: "<type 'int'>", isCorrect: false),
        ],
        userSelectedAnswerIndex: 3, // Incorrect
      ),
      Question(
        questionText: "Which of the following is not a Python loop construct?",
        answers: [
          Answer(answerText: "for", isCorrect: false),
          Answer(answerText: "while", isCorrect: false),
          Answer(answerText: "do-while", isCorrect: true),
          Answer(answerText: "foreach", isCorrect: false),
        ],
        userSelectedAnswerIndex: 3, // Incorrect
      ),
      Question(
        questionText: "Which method is used to add an item to the end of a list?",
        answers: [
          Answer(answerText: "list.add()", isCorrect: false),
          Answer(answerText: "list.append()", isCorrect: true),
          Answer(answerText: "list.push()", isCorrect: false),
          Answer(answerText: "list.insert()", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Incorrect
      ),
      Question(
        questionText: "What will be the output of the following code: print('Python'[-1])?",
        answers: [
          Answer(answerText: "'P'", isCorrect: false),
          Answer(answerText: "'n'", isCorrect: true),
          Answer(answerText: "Error", isCorrect: false),
          Answer(answerText: "'Python'", isCorrect: false),
        ],
        userSelectedAnswerIndex: 1, // Incorrect
      ),
      Question(
        questionText:
            "Which of the following is a correct syntax to output the type of a variable or object in Python?",
        answers: [
          Answer(answerText: "print(typeOf(variable))", isCorrect: false),
          Answer(answerText: "print(typeof variable)", isCorrect: false),
          Answer(answerText: "print(type(variable))", isCorrect: true),
          Answer(answerText: "print(variable.type())", isCorrect: false),
        ],
        userSelectedAnswerIndex: 2, // Correct
      )
    ];
  }

  double calculateScore(List<Question> questions) {
    int correctAnswers = 0;
    questions.forEach((question) {
      if (question.answers[question.userSelectedAnswerIndex].isCorrect) {
        correctAnswers++;
      }
    });
    return (correctAnswers / questions.length) * 100; // Return score as a percentage
  }

  @override
  Widget build(BuildContext context) {
    double score = calculateScore(getSampleQuestions());
    int timeTakenInSeconds = 2220; // 37 minutes in seconds

    return Scaffold(
      appBar: AppBar(
        title: Text("User Test Responses"),
        backgroundColor: ThemeConfig.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1, 10, MediaQuery.of(context).size.width * 0.1, 10),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Score: ",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: ThemeConfig.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              value: double.parse(score.toStringAsFixed(2)) / 100.0,
                              valueColor: double.parse(score.toStringAsFixed(2)) > 70
                                  ? AlwaysStoppedAnimation<Color>(Colors.lightGreen!)
                                  : double.parse(score.toStringAsFixed(2)) > 45
                                      ? AlwaysStoppedAnimation<Color>(Colors.orangeAccent!)
                                      : AlwaysStoppedAnimation<Color>(Colors.red!),
                              backgroundColor: Colors.grey.shade200,
                              strokeWidth: 5.0,
                            ),
                          ),
                          Text(
                            '${score.toStringAsFixed(2)}%',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Time Taken: ${Duration(seconds: timeTakenInSeconds).inMinutes} minutes",
                    style: TextStyle(fontSize: 14, color: ThemeConfig.primaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(), // Add this to ensure scrolling works correctly
              itemCount: getSampleQuestions().length,
              itemBuilder: (context, index) {
                final question = getSampleQuestions()[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}: ${question.questionText}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: ThemeConfig.primaryColor,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...question.answers.asMap().entries.map((entry) {
                          int idx = entry.key;
                          Answer answer = entry.value;
                          bool isSelected = idx == question.userSelectedAnswerIndex;
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<bool>(
                                  value: isSelected,
                                  groupValue: true,
                                  onChanged: null,
                                  activeColor: answer.isCorrect ? Colors.green : Colors.red,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? (answer.isCorrect ? Colors.lightGreen : Colors.red.shade400)
                                          : null,
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: answer.isCorrect && !isSelected
                                          ? Border.all(color: Colors.lightGreen, width: 2)
                                          : null,
                                    ),
                                    child: Text(
                                      answer.answerText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isSelected ? Colors.white : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
