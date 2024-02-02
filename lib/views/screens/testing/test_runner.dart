import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/screens/testing/test_course1_page.dart';
import 'package:isms/views/screens/testing/test_course2_page.dart';
import 'package:isms/views/screens/testing/test_course3_exam1_page.dart';
import 'package:isms/views/screens/testing/test_course3_page.dart';

// import 'package:isms/views/screens/testing/test_ui/test_course3_page.dart';
import 'package:isms/views/screens/testing/test_ui_type1/test_course3_page.dart';
import 'package:isms/views/screens/testing/test_ui_type2/first_page.dart';
import 'package:provider/provider.dart';

class TestRunner extends StatelessWidget {
  const TestRunner({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: Container(
        child: Column(
          children: [
            Text('Test Page'),
            Text('Hive Local Storage functions'),
            ElevatedButton(
                onPressed: () async {
                  var res = await HiveService.getExistingLocalDataForUser(
                    loggedInState.currentUser!,
                  );
                  print(res);
                },
                child: Text('Show stored Hive Local Data')),
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
            Text('Mockup Courses'),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse1Page()));
                },
                child: Text('Test Course 1 Introduction to Web Dev')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse2Page()));
                },
                child: Text('Test Course 2 Introduction to Python')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TestCourse3Page()));
                },
                child: Text('Test Course 3 Introduction to Data Science')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DocumentAIPage()));
                },
                child: Text('Test Course 3 Document AI')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CoursePageType2()));
                },
                child: Text('CourseType2')),
            Divider(),
            Text('Admin Buttons'),
            ElevatedButton(
                onPressed: () {
                  print('-----------------');
                  print(AdminState().getAllUsersData);
                },
                child: Text('Get all Users')),
          ],
        ),
      ),
    );
  }
}
