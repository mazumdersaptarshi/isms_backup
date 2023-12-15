import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:isms/models/enums.dart';
import 'package:isms/models/course/course.dart';
import 'package:isms/models/course/section.dart';
import 'package:isms/models/course/flipcard.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final String jsonString = '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "html1","sectionType": "html","sectionTitle": "Static HTML 1","sectionContent": "<html><body><p>HTML 1</p></body></html>"},{"sectionId": "question1","sectionType": "singleSelectionQuestion","sectionTitle": "Multiple choice question with single answer selection","sectionContent": {"questionText": "SSQ","questionAnswers": [{"answerText": "A1","answerCorrect": false},{"answerText": "A2","answerCorrect": true},{"answerText": "A3","answerCorrect": false}]}},{"sectionId": "question2","sectionType": "multipleSelectionQuestion","sectionTitle": "Multiple choice question with multiple answer selection","sectionContent": {"questionText": "MSQ","questionAnswers": [{"answerText": "A1","answerCorrect": true},{"answerText": "A2","answerCorrect": false},{"answerText": "A3","answerCorrect": false},{"answerText": "A4","answerCorrect": true}]}},{"sectionId": "button1","sectionType": "nextSectionButton","sectionContent": "Proceed to next section"},{"sectionId": "html2","sectionType": "html","sectionTitle": "Static HTML 2","sectionContent": "<html><body><p>HTML 2</p></body></html>"},{"sectionId": "flipcards1","sectionType": "flipCard","sectionTitle": "FlipCards","sectionContent": [{"flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}';
  late final Course course;
  late final List<Map<String,dynamic>> courseSectionCompletion;
  int currentCourseSectionIndex = 0;

  @override
  void initState() {
    super.initState();
    final Map<String, dynamic> courseMap = jsonDecode(jsonString) as Map<String, dynamic>;
    course = Course.fromJson(courseMap);
    courseSectionCompletion = initialiseCourseSectionCompletion();
  }

  List<Map<String,dynamic>> initialiseCourseSectionCompletion() {
    List<Map<String,dynamic>> courseSectionCompletion = [];

    for (Section section in course.courseSections) {
      courseSectionCompletion.add(
          {
            SectionKeys.sectionId.name: section.sectionId,
            'sectionCompleted': false
          }
      );
    }

    return courseSectionCompletion;
  }

  List<Widget> getContentWidgets() {
    final List<Widget> contentWidgets = [];

    for (Section section in course.courseSections) {
      if (section.sectionType == SectionTypeValues.html.name) {
        contentWidgets.add(Html(data: section.sectionContent));
      } else if (section.sectionType == SectionTypeValues.singleSelectionQuestion.name) {

      } else if (section.sectionType == SectionTypeValues.multipleSelectionQuestion.name) {

      } else if (section.sectionType == SectionTypeValues.flipCard.name) {
        final List<FlipCard> flipCardsContent = section.sectionContent;
        final List<FlipCardWidget> flipCards = [];

        for (FlipCard content in flipCardsContent) {
          flipCards.add(FlipCardWidget(content: content));
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
      } else if (section.sectionType == SectionTypeValues.nextSectionButton.name) {
        contentWidgets.add(ElevatedButton(
          onPressed: goToNextSection,
          child: Text(section.sectionContent),
        ));
      }
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
