import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;

import 'package:isms/controllers/query_builder/query_builder.dart';
import 'package:isms/models/course/answer.dart';
import 'package:isms/models/course/enums.dart';
import 'package:isms/models/course/course_full.dart';
import 'package:isms/models/course/element.dart' as element_model;
import 'package:isms/models/course/flip_card.dart' as flip_card_model;
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/section_full.dart';
import 'package:isms/views/widgets/course_widgets/checkbox_list.dart';
import 'package:isms/views/widgets/course_widgets/flip_card.dart';
import 'package:isms/views/widgets/course_widgets/radio_list.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

class CoursePage extends StatefulWidget {
  final String courseId;
  final String? section;

  const CoursePage({super.key, required this.courseId, this.section});

  @override
  State<CoursePage> createState() => _CourseState();
}

class _CourseState extends State<CoursePage> {
  // Widget styling related constants

  /// SizedBox for adding consistent spacing between widgets
  static const SizedBox _separator = SizedBox(height: 20);

  /// padding on both sides of HTML and questions
  late EdgeInsets _contentPadding;

  final ButtonStyle _buttonStyleSectionNavigation = ElevatedButton.styleFrom(
    backgroundColor: Colors.grey[200],
    elevation: 0,
    minimumSize: Size(double.infinity, 100),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
    ),
  );

  final TextStyle _textStyleButtonSectionNavigation = TextStyle(color: Colors.grey[600]);

  // Data structures containing course content populated in initState() then not changed

  static const String query = r'''
WITH user_preferred_language AS (
    SELECT preferred_language
    FROM user_settings
    WHERE user_id = {0}
), assigned_courses AS (
	SELECT course_id
	FROM user_course_assignments
	WHERE enabled = true
	AND user_id = {0}
), highest_course_version AS (
	SELECT MAX(cv.content_version) AS content_version
	FROM course_versions cv
	WHERE cv.course_id = {1}
), course_content_and_completion AS (
SELECT cc.content_jdoc,
        ucp.completed_sections
	FROM course_content cc
    LEFT JOIN user_course_progress ucp
	ON (cc.course_id = ucp.course_id AND cc.content_version = ucp.course_learning_version)
	WHERE cc.course_id = {1}
    AND cc.course_id IN (SELECT course_id FROM assigned_courses)
	AND cc.content_version = (SELECT content_version FROM highest_course_version)
	AND cc.content_language = (SELECT preferred_language FROM user_preferred_language)
    AND ucp.user_id = {0}
)
SELECT jsonb_build_object(
        'courseContent', ccac.content_jdoc,
        'courseCompletedSections', ccac.completed_sections
    )
    FROM course_content_and_completion ccac;
	''';

  static const String url = 'http://127.0.0.1:5000/api?query=';

  late Future<http.Response> _responseFuture;

  /// Course data stored in custom [CourseFull] object
  late CourseFull _course;

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
  bool _courseDataStructuresInitialised = false;

  /// [Set] of completed section IDs
  late Set<String> _completedSections;

  /// [Set] of interactive widget IDs which have been interacted with
  final Set<String> _currentSectionCompletedInteractiveElements = {};

  /// [Set] of question widget IDs which have (an) answer(s) selected
  final Set<String> _currentSectionNonEmptyQuestions = {};

  final Map<String, dynamic> _currentSectionSelectedQuestionAnswers = {};

  @override
  void initState() {
    super.initState();
    _responseFuture = _fetchCourseData('u1', widget.courseId);

    // Update _currentSectionIndex to section index passed as query parameter
    if (widget.section != null) {
      try {
        _currentSectionIndex = int.parse(widget.section!) - 1;
      } on FormatException catch (_) {}

      // Reset _currentSectionIndex to 0 if above parse resulted in a negative integer
      if (_currentSectionIndex < 0) {
        _currentSectionIndex = 0;
      }
    }
  }

  /// Returns a [Future] for the GET request to fetch course content and user progress
  /// to be used in the `build()` function.
  Future<http.Response> _fetchCourseData(String uid, String courseId) async {
    String sqlQuery = QueryBuilder.buildSqlQuery(query, [uid, courseId]);
    return http.get(Uri.parse('$url$sqlQuery'));
  }

  /// Returns a [List] of objects returned by the [FutureBuilder] in `build()`.
  ///
  /// This returned List can be empty, which indicates that the course does not exist or it is not assigned to the user.
  List<dynamic> _parseJsonResponse(AsyncSnapshot snapshot) {
    List<dynamic> jsonResponse = [];
    if (snapshot.data.statusCode == 200) {
      // Check if the request was successful
      // Decode the JSON string into a Dart object (in this case, a List)
      jsonResponse = jsonDecode(snapshot.data.body);
    }

    return jsonResponse;
  }

  /// Initialises all data structures which store course content and user progress.
  void _initialiseCourseDataStructures(List<dynamic> jsonResponse) {
    // Read course content
    CourseFull course = CourseFull.fromJson(jsonResponse.first.first[CourseKeys.courseContent.name]);
    _course = course;

    // Initialise data structures which store all course section IDs as well as widgets requiring user interaction
    for (SectionFull section in _course.courseSections) {
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

    // Reset _currentSectionIndex if invalid index passed as query parameter
    if (_currentSectionIndex >= _courseSections.length) {
      _currentSectionIndex = 0;
    }

    // Read course section completion
    if (jsonResponse.first.first[CourseKeys.courseCompletedSections.name] != null) {
      // Initialise _completedSections with fetched section completion
      _completedSections = {...jsonResponse.first.first[CourseKeys.courseCompletedSections.name]};

      // Override _currentSectionCompleted to enable next section button if section index passed as query parameter has been completed
      if (_completedSections.contains(_course.courseSections[_currentSectionIndex].sectionId)) {
        _currentSectionCompleted = true;
      } else if (_currentSectionIndex > 0) {
        // If the section index before the one passed as query parameter has not been completed, reset _currentSectionIndex to 0
        // However, since we have *some* completion recorded, we can assume that at least the very first section has been completed so also override _currentSectionCompleted
        if (!_completedSections.contains(_course.courseSections[_currentSectionIndex - 1].sectionId)) {
          _currentSectionIndex = 0;
          _currentSectionCompleted = true;
        }
      }
    } else {
      // Initialise _completedSections as an empty Set and reset _currentSectionIndex to 0 in case any section index was passed as a query parameter
      _completedSections = {};
      _currentSectionIndex = 0;
    }

    // Mark data structures as initialised to avoid this function being called again for the lifetime of this CourseState
    _courseDataStructuresInitialised = true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _responseFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                  backgroundColor: Colors.red, valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
                appBar: IsmsAppBar(context: context),
                drawer: IsmsDrawer(context: context),
                body: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                ])));
          } else {
            if (!_courseDataStructuresInitialised) {
              List<dynamic> jsonResponse = _parseJsonResponse(snapshot);
              if (jsonResponse.isEmpty) {
                return Scaffold(
                    appBar: IsmsAppBar(context: context),
                    drawer: IsmsDrawer(context: context),
                    body: Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Text(
                          'Error: Course with ID "${widget.courseId}" does not exist or you do not have permission to access it.')
                    ])));
              } else {
                _initialiseCourseDataStructures(jsonResponse);
              }
            }
            return Scaffold(
                appBar: IsmsAppBar(context: context),
                drawer: IsmsDrawer(context: context),
                body: Column(
                  children: [..._getCurrentSectionWidgets()],
                ));
          }
        });
  }

  // Functions returning/updating data structures containing widgets for the whole course and individual sections

  /// Returns an ordered [List] of all widgets (navigation buttons added) in the current course section.
  List<Widget> _getCurrentSectionWidgets() {
    List<Widget> widgets = [];

    _contentPadding = EdgeInsets.only(
      right: MediaQuery.of(context).size.width * 0.05,
      left: MediaQuery.of(context).size.width * 0.05,
      bottom: MediaQuery.of(context).size.width * 0.01,
    );

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
    return _courseWidgets[_course.courseSections[_currentSectionIndex].sectionId];
  }

  /// Populates data structure [_courseWidgets] with all course widgets.
  void _getAllCourseWidgets() {
    for (SectionFull section in _course.courseSections) {
      _courseWidgets[section.sectionId] = _getSectionContentWidgets(_course.courseSections[_currentSectionIndex]);
    }
  }

  /// Returns an ordered [List] of widgets for a course section.
  /// Widgets are created based on their defined type in the custom [element_model.Element] object,
  /// with data being passed in as required for each.
  List<Widget> _getSectionContentWidgets(SectionFull currentSection) {
    final List<Widget> contentWidgets = [];

    // Add widgets for all elements in the current course section, conditionally building different widget types
    // depending on `elementType` from the JSON
    for (element_model.Element element in currentSection.sectionElements) {
      contentWidgets.add(_separator);

      // Static HTML
      if (element.elementType == ElementTypeValues.html.name) {
        contentWidgets.add(Padding(
          padding: _contentPadding,
          child: Html(data: element.elementContent),
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
            padding: _contentPadding,
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
          padding: _contentPadding,
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
                        _currentSectionSelectedQuestionAnswers[question.questionId] = selectedValue;
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
                            _showSingleAnswerExplanationDialog(context, question.questionAnswers,
                                _currentSectionSelectedQuestionAnswers[question.questionId]);
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
          padding: _contentPadding,
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
                    onItemSelected: (checkboxStates) {
                      setState(() {
                        // Only enable the related button once at least one answer has been selected
                        // Since checkboxes can be deselected, we also need to disable the button if all options are
                        // subsequently deselected
                        if (checkboxStates.values.contains(true)) {
                          _currentSectionNonEmptyQuestions.add(question.questionId);
                          _currentSectionSelectedQuestionAnswers[question.questionId] = checkboxStates;
                        } else {
                          _currentSectionNonEmptyQuestions.remove(question.questionId);
                          _currentSectionSelectedQuestionAnswers[question.questionId] = null;
                        }
                      });
                    },
                  ),
                  _separator,
                  _currentSectionNonEmptyQuestions.contains(question.questionId)
                      ? ElevatedButton(
                          onPressed: () {
                            _showMultipleAnswerExplanationDialog(context, question.questionAnswers,
                                _currentSectionSelectedQuestionAnswers[question.questionId]);
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
              style: _buttonStyleSectionNavigation,
              child: Text(AppLocalizations.of(context)!.buttonFinishCourse, style: _textStyleButtonSectionNavigation),
            )
          : ElevatedButton(
              onPressed: null,
              style: _buttonStyleSectionNavigation,
              child: Text(AppLocalizations.of(context)!.buttonSectionContentIncomplete,
                  style: _textStyleButtonSectionNavigation));
    } else {
      // Only enable the button once all interactive elements in the section have been interacted with
      button = _currentSectionCompleted
          ? ElevatedButton(
              onPressed: _goToNextSection,
              style: _buttonStyleSectionNavigation,
              child: Text(
                AppLocalizations.of(context)!
                    .buttonNextSection(_course.courseSections[_currentSectionIndex + 1].sectionTitle),
                style: _textStyleButtonSectionNavigation,
              ))
          : ElevatedButton(
              onPressed: null,
              style: _buttonStyleSectionNavigation,
              child: Text(
                AppLocalizations.of(context)!.buttonSectionContentIncomplete,
                style: _textStyleButtonSectionNavigation,
              ));
    }

    return button;
  }

  /// Returns an [ElevatedButton] widget used for returning to the previous section.
  ElevatedButton _getSectionBeginningButton() {
    return ElevatedButton(
      onPressed: _goToPreviousSection,
      style: _buttonStyleSectionNavigation,
      child: Text(
        AppLocalizations.of(context)!
            .buttonPreviousSection(_course.courseSections[_currentSectionIndex - 1].sectionTitle),
        style: _textStyleButtonSectionNavigation,
      ),
    );
  }

  // Functions for Button onPressed events

  void _showSingleAnswerExplanationDialog(BuildContext context, List<Answer> allAnswers, Answer submittedAnswer) {
    final Answer correctAnswer = allAnswers.firstWhere((answer) => answer.answerCorrect);
    final bool questionCorrect = submittedAnswer.answerId == correctAnswer.answerId;

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return AlertDialog(
          title: questionCorrect
              ? Text(AppLocalizations.of(context)!.dialogAnswerCorrectTitle)
              : Text(AppLocalizations.of(context)!.dialogAnswerIncorrectTitle),
          content: !questionCorrect
              ? Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(AppLocalizations.of(context)!.dialogAnswerIncorrectContentSelected(
                      submittedAnswer.answerText, submittedAnswer.answerExplanation)),
                  Text(AppLocalizations.of(context)!
                      .dialogAnswerIncorrectContentCorrect(correctAnswer.answerText, correctAnswer.answerExplanation))
                ])
              : null,
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.dialogAcknowledge),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void _showMultipleAnswerExplanationDialog(
      BuildContext context, List<Answer> allAnswers, Map<String, bool> answerStates) {
    final List<Answer> correctAnswers = [];
    for (Answer answer in allAnswers) {
      if (answer.answerCorrect) {
        correctAnswers.add(answer);
      }
    }
    final List<Answer> submittedAnswers = [];
    answerStates.forEach((answerId, answerSelected) {
      if (answerSelected) {
        submittedAnswers.add(allAnswers.firstWhere((element) => element.answerId == answerId));
      }
    });
    final bool questionCorrect = listEquals(submittedAnswers, correctAnswers);

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return AlertDialog(
          title: questionCorrect
              ? Text(AppLocalizations.of(context)!.dialogAnswerCorrectTitle)
              : Text(AppLocalizations.of(context)!.dialogAnswerIncorrectTitle),
          content: !questionCorrect
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [..._getMultipleAnswerExplanationDialogContent(correctAnswers, submittedAnswers)])
              : null,
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.dialogAcknowledge),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getMultipleAnswerExplanationDialogContent(List<Answer> correctAnswers, List<Answer> submittedAnswers) {
    List<Widget> contentWidgets = [];

    // Remove any correct answers
    submittedAnswers.removeWhere((element) => correctAnswers.contains(element));

    for (Answer answer in submittedAnswers) {
      contentWidgets.add(Text(AppLocalizations.of(context)!
          .dialogAnswerIncorrectContentSelected(answer.answerText, answer.answerExplanation)));
    }
    for (Answer answer in correctAnswers) {
      contentWidgets.add(Text(AppLocalizations.of(context)!
          .dialogAnswerIncorrectContentCorrect(answer.answerText, answer.answerExplanation)));
    }

    return contentWidgets;
  }

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

      // Reset variable used to conditionally enable next section button if section has not already been completed
      if (!_completedSections.contains(_course.courseSections[_currentSectionIndex].sectionId)) {
        _currentSectionCompleted = false;
      }

      // Reset current section interactive UI element tracking
      _currentSectionCompletedInteractiveElements.clear();
      _currentSectionNonEmptyQuestions.clear();
    });
  }

  /// Decrements [_currentSectionIndex], while also overriding [_currentSectionCompleted]
  /// to not require widget interaction by the user before being allowed to proceed to the next section again.
  void _goToPreviousSection() {
    setState(() {
      _currentSectionIndex--;
      // Override variable used to conditionally enable next section button as section has already been completed
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
