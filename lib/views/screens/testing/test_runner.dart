import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('This is a test page '),
      ),
      body: Container(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                String courseId = 'ip78hd';
                Map<String, dynamic> course = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                course =
                    await CourseProvider.getCourseByIDLocal(courseId: courseId);
                await loggedInState.updateCourseProgress(
                    courseId: courseId,
                    courseTitle: course['courseName'],
                    completionStatus: 'not_completed',
                    currentSectionId: 'mod1',
                    currentSection: CourseProvider.getCourseSectionByIdLocal(
                        sectionId: 'mod1', sections: course['courseSections']));

                // await LoggedInState.updateUserLocalData();
              },
              child: Text(
                  'Start Course Introduction to Web Development Section 1 '),
            ),
            ElevatedButton(
              onPressed: () async {
                String courseId = 'ip78hd';
                Map<String, dynamic> course = {};
                //gets Course details by ID from Local storage. For now, we neeed to load this data from
                //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                course =
                    await CourseProvider.getCourseByIDLocal(courseId: courseId);
                await loggedInState.updateCourseProgress(
                    courseId: courseId,
                    courseTitle: course['courseName'],
                    completionStatus: 'not_completed',
                    currentSectionId: 'mod2',
                    currentSection: CourseProvider.getCourseSectionByIdLocal(
                        sectionId: 'mod2', sections: course['courseSections']));

                // await LoggedInState.updateUserLocalData();
              },
              child: Text(
                  'Start Course Introduction to Web Development  Section 2'),
            ),
            ElevatedButton(
                onPressed: () async {
                  var box = Hive.box('users');
                  var existingUserData = await box.get(loggedInState
                      .currentUserUid); // Gets the existing User data from the Hive Box
                  var res = await HiveService.getExistingUserCourseLocalData(
                      loggedInState.currentUserUid,
                      courseId: 'ip78hd');
                  print(res);
                },
                child: Text('Show stored Hive Local Data')),
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
