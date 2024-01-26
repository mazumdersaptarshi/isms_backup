import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/views/screens/testing/test_course1_exam1_page.dart';
import 'package:isms/views/screens/testing/test_course1_exam2_page.dart';
import 'package:provider/provider.dart';

import 'test_course3_exam1_page.dart';

class TestCourse3Page extends StatefulWidget {
  @override
  _TestCourse3PageState createState() => _TestCourse3PageState();
}

class _TestCourse3PageState extends State<TestCourse3Page> {
  int currentSectionIndex = 0;
  List sectionContents = [];
  List sectionIDs = [];

  Map<String, dynamic> sectionsMap = {
    'ds1': 'The basics of data analysis and manipulation.',
    'ds2': 'Data Visualization Techniques',
    'ds3': 'Introduction to Machine Learning',
    'bb32kl': 'Introduction to Computer Vision',
  };
  String courseId1 = 'po76nm';

  Future<void> _nextSection({required LoggedInState loggedInState, int? examIndex}) async {
    if (currentSectionIndex < sectionContents.length - 1) {
      setState(() {
        currentSectionIndex++;
      });
      Map<String, dynamic> progressData = {
        DatabaseFields.completionStatus.name: 'not_completed',
        DatabaseFields.currentSectionId.name: sectionIDs[currentSectionIndex],
      };
      UserProgressState.updateUserCourseProgress(
          loggedInState: loggedInState, courseId: courseId1, progressData: progressData);
    } else {
      print('Go to Assessment  1');
      Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse3Exam1Page()));

      // Go to assessment
    }
  }

  void _previousSection() {
    if (currentSectionIndex > 0) {
      setState(() {
        currentSectionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    sectionContents = sectionsMap.values.toList();
    sectionIDs = sectionsMap.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Introduction to Data Science'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: SectionContent(section: sectionContents[currentSectionIndex]),
            ),
            SizedBox(height: 20),
            if (currentSectionIndex > 0)
              ElevatedButton(
                child: Text('Previous Section'),
                onPressed: _previousSection,
              ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(currentSectionIndex < sectionContents.length - 1 ? 'Next Section' : 'Take Assessment 1'),
              onPressed: () => _nextSection(loggedInState: loggedInState, examIndex: 0),
            ),
            if (currentSectionIndex == sectionContents.length - 1)
              ElevatedButton(
                child: Text(currentSectionIndex < sectionContents.length - 1 ? 'Next Section' : 'Take Assessment 2'),
                onPressed: () => _nextSection(loggedInState: loggedInState, examIndex: 1),
              ),
          ],
        ),
      ),
    );
  }
}

class SectionContent extends StatelessWidget {
  final String section;

  SectionContent({required this.section});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            section,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            // Replace with actual content
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
