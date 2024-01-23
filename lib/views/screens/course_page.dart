import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/element.dart' as element_model;
import 'package:isms/models/course/flip_card.dart' as flip_card_model;
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/section.dart';
import 'package:isms/views/widgets/course_widgets/checkbox_list.dart';
import 'package:isms/views/widgets/course_widgets/flip_card.dart';
import 'package:isms/views/widgets/course_widgets/radio_list.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CourseState();
}

class _CourseState extends State<CoursePage> {
  /// SizedBox for adding consistent spacing between widgets
  static const SizedBox _separator = SizedBox(height: 20);

  // Data structures containing course content populated in initState() then not changed

  /// Course data represented as a JSON [String]
  final String _jsonString =
      '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 3","flipCardBack": "Back 3"}]}]}]}';

  /// Course data stored in custom [Course] object
  late final Course _course;

  /// Ordered [List] of section IDs to allow lookup by section index
  final List<String> _courseSections = [];

  /// [Map] of widgets for all course sections keyed by section ID
  final Map<String, dynamic> _courseWidgets = {};

  /// Map of each section's widgets which need to be interacted with before proceeding to the next section
  /// The [Map] is keyed on section IDs, with each [Set] containing the element IDs
  final Map<String, Set<String>> _courseRequiredInteractiveElements = {};

  // Data structures tracking current section state

  int _currentSectionIndex = 0;
  bool _currentSectionCompleted = false;

  /// [Set] of completed section IDs
  final Set<String> _completedSections = {};

  /// [Set] of interactive widget IDs which have been interacted with
  final Set<String> _currentSectionCompletedInteractiveElements = {};

  /// [Set] of question widget IDs which have (an) answer(s) selected
  final Set<String> _currentSectionNonEmptyQuestions = {};

  @override
  void initState() {
    super.initState();

    // Read course data JSON then create Course object
    final Map<String, dynamic> courseMap = jsonDecode(_jsonString) as Map<String, dynamic>;
    _course = Course.fromJson(courseMap);

    // Initialise data structures which store all course section IDs as well as widgets requiring user interaction
    for (Section section in _course.courseSections) {
      _courseSections.add(section.sectionId);

      _courseRequiredInteractiveElements[section.sectionId] = {};
      for (element_model.Element element in section.sectionElements) {
        if (element.elementType == ElementTypeValues.question.name) {
          for (Question question in element.elementContent) {
            _courseRequiredInteractiveElements[section.sectionId]?.add(question.questionId);
          }
        } else if (element.elementType == ElementTypeValues.flipCard.name) {
          for (flip_card_model.FlipCard flipCard in element.elementContent) {
            _courseRequiredInteractiveElements[section.sectionId]?.add(flipCard.flipCardId);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_course.courseTitle} - ${_course.courseSections[_currentSectionIndex].sectionTitle}"),
      ),
      // drawer: const SidebarWidget(),
      // drawerScrimColor: Colors.transparent,
      // body: SingleChildScrollView(
      body: Column(
        children: [..._getSectionWidgets()],
      ),
      // ),
    );
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets in the current course section.
  List<Widget> _getSectionWidgets() {
    _getCourseWidgets();
    print(_courseWidgets[_course.courseSections[_currentSectionIndex].sectionId].toString());
    return _courseWidgets[_course.courseSections[_currentSectionIndex].sectionId];
  }

  /// Populates data structure [_courseWidgets] with all course widgets.
  void _getCourseWidgets() {
    for (Section section in _course.courseSections) {
      _courseWidgets[section.sectionId] = _getSectionContent(_course.courseSections[_currentSectionIndex]);
    }
  }

  /// Returns an ordered [List] of widgets for a course section.
  /// Widgets are created based on their defined type in the custom [element_model.Element] object,
  /// with data being passed in as required for each.
  List<Widget> _getSectionContent(Section currentSection) {
    final List<Widget> contentWidgets = [];

    // Add widgets for all elements in the current course section, conditionally building different widget types
    // depending on `elementType` from the JSON
    for (element_model.Element element in currentSection.sectionElements) {
      contentWidgets.add(_separator);

      // Static HTML
      if (element.elementType == ElementTypeValues.html.name) {
        contentWidgets.add(Flexible(child: Html(data: element.elementContent)));

        // Questions
      } else if (element.elementType == ElementTypeValues.question.name) {
        for (Question question in element.elementContent) {
          contentWidgets.addAll(_getQuestionWidgets(question));
        }

        // FlipCards
      } else if (element.elementType == ElementTypeValues.flipCard.name) {
        final List<CustomFlipCard> flipCardWidgets = [];

        for (flip_card_model.FlipCard flipCard in element.elementContent) {
          flipCardWidgets.add(_getFlipCardWidget(flipCard));
        }
        contentWidgets.addAll([
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            runSpacing: 10.0,
            children: flipCardWidgets,
          ),
        ]);
      }
    }

    contentWidgets.addAll([_separator, _getSectionEndButton()]);

    // Add a previous section button (and preceding spacing) to the beginning of the widget [List]
    // only for sections after the first section
    if (_currentSectionIndex > 0) {
      contentWidgets.insertAll(0, [_separator, _getSectionBeginningButton()]);
    }

    return contentWidgets;
  }

  // Functions returning widget(s) for each type

  /// Returns a [List] of widgets comprising each question type.
  List<Widget> _getQuestionWidgets(Question question) {
    final List<Widget> contentWidgets = [];

    // Single Selection Question (Radio buttons)
    if (question.questionType == QuestionTypeValues.singleSelectionQuestion.name) {
      contentWidgets.addAll([
        Text(question.questionText),
        _separator,
        CustomRadioList(
          values: question.questionAnswers,
          onItemSelected: (selectedValue) {
            setState(() {
              // Only enable the related button once an answer has been selected
              // Radio buttons cannot be deselected so there's no need to disable the button again
              _currentSectionNonEmptyQuestions.add(question.questionId);
            });
          },
        ),
        _separator,
        _currentSectionNonEmptyQuestions.contains(question.questionId)
            ? ElevatedButton(
                onPressed: () {
                  // No need to track interactive UI element completion if revisiting the section
                  if (!_currentSectionCompleted) {
                    _currentSectionCompletedInteractiveElements.add(question.questionId);
                    _checkInteractiveElementsCompleted();
                  }
                },
                child: Text(AppLocalizations.of(context)!.buttonCheckAnswer),
              )
            : ElevatedButton(
                onPressed: null,
                child: Text(AppLocalizations.of(context)!.buttonSelectAnswer),
              )
      ]);

      // Multiple Selection Question (Checkboxes)
    } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {
      contentWidgets.addAll([
        Text(question.questionText),
        _separator,
        CustomCheckboxList(
          values: question.questionAnswers,
          onItemSelected: (selectedValues) {
            setState(() {
              // Only enable the related button once at least one answer has been selected
              // Since checkboxes can be deselected, we also need to disable the button if all options are
              // subsequently deselected
              if (selectedValues.values.contains(true)) {
                _currentSectionNonEmptyQuestions.add(question.questionId);
              } else {
                _currentSectionNonEmptyQuestions.remove(question.questionId);
              }
            });
          },
        ),
        _separator,
        _currentSectionNonEmptyQuestions.contains(question.questionId)
            ? ElevatedButton(
                onPressed: () {
                  // No need to track interactive UI element completion if revisiting the section
                  if (!_currentSectionCompleted) {
                    _currentSectionCompletedInteractiveElements.add(question.questionId);
                    _checkInteractiveElementsCompleted();
                  }
                },
                child: Text(AppLocalizations.of(context)!.buttonCheckAnswer),
              )
            : ElevatedButton(
                onPressed: null,
                child: Text(AppLocalizations.of(context)!.buttonSelectAnswer),
              )
      ]);
    }

    return contentWidgets;
  }

  /// Returns a [CustomFlipCard] widget.
  CustomFlipCard _getFlipCardWidget(flip_card_model.FlipCard flipCard) {
    return CustomFlipCard(
      content: flipCard,
      onCardFlipped: (flippedCardId) {
        setState(() {
          // No need to track interactive UI element completion if revisiting the section
          if (!_currentSectionCompleted) {
            _currentSectionCompletedInteractiveElements.add(flippedCardId);
            _checkInteractiveElementsCompleted();
          }
        });
      },
    );
  }

  /// Returns an [ElevatedButton] widget used for end-of-section operations:
  ///  - Proceeding to the next section
  ///  - Completing the course and returning to the course list screen
  ElevatedButton _getSectionEndButton() {
    late ElevatedButton button;
    // We need to determine whether the current section is the final one or not
    // to only display the "Finish Course" button at the very bottom of the course
    if (_currentSectionIndex == _course.courseSections.length - 1) {
      // Only enable the button once all interactive elements in the section have been interacted with
      button = _currentSectionCompleted
          ? ElevatedButton(
              onPressed: () {
                _recordCourseCompletion;
                // Return to parent screen (course list)
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.buttonFinishCourse),
            )
          : ElevatedButton(
              onPressed: null,
              child: Text(AppLocalizations.of(context)!.buttonSectionContentIncomplete),
            );
    } else {
      // Only enable the button once all interactive elements in the section have been interacted with
      button = _currentSectionCompleted
          ? ElevatedButton(
              onPressed: _goToNextSection,
              child: Text(AppLocalizations.of(context)!
                  .buttonNextSection(_course.courseSections[_currentSectionIndex + 1].sectionTitle)),
            )
          : ElevatedButton(
              onPressed: null,
              child: Text(AppLocalizations.of(context)!.buttonSectionContentIncomplete),
            );
    }

    return button;
  }

  /// Returns an [ElevatedButton] widget used for returning to the previous section.
  ElevatedButton _getSectionBeginningButton() {
    return ElevatedButton(
      onPressed: _goToPreviousSection,
      child: Text(AppLocalizations.of(context)!
          .buttonPreviousSection(_course.courseSections[_currentSectionIndex - 1].sectionTitle)),
    );
  }

  // Functions for Button onPressed events

  /// Updates [_currentSectionCompleted] to `true` only if all widgets requiring user interaction
  /// in the current section have been interacted with.
  void _checkInteractiveElementsCompleted() {
    if (setEquals(_courseRequiredInteractiveElements[_courseSections[_currentSectionIndex]],
        _currentSectionCompletedInteractiveElements)) {
      setState(() {
        _currentSectionCompleted = true;
      });
    }
  }

  /// Updates variables and data structures which track progress/state of the overall course:
  ///  - [_completedSections]
  ///  - [_currentSectionIndex]
  ///
  /// As well as individual sections:
  ///  - [_currentSectionCompleted]
  ///  - [_currentSectionCompletedInteractiveElements]
  ///  - [_currentSectionNonEmptyQuestions]
  void _goToNextSection() {
    setState(() {
      // Update section progress
      _completedSections.add(_course.courseSections[_currentSectionIndex].sectionId);
      _currentSectionIndex++;

      // Reset current section interactive UI element tracking
      _currentSectionCompleted = false;
      _currentSectionCompletedInteractiveElements.clear();
      _currentSectionNonEmptyQuestions.clear();
    });
  }

  /// Decrements [_currentSectionIndex], while also overriding [_currentSectionCompleted]
  /// to not require widget interaction by the user before being allowed to proceed to the next section again.
  void _goToPreviousSection() {
    setState(() {
      _currentSectionIndex--;
      // Override current section interactive UI element tracking as section has already been completed
      _currentSectionCompleted = true;
    });
  }

  /// Add the final section to [_completedSections].
  void _recordCourseCompletion() {
    setState(() {
      _completedSections.add(_course.courseSections[_currentSectionIndex].sectionId);
    });
  }
}
