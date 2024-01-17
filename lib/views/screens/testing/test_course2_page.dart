import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/services/hive/config/config.dart';
import 'package:isms/views/screens/testing/test_course2_exam1_page.dart';
import 'package:provider/provider.dart';

class TestCourse2Page extends StatefulWidget {
  @override
  _TestCourse2PageState createState() => _TestCourse2PageState();
}

class _TestCourse2PageState extends State<TestCourse2Page> {
  int currentSectionIndex = 0;
  List sectionContents = [];
  List sectionIDs = [];

  Map<String, dynamic> sectionsMap = {
    'nm2scv': 'Introduction to Python',
    'sz12sd': 'What is Python',
    'vb15hy': 'Introduction to Pandas',
    'cf41jj': 'Introduction to Django',
  };
  String courseId2 = 'tt89mn';

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
          loggedInState: loggedInState, courseId: courseId2, progressData: progressData);
    } else {
      // Go to assessment
      print('Go to Assessment');
      Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse2Exam1Page()));
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
        title: Text('Introduction to Python'),
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
