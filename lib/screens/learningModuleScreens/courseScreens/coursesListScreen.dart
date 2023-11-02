import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/sharedWidgets/course_tile.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../themes/common_theme.dart';
import 'createCourseScreen.dart';

class CoursesDisplayScreen extends StatefulWidget {
  CoursesDisplayScreen({super.key});
  String userRole = "user";
  @override
  State<CoursesDisplayScreen> createState() => _CoursesDisplayScreenState();
}

class _CoursesDisplayScreenState extends State<CoursesDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    widget.userRole = loggedInState.currentUserRole != null
        ? loggedInState.currentUserRole!
        : 'user';
    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    return Scaffold(
      appBar: LearningModulesAppBar(
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        title: "All Courses",
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: MediaQuery.sizeOf(context).width <= 700
            ? ListView.builder(
                itemCount: coursesProvider.allCourses.length,
                itemBuilder: (context, courseIndex) {
                  return CourseTile(
                    index: courseIndex,
                    title: coursesProvider.allCourses[courseIndex].name,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModulesListScreen(
                                    course:
                                        coursesProvider.allCourses[courseIndex],
                                  )));
                    },
                  );
                },
              )
            : Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 16 / 9),
                      itemCount: coursesProvider.allCourses.length,
                      itemBuilder: (context, courseIndex) {
                        return CourseTile(
                          index: courseIndex,
                          title: coursesProvider.allCourses[courseIndex].name,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ModulesListScreen(
                                          course: coursesProvider
                                              .allCourses[courseIndex],
                                        )));
                          },
                        );
                      }),
                ),
              ),
      ),
      floatingActionButton: widget.userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateCourseScreen()));
              },
              backgroundColor:
                  customTheme.floatingActionButtonTheme.backgroundColor,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
