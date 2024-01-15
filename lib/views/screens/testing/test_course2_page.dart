import 'package:flutter/material.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/screens/testing/test_course2_exam1_page.dart';
import 'package:provider/provider.dart';

class TestCourse2Page extends StatefulWidget {
  @override
  _TestCourse2PageState createState() => _TestCourse2PageState();
}

class _TestCourse2PageState extends State<TestCourse2Page> {
  int currentSection = 0;
  final List<String> sections = [
    'Introduction to Python',
    'What is Pandas',
    'Introduction to NumPy',
    'Introduction to Django',
    // Add more sections as needed
  ];
  // String courseId1 = 'ip78hd';
  String courseId2 = 'jd92nd';

  Future<void> _nextSection(LoggedInState loggedInState) async {
    if (currentSection < sections.length - 1) {
      setState(() {
        currentSection++;
      });
      await loggedInState
          .updateUserProgress(fieldName: 'courses', key: courseId2, data: {
        'courseId': courseId2,
        'completionStatus': 'not_completed',
        'currentSection': 'py1',
        'completedSections': ['py1'],
      });
    } else {
      // Go to assessment
      print('Go to Assessment');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => TestCourse2Exam1Page()));
    }
  }

  void _previousSection() {
    if (currentSection > 0) {
      setState(() {
        currentSection--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

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
              child: SectionContent(section: sections[currentSection]),
            ),
            SizedBox(height: 20),
            if (currentSection > 0)
              ElevatedButton(
                child: Text('Previous Section'),
                onPressed: _previousSection,
              ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text(currentSection < sections.length - 1
                  ? 'Next Section'
                  : 'Take Assessment'),
              onPressed: () => _nextSection(loggedInState),
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
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Replace with actual content
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
