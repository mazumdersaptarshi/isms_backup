import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_provider.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/services/hive/hive_adapters/user_attempts.dart';
import 'package:provider/provider.dart';

class TestRunner extends StatelessWidget {
  const TestRunner({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    final adminProvider = context.watch<AdminProvider>();
    String testCourse =
        '{"courseId": "ip78hd","courseTitle": "Test Course","courseDescription": "Test Course description","courseSections": [{"sectionId": "section1","sectionTitle": "Section 1","sectionElements": [{"elementId": "html1","elementType": "html","elementTitle": "Static HTML 1","elementContent": "<html><body><p>HTML 1</p></body></html>"},{"elementId": "question1","elementType": "singleSelectionQuestion","elementTitle": "Multiple choice question with single answer selection","elementContent": {"questionText": "SSQ","questionAnswers": [{"answerText": "A1","answerCorrect": false},{"answerText": "A2","answerCorrect": true},{"answerText": "A3","answerCorrect": false}]}}]},{"sectionId": "section2","sectionTitle": "Section 2","sectionElements": [{"elementId": "question2","elementType": "multipleSelectionQuestion","elementTitle": "Multiple choice question with multiple answer selection","elementContent": {"questionText": "MSQ","questionAnswers": [{"answerText": "A1","answerCorrect": true},{"answerText": "A2","answerCorrect": false},{"answerText": "A3","answerCorrect": false},{"answerText": "A4","answerCorrect": true}]}},{"elementId": "html2","elementType": "html","elementTitle": "Static HTML 2","elementContent": "<html><body><p>HTML 2</p></body></html>"},{"elementId": "flipcards1","elementType": "flipCard","elementTitle": "FlipCards","elementContent": [{"flipCardFront": "Front 1","flipCardBack": "Back 1"},{"flipCardFront": "Front 2","flipCardBack": "Back 2"},{"flipCardFront": "Front 2","flipCardBack": "Back 3"}]}]}]}';
    String courseId1 = 'ip78hd';
    String courseId2 = 'jd92nd';
    String examId1 = 'de44qv';
    String examId2 = 'rt89nb';
    String examId3 = 'lx54mn';
    Map<String, dynamic> attempts1 = {
      'cv78ok': UserAttempts.fromMap({
        'attemptId': 'cv78ok',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'completed',
        'score': 70,
        'responses': [],
      }),
      'xc45fg': UserAttempts.fromMap({
        'attemptId': 'xc45fg',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'not_completed',
      }),
    };
    Map<String, dynamic> attempts2 = {
      'io98hb': UserAttempts.fromMap({
        'attemptId': 'io98hb',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'completed',
        'score': 80,
        'responses': [],
      }),
      'fc32mn': UserAttempts.fromMap({
        'attemptId': 'fc32mn',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'not_completed',
      }),
    };
    Map<String, dynamic> attempts3 = {
      'gv78jk': UserAttempts.fromMap({
        'attemptId': 'gv78jk',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'completed',
        'score': 100,
        'responses': [],
      }),
      'vx89hn': UserAttempts.fromMap({
        'attemptId': 'vx89hn',
        'startTime': DateTime.now(),
        'endTime': '',
        'completionStatus': 'not_completed',
      }),
    };
    return Scaffold(
      appBar: AppBar(
        title: Text('This is a test page '),
      ),
      body: Container(
        child: Column(
          children: [
            Text('Tracking Buttons'),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> course = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                course = await CourseProvider.getCourseByIDLocal(
                    courseId: courseId1);
                await loggedInState.updateUserProgress(
                    fieldName: 'courses',
                    key: courseId1,
                    data: {
                      'courseId': courseId1,
                      'completionStatus': 'not_completed',
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
                exam = await ExamProvider.getExamByIDLocal(examId: examId1);
                await loggedInState.updateUserProgress(
                    fieldName: 'exams',
                    key: examId1,
                    data: {
                      'courseId': courseId1,
                      'examId': examId1,
                      'attempts': attempts1,
                      'completionStatus': 'not_completed',
                    });
              },
              child:
                  Text('Start Course Introduction to Web Development Exam 1'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> exam = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                exam = await ExamProvider.getExamByIDLocal(examId: examId2);
                await loggedInState.updateUserProgress(
                    fieldName: 'exams',
                    key: examId2,
                    data: {
                      'courseId': courseId1,
                      'examId': examId2,
                      'attempts': attempts2,
                      'completionStatus': 'not_completed',
                    });
              },
              child:
                  Text('Start Course Introduction to Web Development Exam 2'),
            ),
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> exam = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                exam = await ExamProvider.getExamByIDLocal(examId: examId3);
                await loggedInState.updateUserProgress(
                    fieldName: 'exams',
                    key: examId3,
                    data: {
                      'courseId': courseId2,
                      'examId': examId3,
                      'attempts': attempts3,
                      'completionStatus': 'not_completed',
                    });
              },
              child: Text('Start Second Course Exam 1'),
            ),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalDataForUser(
                    loggedInState.currentUser!,
                  );
                  print(res);
                },
                child: Text('Show stored Hive Local Data')),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalDataForUser(
                    loggedInState.currentUser!,
                  );
                  // print(res['exams']['de44qv'].attempts['xc45fg'].responses);
                  print(res['exams']['de44qv'].attempts);
                },
                child: Text('Show stored Hive Local Exam Attempts for Exam1')),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalDataForUser(
                    loggedInState.currentUser!,
                  );
                  // print(res['exams']['de44qv'].attempts['xc45fg'].responses);
                  print(res['exams']['rt89nb'].attempts);
                },
                child: Text('Show stored Hive Local Exam Attempts for Exam2')),
            ElevatedButton(
                onPressed: () {
                  HiveService.getExistingLocalDataFromUsersBox();
                },
                child: Text('Show all Users Data')),
            ElevatedButton(
                onPressed: () {
                  HiveService.clearLocalHiveData();
                },
                child: Text('Clear Hive Data')),
            Divider(),
            Text('Admin Buttons'),
            ElevatedButton(
                onPressed: () {
                  print('-----------------');
                  print(AdminProvider.getUsers());
                },
                child: Text('Get all Users')),
            ElevatedButton(
                onPressed: () {
                  print('-----------------');
                  print(AdminProvider.getCoursesForUser(
                      'jHa0j6gTUUPZZEdfA6NLwND0Y7A3'));
                },
                child:
                    Text('Get Courses for user jHa0j6gTUUPZZEdfA6NLwND0Y7A3')),
            ElevatedButton(
                onPressed: () {
                  print('-----------------');
                  print(AdminProvider.getExamsForCourseForUser(
                      'jHa0j6gTUUPZZEdfA6NLwND0Y7A3', 'ip78hd'));
                },
                child: Text(
                    'Get Webb Dev Course Exam for User jHa0j6gTUUPZZEdfA6NLwND0Y7A3')),
          ],
        ),
      ),
    );
  }
}
