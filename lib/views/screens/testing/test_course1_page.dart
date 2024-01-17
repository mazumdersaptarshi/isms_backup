import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/views/screens/testing/test_course1_exam1_page.dart';
import 'package:provider/provider.dart';

class TestCourse1Page extends StatefulWidget {
  @override
  _TestCourse1PageState createState() => _TestCourse1PageState();
}

class _TestCourse1PageState extends State<TestCourse1Page> {
  int currentSectionIndex = 0;
  List sectionContents = [];
  List sectionIDs = [];

  Map<String, dynamic> sectionsMap = {
    'hs89bn': 'Introduction to Web Dev - HTML',
    'ui90ad': 'What is CSS',
    'ds23fh': 'Introduction to JavaScript',
    'bb32kl': 'Introduction to ReactJS',
  };
  String courseId1 = 'ip78hd';

  Future<void> _nextSection({required LoggedInState loggedInState}) async {
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

      // await loggedInState
      //     .updateUserProgress(fieldName: 'courses', key: courseId1, data: {
      //   'courseId': courseId1,
      //   'completionStatus': 'not_completed',
      //   'currentSection': 'mod1',
      //   'completedSections': ['mod1'],
      // });
    } else {
      // Go to assessment
      print('Go to Assessment');
      Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse1Exam1Page()));
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
        title: Text('Introduction to Web Development'),
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
              child: Text(currentSectionIndex < sectionContents.length - 1 ? 'Next Section' : 'Take Assessment'),
              onPressed: () => _nextSection(loggedInState: loggedInState),
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
