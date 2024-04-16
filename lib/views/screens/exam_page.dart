import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/enums.dart';
import 'package:isms/models/course/exam_full.dart';
import 'package:isms/models/course/section_full.dart';
import 'package:isms/views/screens/user_screens/exam_questions_section.dart';
import 'package:isms/views/widgets/course_widgets/checkbox_list.dart';
import 'package:isms/views/widgets/course_widgets/radio_list.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/models/course/element.dart' as ExamElement;

import '../../models/course/answer.dart';
import '../../models/course/question.dart';

class ExamPage extends StatefulWidget {
  ExamPage({
    super.key,
    required this.examId,
  });

  String examId = 'none';

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  late String _loggedInUserUid;

  @override
  void initState() {
    super.initState();

    _loggedInUserUid = Provider.of<LoggedInState>(context, listen: false).currentUserUid!;
    _getExamContent();
  }

  late ExamFull _ef;

  Map<String, List<String>> _userResponses = {};
  List<Question> _questions = [];
  int _questionCounter = 0;

  Future<dynamic> _getExamContent() async {
    ExamFull ef = await Provider.of<ExamProvider>(context, listen: false).getExamContent(examId: widget.examId);
    setState(() {
      _ef = ef;
    });
  }

  List<Question> _buildSectionQuestions({required List<ExamElement.Element> sectionElements}) {
    List<Question> questions = [];
    sectionElements.forEach((ExamElement.Element element) {
      List<Answer> answers = [];
      element.elementContent[0]['questionAnswers'].forEach((answer) {
        answers.add(
          Answer(
              answerId: answer['answerId'],
              answerText: answer['answerText'],
              answerCorrect: answer['answerCorrect'],
              answerExplanation: ''),
        );
      });
      Question question = Question(
        questionId: element.elementContent[0]['questionId'],
        questionType: element.elementContent[0]['questionType'],
        questionText: element.elementContent[0]['questionText'],
        questionAnswers: answers,
      );
      questions.add(question);
    });
    _getCorrectAnswersMap(questions);
    _questions = [..._questions, ...questions];
    return questions;
  }

  Map<String, List<String>> _correctAnswersMap = {};

  Map<String, List<String>> _getCorrectAnswersMap(List<Question> questions) {
    for (Question question in questions) {
      List<String> correctIds =
          question.questionAnswers.where((answer) => answer.answerCorrect).map((answer) => answer.answerId).toList();
      _correctAnswersMap[question.questionId] = correctIds;
    }
    print('Correwct answers: $_correctAnswersMap');
    return _correctAnswersMap;
  }

  void _calculateScore() {
    int score = 0;

    _userResponses.forEach((questionId, userAnswerIds) {
      List<String> correctAnswerIds = _correctAnswersMap[questionId] ?? [];

      // Check the response type based on the number of correct answers
      if (correctAnswerIds.length == 1) {
        // Assuming single-selection if only one correct answer
        if (userAnswerIds.contains(correctAnswerIds.first)) {
          score += 1;
        }
      } else {
        // Multi-selection
        Set<String> correctSet = Set.from(correctAnswerIds);
        Set<String> userSet = Set.from(userAnswerIds);
        if (correctSet.difference(userSet).isEmpty && userSet.difference(correctSet).isEmpty) {
          score += 1;
        }
      }
    });

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Score"),
              content: Text("Your total score is: $score out of ${_questions.length}"),
              actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("OK"))],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: IsmsAppBar(context: context),
      // drawer: IsmsDrawer(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.2,
          vertical: 0,
        ),
        child: (_ef != null)
            ? _ef.examSections != null
                ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _ef.examTitle,
                              style: TextStyle(
                                color: ThemeConfig.primaryColor,
                                fontSize: 24,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              _ef.examDescription,
                              style: TextStyle(color: ThemeConfig.tertiaryTextColor1, fontSize: 16),
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                            onPressed: () {
                              _calculateScore();
                            },
                            child: Text('Save and Submit')),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _ef.examSections!.length != 0
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            // width: MediaQuery.of(context).size.width * 0.8,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: _ef.examSections!.length,
                                itemBuilder: (context, index) {
                                  int currentSectionStartIndex = _questionCounter;

                                  List<Question> sectionQuestions = _buildSectionQuestions(
                                      sectionElements: _ef.examSections![index].sectionElements!);
                                  _questionCounter += sectionQuestions.length;

                                  if (_ef.examSections![index].sectionElements != null) {
                                    return ExamQuestionsSection(
                                      questions: sectionQuestions,
                                      userResponses: _userResponses,
                                      startIndex: currentSectionStartIndex,
                                    );
                                  }
                                }),
                          )
                        : Text('No exam sections found'),
                  ])
                : Text('No exam found')
            : CircularProgressIndicator(),
      ),
    );
  }
}
