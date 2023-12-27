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
import 'package:isms/views/screens/course_state.dart';
import 'package:isms/views/widgets/course_widgets/checkbox_list.dart';
import 'package:isms/views/widgets/course_widgets/flip_card.dart'  as flip_card_widget;
import 'package:isms/views/widgets/course_widgets/radio_list.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: CustomScrollView(
      //     slivers: [
      //       const SliverAppBar(
      //         title: Text(''),
      //       ),
      //       SliverList(
      //           delegate: SliverChildBuilderDelegate(
      //                   (context, index) => _SectionElement(index)
      //           )
      //       )
      //     ]
      // ),
      appBar: AppBar(
        title: const Text(''),
      ),
      // drawer: const SidebarWidget(),
      // drawerScrimColor: Colors.transparent,
      // body: SingleChildScrollView(
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(itemBuilder: (context, index) => _SectionElement(index))
            ),
          ],
        ),
      // ),
    );
  }
}

// class _CoursePageState extends State<CoursePage> {
//   static const labelButtonCheckAnswer = 'Check answer';
//   static const labelButtonSelectAnswer = 'Select answer';
//   static const labelButtonSectionContentIncomplete = 'Complete all section content to proceed';
//   static const labelButtonFinishCourse = 'Finish course and return to course list';
//   static const labelButtonNextSection = 'Proceed to next section: ';
//   static const labelButtonPreviousSection = 'Back to previous section: ';
//   final TextStyle _buttonEnabledStyle = const TextStyle(fontSize: 20, color: Colors.white);
//   final TextStyle _buttonDisabledStyle = const TextStyle(fontSize: 20, color: Colors.red);
//   final String _jsonString = '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
//   late final Course _course;
//   final Map<String, dynamic> _courseWidgets = {};
//   int _currentSectionIndex = 0;
//   int _highestCompletedSectionIndex = 0;
//   bool _currentSectionCompleted = false;
//   final Set<String> _completedSections = {};
//   final Set<String> _currentSectionRequiredInteractiveElements = {};
//   final Set<String> _currentSectionCompletedInteractiveElements = {};
//   final Set<String> _currentSectionNonEmptyQuestions = {};
//
//   @override
//   void initState() {
//     super.initState();
//     final Map<String, dynamic> courseMap = jsonDecode(_jsonString) as Map<String, dynamic>;
//     _course = Course.fromJson(courseMap);
//   }
//
//   List<Widget> _getSectionWidgets() {
//     _getContentWidgets();
//     return _courseWidgets[_course.courseSections[_currentSectionIndex].sectionId];
//   }
//
//   void _getContentWidgets() {
//     for (Section section in _course.courseSections) {
//       _courseWidgets[section.sectionId] = _getSectionContent(_course.courseSections[_currentSectionIndex]);
//     }
//   }
//
//   List<Widget> _getSectionContent(Section currentSection) {
//     final List<Widget> contentWidgets = [];
//
//     // Add widgets for all elements in the current course section, conditionally building
//     // different widget types depending on `elementType` from the JSON.
//     for (element_model.Element element in currentSection.sectionElements) {
//
//       // Static HTML
//       if (element.elementType == ElementTypeValues.html.name) {
//         contentWidgets.add(Html(data: element.elementContent));
//         contentWidgets.add(const SizedBox(height: 10)); // Adjusted size for less spacing
//
//       // Questions
//       } else if (element.elementType == ElementTypeValues.question.name) {
//         for (Question question in element.elementContent) {
//           // No need to track interactive UI element completion if revisiting the section
//           if (!_currentSectionCompleted) {
//             _currentSectionRequiredInteractiveElements.add(question.questionId);
//           }
//
//           contentWidgets.addAll(_getQuestionWidgets(question));
//         }
//
//       // FlipCards
//       } else if (element.elementType == ElementTypeValues.flipCard.name) {
//         final List<flip_card_widget.FlipCard> flipCardWidgets = [];
//
//         for (flip_card_model.FlipCard flipCard in element.elementContent) {
//           // No need to track interactive UI element completion if revisiting the section
//           if (!_currentSectionCompleted) {
//             _currentSectionRequiredInteractiveElements.add(flipCard.flipCardId);
//           }
//           flipCardWidgets.add(_getFlipCardWidget(flipCard));
//         }
//         contentWidgets.addAll([
//           Wrap(
//             alignment: WrapAlignment.center,
//             spacing: 10.0,
//             runSpacing: 10.0,
//             children: flipCardWidgets,
//           ),
//           const SizedBox(height: 20),
//         ]);
//       }
//     }
//
//     contentWidgets.add(_getSectionEndButton());
//
//     // Don't add a previous section button for the first section
//     if (_currentSectionIndex > 0) {
//       contentWidgets.insert(0, _getSectionBeginningButton());
//     }
//
//     return contentWidgets;
//   }
//
//   List<Widget> _getQuestionWidgets(Question question) {
//     final List<Widget> contentWidgets = [];
//
//     // Single Selection Question (Radio buttons)
//     if (question.questionType == QuestionTypeValues.singleSelectionQuestion.name) {
//       contentWidgets.addAll([
//         Text(question.questionText),
//         RadioList(
//           values: question.questionAnswers,
//           onItemSelected: (selectedValue) {
//             print('selected: $selectedValue');
//             setState(() {
//               // Only enable the related button once an option has been selected.
//               // Radio buttons cannot be deselected so there's no need to disable the button again.
//               _currentSectionNonEmptyQuestions.add(question.questionId);
//             });
//             print('required: ${_currentSectionRequiredInteractiveElements.toString()}');
//             print('current: ${_currentSectionNonEmptyQuestions.toString()}');
//             print('question id: ${question.questionId}');
//             print(_currentSectionNonEmptyQuestions.contains(question.questionId));
//           },
//         ),
//         _currentSectionNonEmptyQuestions.contains(question.questionId)
//             ? ElevatedButton(
//           onPressed: () {
//             // No need to track interactive UI element completion if revisiting the section
//             if (!_currentSectionCompleted) {
//               _currentSectionCompletedInteractiveElements.add(question.questionId);
//               _checkInteractiveElementsCompleted();
//             }
//           },
//           child: Text(
//               labelButtonCheckAnswer,
//               style: _buttonEnabledStyle
//           ),
//         )
//             : ElevatedButton(
//           onPressed: null,
//           child: Text(
//               labelButtonSelectAnswer,
//               style: _buttonDisabledStyle
//           ),
//         )
//       ]);
//
//       // Multiple Selection Question (Checkboxes)
//     } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {
//       contentWidgets.addAll([
//         Text(question.questionText),
//         CheckboxList(
//           values: question.questionAnswers,
//           onItemSelected: (selectedValues) {
//             print('selected: $selectedValues.toString()');
//             setState(() {
//               // Only enable the related button once at least one option has been selected.
//               // As checkboxes can be deselected, we also need to disable the button if all
//               // options are subsequently deselected.
//               if (selectedValues.values.contains(true)) {
//                 _currentSectionNonEmptyQuestions.add(question.questionId);
//               } else {
//                 _currentSectionNonEmptyQuestions.remove(question.questionId);
//               }
//             });
//             print('required: ${_currentSectionRequiredInteractiveElements.toString()}');
//             print('current: ${_currentSectionNonEmptyQuestions.toString()}');
//           },
//         ),
//         _currentSectionNonEmptyQuestions.contains(question.questionId)
//             ? ElevatedButton(
//           onPressed: () {
//             // No need to track interactive UI element completion if revisiting the section
//             if (!_currentSectionCompleted) {
//               _currentSectionCompletedInteractiveElements.add(question.questionId);
//               _checkInteractiveElementsCompleted();
//             }
//           },
//           child: Text(
//               labelButtonCheckAnswer,
//               style: _buttonEnabledStyle
//           ),
//         )
//             : ElevatedButton(
//           onPressed: null,
//           child: Text(
//               labelButtonSelectAnswer,
//               style: _buttonDisabledStyle
//           ),
//         )
//       ]);
//     }
//
//     return contentWidgets;
//   }
//
//   flip_card_widget.FlipCard _getFlipCardWidget(flip_card_model.FlipCard flipCard) {
//       return flip_card_widget.FlipCard(
//         content: flipCard,
//         onItemSelected: (selectedCard) {
//           print(selectedCard);
//           setState(() {
//             // No need to track interactive UI element completion if revisiting the section
//             if (!_currentSectionCompleted) {
//               _currentSectionCompletedInteractiveElements.add(selectedCard);
//               _checkInteractiveElementsCompleted();
//             }
//           });
//           print(_currentSectionCompletedInteractiveElements.toString());
//         },
//       );
//   }
//
//   ElevatedButton _getSectionEndButton() {
//     late ElevatedButton button;
//     // We need to determine whether the current section is the final one or not
//     // to only display the "Finish Course" button at the very bottom of the course.
//     if (_currentSectionIndex == _course.courseSections.length - 1) {
//       // Only enable the button once all interactive elements in the section have been interacted with.
//       button = _currentSectionCompleted
//           ? ElevatedButton(
//         onPressed: _completeCourse,
//         child: Text(
//             labelButtonFinishCourse,
//             style: _buttonEnabledStyle
//         ),
//       )
//           : ElevatedButton(
//         onPressed: null,
//         child: Text(
//             labelButtonSectionContentIncomplete,
//             style: _buttonDisabledStyle
//         ),
//       );
//     } else {
//       // Only enable the button once all interactive elements in the section have been interacted with.
//       button = _currentSectionCompleted
//           ? ElevatedButton(
//         onPressed: _goToNextSection,
//         child: Text(
//             '$labelButtonNextSection${_course.courseSections[_currentSectionIndex + 1].sectionTitle}',
//             style: _buttonEnabledStyle
//         ),
//       )
//           : ElevatedButton(
//         onPressed: null,
//         child: Text(
//             labelButtonSectionContentIncomplete,
//             style: _buttonDisabledStyle
//         ),
//       );
//     }
//
//     return button;
//   }
//
//   ElevatedButton _getSectionBeginningButton() {
//     return ElevatedButton(
//       onPressed: _goToPreviousSection,
//       child: Text(
//           '$labelButtonPreviousSection${_course.courseSections[_currentSectionIndex - 1].sectionTitle}',
//           style: _buttonEnabledStyle
//       ),
//     );
//   }
//
//   void _checkInteractiveElementsCompleted() {
//     print(_currentSectionRequiredInteractiveElements.toString());
//     print(_currentSectionCompletedInteractiveElements.toString());
//     if (setEquals(_currentSectionRequiredInteractiveElements, _currentSectionCompletedInteractiveElements)) {
//       setState(() {
//         _currentSectionCompleted = true;
//       });
//     }
//     print(_currentSectionCompleted);
//   }
//
//   void _goToNextSection() {
//     setState(() {
//       // Update section progress
//       _completedSections.add(_course.courseSections[_currentSectionIndex].sectionId);
//       _highestCompletedSectionIndex++;
//       _currentSectionIndex++;
//
//       // Reset current section interactive UI element tracking
//       _currentSectionCompleted = false;
//       _currentSectionRequiredInteractiveElements.clear();
//       _currentSectionCompletedInteractiveElements.clear();
//       _currentSectionNonEmptyQuestions.clear();
//     });
//   }
//
//   void _goToPreviousSection() {
//     setState(() {
//       _currentSectionIndex--;
//       // Override current section interactive UI element tracking as section has already been completed
//       _currentSectionCompleted = true;
//     });
//   }
//
//   void _completeCourse() {
//     setState(() {
//       _completedSections.add(_course.courseSections[_currentSectionIndex].sectionId);
//     });
//   }
// }

class _SectionElement extends StatelessWidget {
  final int index;
  const _SectionElement(this.index);
  @override
  Widget build(BuildContext context) {
    var widgets = context.select<CourseState, List<Widget>>(
          (course) => course.getSectionWidgetsByIndex(index),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: widgets,
      )
    );
  }
}