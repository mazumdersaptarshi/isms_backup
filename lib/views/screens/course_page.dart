import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/answer.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/element.dart' as isms_element;
import 'package:isms/models/course/flipcard.dart';
import 'package:isms/models/course/question.dart';
import 'package:isms/models/course/section.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final String jsonString = '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "question","elementTitle": "Multiple choice question with single answer selection","elementContent": [{"questionId": "ssq1","questionType": "singleSelectionQuestion","questionText": "SSQ","questionAnswers": [{"answerId": "ssq1a1","answerText": "A1","answerCorrect": false},{"answerId": "ssq1a2","answerText": "A2","answerCorrect": true},{"answerId": "ssq1a3","answerText": "A3","answerCorrect": false}]}]}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "question","elementTitle": "Multiple choice question with multiple answer selection","elementContent": [{"questionId": "msq1","questionType": "multipleSelectionQuestion","questionText": "MSQ","questionAnswers": [{"answerId": "msq1a1","answerText": "A1","answerCorrect": true},{"answerId": "msq1a2","answerText": "A2","answerCorrect": false},{"answerId": "msq1a3","answerText": "A3","answerCorrect": false},{"answerId": "msq1a4","answerText": "A4","answerCorrect": true}]}]},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardId": "fc1","flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardId": "fc2","flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardId": "fc3","flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
  late final Course course;
  final Set<String> completedSections = {};
  int currentCourseSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> courseMap = jsonDecode(jsonString) as Map<String, dynamic>;
    course = Course.fromJson(courseMap);
  }

  List<Widget> getContentWidgets() {
    final List<Widget> contentWidgets = [];

    for (Section section in course.courseSections) {
      /// Iterate through all course sections until we reach one which hasn't been completed
      if (!completedSections.contains(section.sectionId)) {
        for (isms_element.Element element in section.sectionElements) {
          print('element: ${element.elementContent}');
          if (element.elementType == ElementTypeValues.html.name) {
            contentWidgets.add(Html(data: element.elementContent));

          } else if (element.elementType == ElementTypeValues.question.name) {
            final List<CustomRadioView> questions = [];
            Answer finalAnswer;

            for (Question question in element.elementContent) {
              if (question.questionType == QuestionTypeValues.singleSelectionQuestion.name) {
                contentWidgets.addAll([
                  Text(question.questionText),
                  CustomRadioView(
                    values: question.questionAnswers,
                    // groupValue: finalAnswer,
                    onItemSelected: (value) {
                      finalAnswer = value;
                    },
                  )
                ]);
              } else if (question.questionType == QuestionTypeValues.multipleSelectionQuestion.name) {

              }
            }

          } else if (element.elementType == ElementTypeValues.flipCard.name) {
            final List<FlipCardWidget> flipCards = [];

            for (FlipCard flipCard in element.elementContent) {
              flipCards.add(FlipCardWidget(content: flipCard));
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

        /// We need to determine whether the section just added was the final one or not
        /// to only display the "Complete Course" button at the very end.
        /// As such, we evaluate what the state of `completedSections` *will be* once the
        /// section just added is completed.
        if (completedSections.length + 1 == course.courseSections.length) {
          contentWidgets.add(ElevatedButton(
            onPressed: goToNextSection,
            child: const Text('Finish course and return to course list'),
          ));
        } else {
          contentWidgets.add(ElevatedButton(
            onPressed: (){
              if (!completedSections.contains(section.sectionId)) {
                setState(() {
                  completedSections.add(section.sectionId);
                });
              }
            },
            child: Text('Proceed to next section: ${section.sectionTitle}'),
          ));
        }
      }
      /// We only want to display one section at a time so after populating `contentWidgets`
      /// with all of the current section's elements we break out of the loop.
      break;
    }

    // for (int i = 0; i <= currentSection; i++) {
    //   contentWidgets.add(Html(data: htmlContent[i]));
    //   if (i < currentSection) {
    //     contentWidgets.add(const SizedBox(height: 10)); // Adjusted size for less spacing
    //   }
    // }
    //
    // // Flip cards in the "Review" section
    // if (currentSection == sections.length - 1) {
    //   contentWidgets.addAll([
    //     Wrap(
    //       alignment: WrapAlignment.center,
    //       spacing: 10.0,
    //       runSpacing: 10.0,
    //       children: List.generate(4, (index) => FlipCard(content: 'Content for Card ${index + 1}')),
    //     ),
    //     const SizedBox(height: 20),
    //   ]);
    // }

    return contentWidgets;
  }

  void goToNextSection() {
    // if (currentSection < sections.length - 1) {
    //   setState(() {
    //     currentSection++;
    //   });
    // }
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
            ...getContentWidgets(),
            // if (currentSection < sections.length - 1)
            //   ElevatedButton(
            //     onPressed: goToNextSection,
            //     child: const Text('Next Section'),
            //   ),
          ],
        ),
      ),
    );
  }
}

class FlipCardWidget extends StatefulWidget {
  final FlipCard content;

  const FlipCardWidget({Key? key, required this.content}) : super(key: key);

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
  dynamic groupNewValue;

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
    for (Answer value in widget.values) {
      radioButtons.add(
        Expanded(
          flex: 1,
          child: RadioListTile<Answer>(
            title: Text(value.answerText),
            value: value,
            groupValue: groupNewValue,
            onChanged: (value) {
              setState(() {
                groupNewValue = value;
              });
              widget.onItemSelected(value);
            },
            selected: groupNewValue == value,
          ),
        ),
      );
    }

    return radioButtons;
  }
}