import 'dart:async';

import 'package:flutter/material.dart';
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/models/course/element.dart' as ExamElement;
import 'package:isms/models/course/exam_full.dart';
import 'package:isms/views/screens/user_screens/exam_questions_section.dart';
import 'package:provider/provider.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../models/course/answer.dart';
import '../../models/course/question.dart';

class ExamPage extends StatefulWidget {
  ExamPage({
    super.key,
    required this.examId,
  });

  final String examId;

  @override
  State<ExamPage> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage>
    with AutomaticKeepAliveClientMixin<ExamPage> {
  late String _loggedInUserUid;
  late ExamFull _ef;

  Map<String, List<String>> _userResponses = {};
  List<Question> _questions = [];
  Duration _remainingTime = Duration();
  Timer? _timer;
  DateTime? _startTime;
  DateTime? _endTime;

  Map<String, dynamic> _sectionQuestionCounter = {};
  Map<String, dynamic> _sectionQuestionsMap = {};

  String? _estimatedTime;
  int _passMark = 0;
  int _durationInSeconds = 0;
  int _score = 0;
  late String _CSRF_TOKEN;
  late String _JWT;
  Map<String, List<String>> _correctAnswersMap = {};
  static bool isExamCompleted = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _loggedInUserUid =
        Provider.of<LoggedInState>(context, listen: false).currentUserUid!;

    _getExamContent();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  void _startTimer() {
    if (_estimatedTime != null) {
      _estimatedTime = '00:01:00';
      final parts = _estimatedTime!.split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      _remainingTime = Duration(hours: hours, minutes: minutes);
      _durationInSeconds = _remainingTime.inSeconds;
      _startTime = DateTime.now(); // Record start time

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime.inSeconds == 0) {
          setState(() {
            timer.cancel();
            // _timer!.cancel();
          });
          onTimeExpired();
        } else {
          setState(() {
            _remainingTime -= Duration(seconds: 1);
          });
        }
      });
    }
  }

  void onTimeExpired() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Time's up!"),
        content: Text(
            "The allowed time has expired. Your exam will be submitted automatically."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _calculateScore();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _getExamContent() async {
    ExamFull ef = await Provider.of<ExamProvider>(context, listen: false)
        .getExamContent(examId: widget.examId);
    Provider.of<ExamProvider>(context, listen: false).examInProgress = true;
    setState(() {
      _ef = ef;
      _buildAllSectionQuestions();
      _buildExamDetails();
      _startTimer();
    });
  }

  void _buildExamDetails() {
    _estimatedTime = _ef.examEstimatedCompletionTime;
    _passMark = _ef.examPassMark;
    print('Time: $_estimatedTime  Mark: $_passMark');
  }

  void _buildAllSectionQuestions() {
    int counter = 0;
    _ef.examSections?.forEach((section) {
      print(section.sectionId);
      List<Question> sectionQuestions =
          _buildSectionQuestions(sectionElements: section.sectionElements!);
      counter += sectionQuestions.length;
      _sectionQuestionCounter[section.sectionId] =
          counter - sectionQuestions.length;
      _sectionQuestionsMap[section.sectionId] = sectionQuestions;
    });
  }

  List<Question> _buildSectionQuestions(
      {required List<ExamElement.Element> sectionElements}) {
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

  Map<String, List<String>> _getCorrectAnswersMap(List<Question> questions) {
    for (Question question in questions) {
      List<String> correctIds = question.questionAnswers
          .where((answer) => answer.answerCorrect)
          .map((answer) => answer.answerId)
          .toList();
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
        if (correctSet.difference(userSet).isEmpty &&
            userSet.difference(correctSet).isEmpty) {
          score += 1;
        }
      }
    });
    _endTime = DateTime.now(); // Record end time
    _score = score;
    Provider.of<ExamProvider>(context, listen: false).examInProgress = false;
    isExamCompleted = true;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Score"),
              content: Text(
                  "Your total score is: $score out of ${_questions.length}"),
              actions: [
                TextButton(
                    onPressed: () {
                      _storeExamAttemptResult();
                      Navigator.of(context).pop();
                      Navigator.pop(context, isExamCompleted);

                      // context.goNamed(NamedRoutes.assignments.name);
                    },
                    child: Text("OK"))
              ],
            ));
  }

  void _storeExamAttemptResult() {
    _CSRF_TOKEN =
        Provider.of<CsrfTokenProvider>(context, listen: false).csrfToken;
    _JWT = Provider.of<CsrfTokenProvider>(context, listen: false).jwt;

    Provider.of<ExamProvider>(context, listen: false).insertUserExamAttempt(
      CSRFToken: _CSRF_TOKEN,
      JWT: _JWT,
      uid: _loggedInUserUid,
      courseId: _ef.courseId,
      examId: widget.examId,
      examVersion: _ef.examVersion,
      // passed: _score >= _passMark ? true : false,
      // score: _score,
      passed: true,
      score: 80,
      startTime: _startTime!,
      endTime: _endTime!,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      // appBar: IsmsAppBar(context: context),
      // drawer: IsmsDrawer(context: context),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.height * 0.2,
          vertical: 0,
        ),
        child: (_ef != null)
            ? _ef.examSections != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        SizedBox(
                          height: 20,
                        ),
                        buildExamHeader(),
                        SizedBox(
                          height: 20,
                        ),
                        _ef.examSections!.length != 0
                            ? Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                // width: MediaQuery.of(context).size.width * 0.8,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _ef.examSections!.length,
                                    itemBuilder: (context, index) {
                                      // int currentSectionStartIndex = _questionCounter;

                                      if (_ef.examSections![index]
                                              .sectionElements !=
                                          null) {
                                        return ExamQuestionsSection(
                                          questions: _sectionQuestionsMap[_ef
                                              .examSections![index].sectionId],
                                          userResponses: _userResponses,
                                          startIndex: _sectionQuestionCounter[
                                                  _ef.examSections![index]
                                                      .sectionId] ??
                                              0,
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

  Widget buildExamHeader() {
    return Row(
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
              style: TextStyle(
                  color: ThemeConfig.tertiaryTextColor1, fontSize: 16),
            ),
          ],
        ),
        Spacer(),
        Column(
          children: [
            Text(
              'Time remaining:',
              style:
                  TextStyle(fontSize: 16, color: ThemeConfig.primaryTextColor),
            ),
            SizedBox(
              height: 10,
            ),
            SimpleCircularProgressBar(
              backColor: ThemeConfig.percentageIconBackgroundFillColor!,
              progressStrokeWidth: 10,
              backStrokeWidth: 8,
              size: 80,
              animationDuration: _durationInSeconds,
              fullProgressColor: Colors.red,
              progressColors: [
                ThemeConfig.getPrimaryColorShade(400)!,
                ThemeConfig.primaryColor!,
                Colors.red
              ],
              mergeMode: true,
              onGetText: (double value) {
                return Text(
                  '${formatDuration(_remainingTime)} ',
                  style: TextStyle(
                    color: ThemeConfig.primaryColor,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _calculateScore(),
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13),
                  child: Text(
                    'Save and Submit',
                    style: TextStyle(color: ThemeConfig.secondaryTextColor),
                  )),
              style: ThemeConfig.elevatedRoundedButtonStyle,
            ),
          ],
        ),
      ],
    );
  }
}
