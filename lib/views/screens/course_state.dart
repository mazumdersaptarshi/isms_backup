import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/element.dart' as element_model;
import 'package:isms/models/course/flip_card.dart' as flip_card_model;
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/section.dart';
import 'package:isms/views/widgets/course_widgets/checkbox_list.dart';
import 'package:isms/views/widgets/course_widgets/flip_card.dart'  as flip_card_widget;
import 'package:isms/views/widgets/course_widgets/radio_list.dart';

class CourseState extends ChangeNotifier {
  static const labelButtonCheckAnswer = 'Check answer';
  static const labelButtonSelectAnswer = 'Select answer';
  static const labelButtonSectionContentIncomplete = 'Complete all section content to proceed';
  static const labelButtonFinishCourse = 'Finish course and return to course list';
  static const labelButtonNextSection = 'Proceed to next section: ';
  static const labelButtonPreviousSection = 'Back to previous section: ';
  final TextStyle buttonEnabledStyle = const TextStyle(fontSize: 20, color: Colors.white);
  final TextStyle buttonDisabledStyle = const TextStyle(fontSize: 20, color: Colors.red);

  final String _jsonString = '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  late final Course _course;
  final List<List<Widget>> _courseWidgets = [];
  int _currentSectionIndex = 0;
  int _highestCompletedSectionIndex = 0;
  bool _currentSectionCompleted = false;
  final Set<String> _completedSections = {};
  final Set<String> _currentSectionRequiredInteractiveElements = {};
  final Set<String> _currentSectionCompletedInteractiveElements = {};
  final Set<String> _currentSectionNonEmptyQuestions = {};

  CourseState() {
    final Map<String, dynamic> courseMap = jsonDecode(_jsonString) as Map<String, dynamic>;
    _course = Course.fromJson(courseMap);
    for (Section section in _course.courseSections) {
      addSectionWidgets(_getSectionContent(section));
    }
  }

  Course getCourse() {
    return _course;
  }

  void addCompletedSections(String sectionId) {
    _completedSections.add(sectionId);
    notifyListeners();
  }

  void clearCompletedSections() {
    _completedSections.clear();
    notifyListeners();
  }

  Set<String> getCompletedSections() {
    return _completedSections;
  }

  List<Widget> getSectionWidgetsByIndex(int index) {
    return _courseWidgets[index];
  }

  void addSectionWidgets(List<Widget> widgets) {
    _courseWidgets.add(widgets);
    notifyListeners();
  }

  void decrementCurrentSectionIndex() {
    _currentSectionIndex--;
    notifyListeners();
  }

  void incrementCurrentSectionIndex() {
    _currentSectionIndex++;
    notifyListeners();
  }

  int getCurrentSectionIndex() {
    return _currentSectionIndex;
  }

  void incrementHighestCompletedSectionIndex() {
    _highestCompletedSectionIndex++;
    notifyListeners();
  }

  int getHighestCompletedSectionIndex() {
    return _highestCompletedSectionIndex;
  }

  void setCurrentSectionCompleted(bool state) {
    _currentSectionCompleted = state;
    notifyListeners();
  }

  bool getCurrentSectionCompleted() {
    return _currentSectionCompleted;
  }

  void addCurrentSectionRequiredInteractiveElements(String elementId) {
    _currentSectionRequiredInteractiveElements.add(elementId);
    notifyListeners();
  }

  void clearCurrentSectionRequiredInteractiveElements() {
    _currentSectionRequiredInteractiveElements.clear();
    notifyListeners();
  }

  Set<String> getCurrentSectionRequiredInteractiveElements() {
    return _currentSectionRequiredInteractiveElements;
  }

  void addCurrentSectionCompletedInteractiveElements(String elementId) {
    _currentSectionCompletedInteractiveElements.add(elementId);
    notifyListeners();
  }

  void clearCurrentSectionCompletedInteractiveElements() {
    _currentSectionCompletedInteractiveElements.clear();
    notifyListeners();
  }

  Set<String> getCurrentSectionCompletedInteractiveElements() {
    return _currentSectionCompletedInteractiveElements;
  }

  void addCurrentSectionNonEmptyQuestions(String questionId) {
    _currentSectionNonEmptyQuestions.add(questionId);
    notifyListeners();
  }

  void clearCurrentSectionNonEmptyQuestions() {
    _currentSectionNonEmptyQuestions.clear();
    notifyListeners();
  }

  Set<String> getCurrentSectionNonEmptyQuestions() {
    return _currentSectionNonEmptyQuestions;
  }

  void removeCurrentSectionNonEmptyQuestions(String questionId) {
    _currentSectionNonEmptyQuestions.remove(questionId);
    notifyListeners();
  }

  List<Widget> _getSectionContent(Section currentSection) {
    final List<Widget> contentWidgets = [];

    // Add widgets for all elements in the current course section, conditionally building
    // different widget types depending on `elementType` from the JSON.
    for (element_model.Element element in currentSection.sectionElements) {

      // Static HTML
      if (element.elementType == ElementTypeValues.html.name) {
        contentWidgets.add(Flexible(child: Html(data: element.elementContent)));
        // contentWidgets.add(const SizedBox(height: 10)); // Adjusted size for less spacing

        // Questions
      } else if (element.elementType == ElementTypeValues.question.name) {
        for (Question question in element.elementContent) {
          // No need to track interactive UI element completion if revisiting the section
          if (!getCurrentSectionCompleted()) {
            addCurrentSectionRequiredInteractiveElements(question.questionId);
          }

          contentWidgets.addAll(_getQuestionWidgets(question));
        }

        // FlipCards
      } else if (element.elementType == ElementTypeValues.flipCard.name) {
        final List<flip_card_widget.FlipCard> flipCardWidgets = [];

        for (flip_card_model.FlipCard flipCard in element.elementContent) {
          // No need to track interactive UI element completion if revisiting the section
          if (!getCurrentSectionCompleted()) {
            addCurrentSectionRequiredInteractiveElements(flipCard.flipCardId);
          }
          flipCardWidgets.add(_getFlipCardWidget(flipCard));
        }
        contentWidgets.addAll([
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10.0,
            runSpacing: 10.0,
            children: flipCardWidgets,
          ),
          const SizedBox(height: 20),
        ]);
      }
    }

    contentWidgets.add(_getSectionEndButton());

    // Don't add a previous section button for the first section
    if (getCurrentSectionIndex() > 0) {
      contentWidgets.insert(0, _getSectionBeginningButton());
    }

    return contentWidgets;
  }

  List<Widget> _getQuestionWidgets(Question question) {
    final List<Widget> contentWidgets = [];

    // Single Selection Question (Radio buttons)
    if (question.questionType == QuestionTypeValues.singleSelectionQuestion.name) {
      contentWidgets.addAll([
        Text(question.questionText),
        RadioList(
          values: question.questionAnswers,
          onItemSelected: (selectedValue) {
            print('selected: $selectedValue');
            // Only enable the related button once an option has been selected.
            // Radio buttons cannot be deselected so there's no need to disable the button again.
            addCurrentSectionNonEmptyQuestions(question.questionId);
            print('required: ${getCurrentSectionRequiredInteractiveElements().toString()}');
            print('current: ${getCurrentSectionNonEmptyQuestions().toString()}');
            print('question id: ${question.questionId}');
            print(getCurrentSectionNonEmptyQuestions().contains(question.questionId));
          },
        ),
        getCurrentSectionNonEmptyQuestions().contains(question.questionId)
            ? ElevatedButton(
          onPressed: () {
            // No need to track interactive UI element completion if revisiting the section
            if (!getCurrentSectionCompleted()) {
              addCurrentSectionRequiredInteractiveElements(question.questionId);
              _checkInteractiveElementsCompleted();
            }
          },
          child: Text(
              labelButtonCheckAnswer,
              style: buttonEnabledStyle
          ),
        )
            : ElevatedButton(
          onPressed: null,
          child: Text(
              labelButtonSelectAnswer,
              style: buttonDisabledStyle
          ),
        )
      ]);

      // Multiple Selection Question (Checkboxes)
    } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {
      contentWidgets.addAll([
        Text(question.questionText),
        CheckboxList(
          values: question.questionAnswers,
          onItemSelected: (selectedValues) {
            print('selected: $selectedValues.toString()');
            // Only enable the related button once at least one option has been selected.
            // As checkboxes can be deselected, we also need to disable the button if all
            // options are subsequently deselected.
            if (selectedValues.values.contains(true)) {
              addCurrentSectionNonEmptyQuestions(question.questionId);
            } else {
              removeCurrentSectionNonEmptyQuestions(question.questionId);
            }
            print('required: ${getCurrentSectionRequiredInteractiveElements().toString()}');
            print('current: ${getCurrentSectionNonEmptyQuestions().toString()}');
          },
        ),
        getCurrentSectionNonEmptyQuestions().contains(question.questionId)
            ? ElevatedButton(
          onPressed: () {
            // No need to track interactive UI element completion if revisiting the section
            if (!getCurrentSectionCompleted()) {
              addCurrentSectionRequiredInteractiveElements(question.questionId);
              _checkInteractiveElementsCompleted();
            }
          },
          child: Text(
              labelButtonCheckAnswer,
              style: buttonEnabledStyle
          ),
        )
            : ElevatedButton(
          onPressed: null,
          child: Text(
              labelButtonSelectAnswer,
              style: buttonDisabledStyle
          ),
        )
      ]);
    }

    return contentWidgets;
  }

  flip_card_widget.FlipCard _getFlipCardWidget(flip_card_model.FlipCard flipCard) {
    return flip_card_widget.FlipCard(
      content: flipCard,
      onItemSelected: (selectedCard) {
        print(selectedCard);
        // No need to track interactive UI element completion if revisiting the section
        if (!getCurrentSectionCompleted()) {
          addCurrentSectionRequiredInteractiveElements(selectedCard);
          _checkInteractiveElementsCompleted();
        }
        print(getCurrentSectionCompletedInteractiveElements().toString());
      },
    );
  }

  ElevatedButton _getSectionEndButton() {
    late ElevatedButton button;
    // We need to determine whether the current section is the final one or not
    // to only display the "Finish Course" button at the very bottom of the course.
    if (getCurrentSectionIndex() == getCourse().courseSections.length - 1) {
      // Only enable the button once all interactive elements in the section have been interacted with.
      button = getCurrentSectionCompleted()
          ? ElevatedButton(
        onPressed: _completeCourse,
        child: Text(
            labelButtonFinishCourse,
            style: buttonEnabledStyle
        ),
      )
          : ElevatedButton(
        onPressed: null,
        child: Text(
            labelButtonSectionContentIncomplete,
            style: buttonDisabledStyle
        ),
      );
    } else {
      // Only enable the button once all interactive elements in the section have been interacted with.
      button = getCurrentSectionCompleted()
          ? ElevatedButton(
        onPressed: _goToNextSection,
        child: Text(
            '$labelButtonNextSection${getCourse().courseSections[getCurrentSectionIndex() + 1].sectionTitle}',
            style: buttonEnabledStyle
        ),
      )
          : ElevatedButton(
        onPressed: null,
        child: Text(
            labelButtonSectionContentIncomplete,
            style: buttonDisabledStyle
        ),
      );
    }

    return button;
  }

  ElevatedButton _getSectionBeginningButton() {
    return ElevatedButton(
      onPressed: _goToPreviousSection,
      child: Text(
          '$labelButtonPreviousSection${getCourse().courseSections[getCurrentSectionIndex() - 1].sectionTitle}',
          style: buttonEnabledStyle
      ),
    );
  }

  void _checkInteractiveElementsCompleted() {
    print(getCurrentSectionRequiredInteractiveElements().toString());
    print(getCurrentSectionCompletedInteractiveElements().toString());
    if (setEquals(getCurrentSectionRequiredInteractiveElements(), getCurrentSectionCompletedInteractiveElements())) {
      setCurrentSectionCompleted(true);
    }
    print(getCurrentSectionCompleted());
  }

  void _goToNextSection() {
    // Update section progress
    addCompletedSections(getCourse().courseSections[getCurrentSectionIndex()].sectionId);
    incrementHighestCompletedSectionIndex();
    incrementCurrentSectionIndex();

    // Reset current section interactive UI element tracking
    setCurrentSectionCompleted(false);
    clearCurrentSectionRequiredInteractiveElements();
    clearCurrentSectionCompletedInteractiveElements();
    clearCurrentSectionNonEmptyQuestions();
  }

  void _goToPreviousSection() {
    decrementCurrentSectionIndex();
    // Override current section interactive UI element tracking as section has already been completed
    setCurrentSectionCompleted(true);
  }

  void _completeCourse() {
    addCompletedSections(getCourse().courseSections[getCurrentSectionIndex()].sectionId);
  }
}