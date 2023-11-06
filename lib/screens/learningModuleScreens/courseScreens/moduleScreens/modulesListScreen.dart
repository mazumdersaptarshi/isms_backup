import 'dart:math';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'sharedWidgets/moduleTile.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../../../themes/common_theme.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.course});
  Course course;
  ModuleDataMaster? moduleDataMaster;
  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  bool isModulesFetched = false;
  late String userRole;

  fetchCourseModules({required CoursesProvider coursesProvider}) async {
    await widget.moduleDataMaster?.fetchModules();
    setState(() {
      isModulesFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool checkIfModuleStarted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    // TODO de-enable
    //loggedInState.loggedInUser!.courses_started.forEach((course_started) {
    //  course_started["modules_started"].forEach((module_started) {
    //    if (module_started["module_name"] == module.title) flag = true;
    //  });
    //});

    return flag;
  }

  bool checkIfAllModulesCompleted({required LoggedInState loggedInState}) {
    bool flag = false;

    loggedInState.loggedInUser!.courses_started.forEach((course_started) {
      if (course_started["course_name"] == widget.course.name) {
        if (course_started["modules_completed"] != null &&
            course_started["modules_completed"].length >=
                widget.course.modulesCount) flag = true;
      }
    });
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = context.watch<CoursesProvider>();
    bool isALlModulesCompleted =
        checkIfAllModulesCompleted(loggedInState: loggedInState);
    widget.moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    if (isModulesFetched == false) {
      fetchCourseModules(coursesProvider: coursesProvider);
    }

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    userRole = loggedInState.currentUserRole;

    // compute the grid shape:
    // requirements
    int tileMinWidth = 250;
    double tileRatio = 16 / 9;
    // available width, in pixels
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns = max((screenWidth/tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = coursesProvider.allCourses.length;
    // grid width, in tiles
    int numberColumns = min(itemCount, maxColumns);
    // grid width, in pixels
    double gridWidth = screenWidth * numberColumns / maxColumns;

    return Scaffold(
      appBar: LearningModulesAppBar(
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoursesDisplayScreen()));
          },
        ),
        title: "${widget.course.name} / All Modules",
      ),

      body: Container(
        margin: EdgeInsets.only(top: 20),
        //padding: const EdgeInsets.all(16.0),
        child: isModulesFetched
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (isALlModulesCompleted)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ExamListScreen(
                                course: widget.course,
                                examtype: EXAMTYPE.courseExam,
                              ),
                            ),
                          );
                        },
                        child: Text("View course exams"),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: gridWidth,
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: numberColumns,
                        childAspectRatio: tileRatio,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (BuildContext context, int moduleIndex) {
                        return ModuleTile(
                          course: widget.course,
                          module: widget.course.modules[moduleIndex],
                          isModuleStarted: checkIfModuleStarted(
                              loggedInState: loggedInState,
                              module: widget.course.modules[moduleIndex]),
                          isModuleCompleted: false,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
          : AlertDialog(
              title: Text("Fetching modules"),
              content: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator()),
            ),
      ),

      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateModuleScreen(course: widget.course)));
              },
              backgroundColor:
                  customTheme.floatingActionButtonTheme.backgroundColor,
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
