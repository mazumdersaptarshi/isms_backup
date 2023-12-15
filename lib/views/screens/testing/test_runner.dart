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
              child: Text('Start Course Introduction to Web Development  '),
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
