import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/answer.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/element.dart' as course_element;
import 'package:isms/models/course/flipcard.dart';
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/section.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final TextStyle _buttonEnabledStyle = const TextStyle(fontSize: 20, color: Colors.white);
  final TextStyle _buttonDisabledStyle = const TextStyle(fontSize: 20, color: Colors.red);
  final String _jsonString = '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  late final Course course;
  final Set<String> _completedSections = {};
  final Set<String> _interactedSections = {};
  int _currentSectionIndex = 0;
  late String _currentSectionId;
  late final Map<String,Set<String>> _completedInteractiveElements;
  late Answer _selectedAnswer;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> courseMap = jsonDecode(_jsonString) as Map<String, dynamic>;
    course = Course.fromJson(courseMap);
    _completedInteractiveElements = _initCompletedInteractiveElements();
  }

  List<Widget> getContentWidgets() {
    final List<Widget> contentWidgets = [];

    for (_currentSectionIndex = 0; _currentSectionIndex < course.courseSections.length; _currentSectionIndex++) {
      Section currentSection = course.courseSections[_currentSectionIndex];

      // Iterate through all course sections until we reach one which hasn't been completed
      if (!_completedSections.contains(currentSection.sectionId)) {
        _currentSectionId = currentSection.sectionId;

        // Add widgets for all elements in the current course section, conditionally building
        // different widget types depending on `elementType` from the JSON.
        for (course_element.Element element in currentSection.sectionElements) {

          // Static HTML
          if (element.elementType == ElementTypeValues.html.name) {
            contentWidgets.add(Html(data: element.elementContent));
            contentWidgets.add(const SizedBox(height: 10)); // Adjusted size for less spacing

          // Questions
          } else if (element.elementType == ElementTypeValues.question.name) {
            for (Question question in element.elementContent) {

              // Single Selection Question (Radio buttons)
              if (question.questionType == QuestionTypeValues.singleSelectionQuestion.name) {
                contentWidgets.addAll([
                  Text(question.questionText),
                  CustomRadioView(
                    values: question.questionAnswers,
                    onItemSelected: (selectedValue) {
                      print(selectedValue.toString());
                      setState(() {
                        _selectedAnswer = selectedValue;
                        // Only enable the related button once an option has been selected.
                        // Radio buttons cannot be deselected so there's no need to disable the button again.
                        _completedInteractiveElements[_currentSectionId]?.add(element.elementId);
                      });
                      print(_completedInteractiveElements[_currentSectionId].toString());
                    },
                  ),
                  _completedInteractiveElements[_currentSectionId]!.contains(element.elementId)
                      ? ElevatedButton(
                          onPressed: _submitAnswer,
                          child: Text(
                              'Check answer',
                              style: _buttonEnabledStyle
                          ),
                        )
                      : ElevatedButton(
                          onPressed: null,
                          child: Text(
                              'Select answer',
                              style: _buttonDisabledStyle
                          ),
                        )
                ]);

              // Multiple Selection Question (Checkboxes)
              } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {
                contentWidgets.addAll([
                  Text(question.questionText),
                  CustomCheckboxView(
                    values: question.questionAnswers,
                    onItemSelected: (selectedValues) {
                      print(selectedValues.toString());
                      setState(() {
                        // _selectedAnswer = selectedValues;
                        // Only enable the related button once at least one option has been selected.
                        // As checkboxes can be deselected, we also need to disable the button if all
                        // options are subsequently deselected.
                        if (selectedValues.values.contains(true)) {
                          _completedInteractiveElements[_currentSectionId]?.add(element.elementId);
                        } else {
                          _completedInteractiveElements[_currentSectionId]?.remove(element.elementId);
                        }
                      });
                      print(_completedInteractiveElements[_currentSectionId].toString());
                    },
                  ),
                  _completedInteractiveElements[_currentSectionId]!.contains(element.elementId)
                      ? ElevatedButton(
                    onPressed: _submitAnswer,
                    child: Text(
                        'Check answer',
                        style: _buttonEnabledStyle
                    ),
                  )
                      : ElevatedButton(
                    onPressed: null,
                    child: Text(
                        'Select answer',
                        style: _buttonDisabledStyle
                    ),
                  )
                ]);
              }
            }

          // FlipCards
          } else if (element.elementType == ElementTypeValues.flipCard.name) {
            final List<FlipCardWidget> flipCards = [];

            for (FlipCard flipCard in element.elementContent) {
              flipCards.add(
                  FlipCardWidget(
                      content: flipCard,
                      onItemSelected: (selectedCard) {
                        print(selectedCard.toString());
                        setState(() {
                          _completedInteractiveElements[_currentSectionId]?.add(selectedCard);
                        });
                        print(_completedInteractiveElements[_currentSectionId].toString());
                    },
                  )
              );
            }
            contentWidgets.addAll([
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10.0,
                runSpacing: 10.0,
                children: flipCards,
              ),
              const SizedBox(height: 20),
            ]);
          }
        }

        // We need to determine whether the current section is the final one or not
        // to only display the "Finish Course" button at the very bottom of the course.
        if (_currentSectionIndex == course.courseSections.length - 1) {
          // Only enable the button once all interactive elements in the section have been interacted with.
          contentWidgets.add(_interactedSections.contains(_currentSectionId)
              ? ElevatedButton(
                  onPressed: _completeCourse,
                  child: Text(
                      'Finish course and return to course list',
                      style: _buttonEnabledStyle
                  ),
                )
              : ElevatedButton(
                  onPressed: null,
                  child: Text(
                      'Complete all section content to proceed',
                      style: _buttonDisabledStyle
                  ),
                )
          );
        } else {
          // Only enable the button once all interactive elements in the section have been interacted with.
          contentWidgets.add(_interactedSections.contains(_currentSectionId)
              ? ElevatedButton(
                  onPressed: _goToNextSection,
                  child: Text(
                      'Proceed to next section: ${course.courseSections[_currentSectionIndex + 1].sectionTitle}',
                      style: _buttonEnabledStyle
                  ),
                )
              : ElevatedButton(
                  onPressed: null,
                  child: Text(
                      'Complete all section content to proceed',
                      style: _buttonDisabledStyle
                  ),
                )
          );
        }

        // We only want to display one section at a time, so after populating `contentWidgets`
        // with all of the current section's elements we break out of the loop.
        break;
      }
    }

    return contentWidgets;
  }

  Map<String,Set<String>> _initCompletedInteractiveElements() {
    final Map<String,Set<String>> requiredSections = {};

    for (Section section in course.courseSections) {
      requiredSections[section.sectionId] = {};
    }

    return requiredSections;
  }

  void _submitAnswer() {
    final List<course_element.Element> currentSectionElements = course.courseSections[_currentSectionIndex].sectionElements;
    final Set<String> requiredInteractiveElements = {};
    for (course_element.Element element in currentSectionElements) {
      if ((element.elementType == ElementTypeValues.question.name) || (element.elementType == ElementTypeValues.flipCard.name)) {
        requiredInteractiveElements.add(element.elementId);
      }
    }

    //
    if (setEquals(requiredInteractiveElements, _completedInteractiveElements[_currentSectionId])) {
      setState(() {
        _interactedSections.add(_currentSectionId);
      });
    }
  }

  void _goToNextSection() {
    setState(() {
      _completedSections.add(_currentSectionId);
    });
  }

  void _completeCourse() {
    setState(() {
      _completedSections.add(_currentSectionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      //drawer: const SidebarWidget(),
      drawerScrimColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...getContentWidgets()
          ],
        ),
      ),
    );
  }
}

class FlipCardWidget extends StatefulWidget {
    const FlipCardWidget(
      {Key? key,
        required this.content,
        required this.onItemSelected})
      : super(key: key);

  final FlipCard content;
  final dynamic Function(dynamic selectedValue) onItemSelected;

  @override
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_controller.isCompleted) {
            _controller.reverse();
          } else {
            _controller.forward();
          }
          widget.onItemSelected(widget.content.flipCardId);
        });
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(_controller.value * 3.14),
            child: _controller.value <= 0.5
                ? Container(
              width: 300,
              height: 200,
              color: Colors.deepPurpleAccent.shade100,
              alignment: Alignment.center,
              child: Text(widget.content.flipCardFront, style: const TextStyle(fontSize: 20, color: Colors.white)),
            )
                : Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(3.14),
              child: Container(
                width: 300,
                height: 200,
                color: Colors.grey[300],
                alignment: Alignment.center,
                child: Text(widget.content.flipCardBack, style: const TextStyle(fontSize: 20, color: Colors.black)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomRadioView extends StatefulWidget {
  const CustomRadioView(
      {Key? key,
        required this.values,
        required this.onItemSelected})
      : super(key: key);

  final List<Answer> values;
  final dynamic Function(dynamic selectedValue) onItemSelected;

  @override
  _CustomRadioViewState createState() => _CustomRadioViewState();
}

class _CustomRadioViewState extends State<CustomRadioView> {
  dynamic _groupNewValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildList(context),
      ),
    );
  }

  buildList(BuildContext context) {
    List<Widget> radioButtons = [];
    for (Answer answer in widget.values) {
      radioButtons.add(
        Expanded(
          flex: 1,
          child: RadioListTile<Answer>(
            title: Text(answer.answerText),
            value: answer,
            groupValue: _groupNewValue,
            onChanged: (selectedValue) {
              setState(() {
                _groupNewValue = selectedValue;
              });
              widget.onItemSelected(selectedValue);
            },
            selected: _groupNewValue == answer,
          ),
        ),
      );
    }

    return radioButtons;
  }
}

class CustomCheckboxView extends StatefulWidget {
  const CustomCheckboxView(
      {Key? key,
        required this.values,
        required this.onItemSelected})
      : super(key: key);

  final List<Answer> values;
  final dynamic Function(dynamic selectedValues) onItemSelected;

  @override
  _CustomCheckboxViewState createState() => _CustomCheckboxViewState();
}

class _CustomCheckboxViewState extends State<CustomCheckboxView> {
  late Map<String,bool> _checkboxAnswerState;

  @override
  void initState() {
    super.initState();
    _checkboxAnswerState = _initCheckboxStateTracking();
  }

  Map<String,bool> _initCheckboxStateTracking() {
    final Map<String,bool> answers = {};

    for (Answer value in widget.values) {
      answers[value.answerId] = false;
    }

    return answers;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: buildList(context),
      ),
    );
  }

  buildList(BuildContext context) {
    List<Widget> checkboxes = [];
    for (Answer answer in widget.values) {
      checkboxes.add(
        Expanded(
          flex: 1,
          child: CheckboxListTile(
            title: Text(answer.answerText),
            value: _checkboxAnswerState[answer.answerId],
            onChanged: (selectedValue) {
              setState(() {
                _checkboxAnswerState[answer.answerId] = selectedValue ?? false;
              });
              widget.onItemSelected(_checkboxAnswerState);
            },
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      );
    }

    return checkboxes;
  }
}