import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/exam_management/question_response_manager.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/user_question_response.dart';
import 'package:isms/views/widgets/shared_widgets/build_secondary_header.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';

import '../../../models/course/answer.dart';

class ExamQuestionsSection extends StatefulWidget {
  ExamQuestionsSection({
    super.key,
    required this.questions,
    required this.userResponses,
    this.startIndex,
  });

  final List<Question> questions;
  Map<String, List<String>> userResponses = {};
  int? startIndex = 0;

  @override
  State<ExamQuestionsSection> createState() => _ExamQuestionsSectionState();
}

class _ExamQuestionsSectionState extends State<ExamQuestionsSection> {
  @override
  void initState() {
    super.initState();
  }

  Map<String, List<String>> getCorrectAnswersMap(List<Question> questions) {
    Map<String, List<String>> correctAnswersMap = {};
    for (Question question in questions) {
      List<String> correctIds =
          question.questionAnswers.where((answer) => answer.answerCorrect).map((answer) => answer.answerId).toList();
      correctAnswersMap[question.questionId] = correctIds;
    }
    return correctAnswersMap;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.questions.length,
      itemBuilder: (context, index) {
        Question question = widget.questions[index];
        int questionNumber = widget.startIndex! + index + 1; // Compute the question number

        return Column(
          children: [
            HoverableSectionContainer(
              onHover: (bool) {},
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "$questionNumber. ${question.questionText}",
                    style: TextStyle(
                      color: ThemeConfig.tertiaryTextColor1,
                      fontSize: 16,
                    ),
                  ),
                ),
                ...question.questionAnswers.map((Answer answer) {
                  bool isSelected = widget.userResponses[question.questionId]?.contains(answer.answerId) ?? false;

                  // Check if the question is of type 'singleSelection' for Radio buttons
                  if (question.questionType == 'singleSelectionQuestion') {
                    return Theme(
                      data: ThemeData(
                        unselectedWidgetColor: ThemeConfig.tertiaryTextColor1, // Color for the radio when not selected
                      ),
                      child: RadioListTile<String>(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          answer.answerText,
                          style: TextStyle(
                            color: ThemeConfig.primaryTextColor,
                          ),
                        ),
                        value: answer.answerId,
                        groupValue: widget.userResponses[question.questionId]?.isNotEmpty == true
                            ? widget.userResponses[question.questionId]!.first
                            : '',
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              // Clear existing and add the new one for single-select
                              widget.userResponses[question.questionId] = [value];
                              print(widget.userResponses);
                            });
                          }
                        },
                      ),
                    );
                  } else {
                    // Use CheckboxListTile for 'multipleSelection'
                    return Theme(
                      data: ThemeData(
                        unselectedWidgetColor: ThemeConfig.tertiaryTextColor1, // Color for the radio when not selected
                      ),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          answer.answerText,
                          style: TextStyle(
                            color: ThemeConfig.primaryTextColor,
                          ),
                        ),
                        value: isSelected,
                        onChanged: (bool? checked) {
                          setState(() {
                            widget.userResponses[question.questionId] ??= [];
                            if (checked == true) {
                              // Add answer ID to the list if checked
                              if (!widget.userResponses[question.questionId]!.contains(answer.answerId)) {
                                widget.userResponses[question.questionId]!.add(answer.answerId);
                              }
                            } else {
                              // Remove answer ID from the list if unchecked
                              widget.userResponses[question.questionId]!.remove(answer.answerId);
                            }
                            print(widget.userResponses);
                          });
                        },
                      ),
                    );
                  }
                }).toList(),
              ]),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
