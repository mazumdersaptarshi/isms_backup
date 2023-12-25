import 'package:flutter/material.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:provider/provider.dart';

class TestRunner extends StatelessWidget {
  const TestRunner({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    String testCourse =
        '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "singleSelectionQuestion","elementTitle": "Multiple choice question with single answer selection","elementContent": {"questionText": "SSQ","questionAnswers": [{"answerText": "A1","answerCorrect": false},{"answerText": "A2","answerCorrect": true},{"answerText": "A3","answerCorrect": false}]}}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "multipleSelectionQuestion","elementTitle": "Multiple choice question with multiple answer selection","elementContent": {"questionText": "MSQ","questionAnswers": [{"answerText": "A1","answerCorrect": true},{"answerText": "A2","answerCorrect": false},{"answerText": "A3","answerCorrect": false},{"answerText": "A4","answerCorrect": true}]}},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
    String courseId = 'ip78hd';
    String examId = 'de44qv';
    return Scaffold(
      appBar: AppBar(
        title: Text('This is a test page '),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> course = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                course =
                    await CourseProvider.getCourseByIDLocal(courseId: courseId);
                await loggedInState.updateUserProgress(
                    fieldName: 'courses',
                    key: courseId,
                    data: {
                      'courseId': courseId,
                      'currentSection': 'mod1',
                      'completedSections': ['mod1'],
                    });
              },
              child: Text(
                  'Start Course Introduction to Web Development Section 1 '),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> exam = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                exam = await ExamProvider.getExamByIDLocal(examId: examId);
                await loggedInState
                    .updateUserProgress(fieldName: 'exams', key: examId, data: {
                  'courseId': courseId,
                  'examId': examId,
                  'attempts': [],
                  'completionStatus': 'not_completed',
                });
              },
              child: Text('Start Course Introduction to Web Development Exam '),
            ),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalData(
                    loggedInState.currentUser!,
                  );
                  print(res);
                },
                child: Text('Show stored Hive Local Data')),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalData(
                    loggedInState.currentUser!,
                  );
                  print(res['exams']['de44qv'].courseId);
                },
                child: Text('Show stored Hive Local Exam Data')),
            ElevatedButton(
                onPressed: () {
                  HiveService.clearLocalHiveData();
                },
                child: Text('Clear Hive Data')),
          ],
        ),
      ),
    );
  }
}
