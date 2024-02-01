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
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';

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
      '{"courseId": "ip78hd","courseTitle": "Test Course","courseSummary": "Test Course summary","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionSummary": "Section 1 summary","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p><b><u>What is Document AI?</u></b></p><p>Learn about the fundamentals of Document AI and how it turns unstructured content into business-ready structured data. You will focus on how Document AI uses machine learning (ML) on a scalable could-based platform to help customer unlock insights. You will also learn what Document AI is, determine how it works, review its use cases, and identify its competitive differentiators.</p><p>Learn about the fundamentals of Document AI and how it turns unstructured content into business-ready structured data. You will focus on how Document AI uses machine learning (ML) on a scalable could-based platform to help customer unlock insights. You will also learn what Document AI is, determine how it works, review its use cases, and identify its competitive differentiators.</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "Section 1 Question","questionAnswers": [{"answerId": "ssq1a1","answerText": "ACK","answerCorrect": true},{"answerId": "ssq1a2","answerText": "ACK","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionSummary": "Section 2 summary","sectionElements": [{"elementId": "html2","elementType": "html","elementTitle": "What is Document AI?","elementContent": "<html><body><p><b><u>Why Document AI?</u></b></p><p>Document AI helps out customers to achieve their business goals by unlocking insights from documents using machine learning. While you may think that the use of paper is dwindling, consider these stats:</p><ul><li> Over 4 trillion paper documents in the US, growing at 22% per year.</li><li>Nearly 75% of a typical workers time is spent searching for and filling paper-based information</li><li>95% of corporate information exists on paper</li><li>75% of all documents get lost; 3% of the remainder are misfiled</li><li>Companies spend 20 in labor to file a document; 120 in labor to find a misfiled document; 220 in labor to recreate a lost document</li></ul></body></html>"},{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "Section 2 Question","questionAnswers": [{"answerId": "ssq1a2","answerText": "ACK","answerCorrect": true}]}]}]},{"sectionId": "section3","sectionTitle": "Section 3","sectionSummary": "Section 3 summary","sectionElements": [{"elementId": "html3","elementType": "html","elementTitle": "Static HTML 3","elementContent": "<html><body><p><b><u>What is Document AI?</u></b></p><p>Almost every account you have will want to learn about new ways to serve their customers while improving how they leverage their data. You, on the other hand, also want to help your customers process documents while achieving your goals. Document AI can help you.</p><b>Select each card to learn more.</b></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. Front 1. ","flipCardBack": "Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. Back 1. "},{"flipCardId": "fc2","flipCardFront": "Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. Front 2. ","flipCardBack": "Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. Back 2. "}]}]},{"sectionId": "section4","sectionTitle": "Section 4","sectionSummary": "Section 4 summary","sectionElements": [{"elementId": "html4","elementType": "html","elementTitle": "The Background on Document AI","elementContent": "<html><body><p><b><u>The Background on Document AI</u></b></p><p>For centuries, documents have been foundational to our societies. We record histories, establish laws, legitimize trade, launch companies, and confirm identities with documents.</p><p>The computer age has introduced the idea of digital documents, which now serve as the backbone of our modern societies, and the power and value of digital documents is immense.</p><p><b>Knowledge Check</b></p></body></html>"},{"elementId": "question2","elementType": "question","elementTitle": "Knowledge Check","elementContent": [{"questionId": "ssq1","questionType": "multipleSelectionQuestion","questionText": "Identify some of the industries that use Document AI to transform their businesses.","questionAnswers": [{"answerId": "ssq1a1","answerText": "Engineering, Manufacturing, and Construction","answerCorrect": true},{"answerId": "ssq1a2","answerText": "Supply Chain","answerCorrect": true},{"answerId": "ssq1a3","answerText": "Sports","answerCorrect": true},{"answerId": "ssq1a4","answerText": "Health Care an Life Sciences","answerCorrect": true}]},{"questionId": "ssq2","questionType": "multipleSelectionQuestion","questionText": "Identify some of the industries that use Document AI to transform their businesses.","questionAnswers": [{"answerId": "ssq2a1","answerText": "Engineering, Manufacturing, and Construction","answerCorrect": true},{"answerId": "ssqa2","answerText": "Supply Chain","answerCorrect": true},{"answerId": "ssq2a3","answerText": "Sports","answerCorrect": true},{"answerId": "ssq2a4","answerText": "Health Care an Life Sciences","answerCorrect": true}]}]},{"elementId": "html4","elementType": "html","elementTitle": "Document AI Use Cases","elementContent": "<html><body><p><b><u>Document AI Use Cases</u></b></p><p>Document AI aims to be the platform of choice for business-ready document processing, and we have specialized models for some of the world\'s most commonly used business documents. These specialized or pretrained document models enable higher levels of accuracy, especially with custom document layouts, and always output the same core concepts (“schema”). We have grouped some of these specialized models into bundles that address high-value use cases.</p><p>It is important to note that Document AI has been designed to address a customer’s end-to-end document workflow – but not necessarily the full business workflow. For example, Document AI can help a customer classify and extract information from an invoice, but it does not address the full accounts payable process. Customers can either integrate the Document AI API into their existing workflows (on their own, or with a systems integrator), or they can work with ISV / SaaS providers who leverage Document AI directly.</p></body></html>"}]},{"sectionId": "section5","sectionTitle": "Section 5","sectionSummary": "Section 5 summary","sectionElements": [{"elementId": "html5","elementType": "html","elementTitle": "Assessment","elementContent": "<html><body><p><b><u>Course Assessment</u></b></p></body></html>"},{"elementId": "question5","elementType": "question","elementTitle": "Assessment","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "What is the output of print(0.1 + 0.2 == 0.3)?","questionAnswers": [{"answerId": "ssq1a1","answerText": "True","answerCorrect": false},{"answerId": "ssq1a2","answerText": "False","answerCorrect": false},{"answerId": "ssq1a3","answerText": "Error","answerCorrect": true},{"answerId": "ssq1a4","answerText": "None","answerCorrect": false}]},{"questionId": "ssq2","questionType": "singleSelectionQuestion","questionText": "How do you insert COMMENTS in Python code?","questionAnswers": [{"answerId": "ssq2a1","answerText": "# comment","answerCorrect": true},{"answerId": "ssq2a2","answerText": "// comment","answerCorrect": false},{"answerId": "ssq2a3","answerText": "/* comment */","answerCorrect": false},{"answerId": "ssq2a4","answerText": "<!-- comment -->","answerCorrect": false}]},{"questionId": "ssq3","questionType": "singleSelectionQuestion","questionText": "Which of the following is a correct variable declaration in Python?","questionAnswers": [{"answerId": "ssq3a1","answerText": "int a = 10","answerCorrect": true},{"answerId": "ssq3a2","answerText": "a = 10","answerCorrect": false},{"answerId": "ssq3a3","answerText": "var a = 10","answerCorrect": false},{"answerId": "ssq3a4","answerText": "let a = 10","answerCorrect": false}]}]}]}]}';

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

  /// padding on both sides of HTML and questions
  final EdgeInsets contentPadding = EdgeInsets.only(right: 200, left: 200, bottom: 40);

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
        appBar: IsmsAppBar(context: context),
        // drawer: const SidebarWidget(),
        // drawerScrimColor: Colors.transparent,
        body: Column(
          children: [..._getCurrentSectionWidgets()],
        ));
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets (navigation buttons added) in the current course section.
  List<Widget> _getCurrentSectionWidgets() {
    List<Widget> widgets = [];

    // Add a previous section button (and preceding spacing) to the beginning of the widget [List]
    // only for sections after the first section
    if (_currentSectionIndex > 0) {
      widgets.add(_getSectionBeginningButton());
    }

    widgets.add(Expanded(
      child: ListView(
        children: [..._getCurrentSectionContentWidgets()],
      ),
    ));
    widgets.add(_getSectionEndButton());

    return widgets;
  }

  /// Returns an ordered [List] of all content widgets (i.e. navigation buttons excluded) in the current course section.
  List<Widget> _getCurrentSectionContentWidgets() {
    _getAllCourseWidgets();
    print(_courseWidgets[_course.courseSections[_currentSectionIndex].sectionId].toString());
    return _courseWidgets[_course.courseSections[_currentSectionIndex].sectionId];
  }

  /// Populates data structure [_courseWidgets] with all course widgets.
  void _getAllCourseWidgets() {
    for (Section section in _course.courseSections) {
      _courseWidgets[section.sectionId] = _getSectionContentWidgets(_course.courseSections[_currentSectionIndex]);
    }
  }

  /// Returns an ordered [List] of widgets for a course section.
  /// Widgets are created based on their defined type in the custom [element_model.Element] object,
  /// with data being passed in as required for each.
  List<Widget> _getSectionContentWidgets(Section currentSection) {
    final List<Widget> contentWidgets = [];

    // Add widgets for all elements in the current course section, conditionally building different widget types
    // depending on `elementType` from the JSON
    for (element_model.Element element in currentSection.sectionElements) {
      contentWidgets.add(_separator);

      // Static HTML
      if (element.elementType == ElementTypeValues.html.name) {
        contentWidgets.add(Padding(
          padding: contentPadding,
          child: Flexible(child: Html(data: element.elementContent)),
        ));

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
          Padding(
            padding: contentPadding,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              runSpacing: 10.0,
              children: flipCardWidgets,
            ),
          ),
        ]);
      }
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
        Padding(
          padding: contentPadding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    question.questionText,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _separator,
                  Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey[300],
                  ),
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
                        ),
                ],
              ),
            ),
          ),
        )
      ]);

      // Multiple Selection Question (Checkboxes)
    } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {
      contentWidgets.addAll([
        Padding(
          padding: contentPadding,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey[100],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    question.questionText,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _separator,
                  Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey[300],
                  ),
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
                        ),
                ],
              ),
            ),
          ),
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
              child: Text(AppLocalizations.of(context)!.buttonFinishCourse, style: MoveSectionButtonTextStyle),
              style: MoveSectionButtonStyle,
            )
          : ElevatedButton(
              onPressed: null,
              child:
                  Text(AppLocalizations.of(context)!.buttonSectionContentIncomplete, style: MoveSectionButtonTextStyle),
              style: MoveSectionButtonStyle);
    } else {
      // Only enable the button once all interactive elements in the section have been interacted with
      button = _currentSectionCompleted
          ? ElevatedButton(
              onPressed: _goToNextSection,
              child: Text(
                AppLocalizations.of(context)!
                    .buttonNextSection(_course.courseSections[_currentSectionIndex + 1].sectionTitle),
                style: MoveSectionButtonTextStyle,
              ),
              style: MoveSectionButtonStyle)
          : ElevatedButton(
              onPressed: null,
              child: Text(
                AppLocalizations.of(context)!.buttonSectionContentIncomplete,
                style: MoveSectionButtonTextStyle,
              ),
              style: MoveSectionButtonStyle);
    }

    return button;
  }

  /// Returns an [ElevatedButton] widget used for returning to the previous section.
  ElevatedButton _getSectionBeginningButton() {
    return ElevatedButton(
      onPressed: _goToPreviousSection,
      child: Text(
        AppLocalizations.of(context)!
            .buttonPreviousSection(_course.courseSections[_currentSectionIndex - 1].sectionTitle),
        style: MoveSectionButtonTextStyle,
      ),
      style: MoveSectionButtonStyle,
    );
  }

  final ButtonStyle MoveSectionButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[200],
    elevation: 0,
    minimumSize: Size(double.infinity, 100),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  );

  final TextStyle MoveSectionButtonTextStyle = TextStyle(color: Colors.grey[600]);

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
