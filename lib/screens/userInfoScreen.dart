import 'package:flutter/material.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:provider/provider.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context);
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    List courses_started = customUserProvider.loggedInUser!.courses_started;
    List courses_completed = customUserProvider.loggedInUser!.courses_completed;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Courses started"),
            Container(
              height: 300,
              child: Column(
                children: List.generate(courses_started.length, (index) {
                  return Text("${courses_started[index]}");
                }),
              ),
            ),
            Text("Courses completed"),
            Container(
              height: 300,
              child: Column(
                children: List.generate(courses_completed.length, (index) {
                  return Text("${courses_completed[index]}");
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
