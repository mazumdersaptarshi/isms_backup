import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../../../sharedWidgets/bottomNavBar.dart';
import 'sharedWidgets/moduleTile.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.course});
  Course course;
  ModuleDataMaster? moduleDataMaster;
  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  late String userRole;

  @override
  void initState() {
    super.initState();
  }

  bool checkIfModuleStarted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    loggedInState.loggedInUser.courses_started.forEach((course_started) {
      if (course_started["course_name"] == widget.course.name) {
        course_started["modules_started"].forEach((module_started) {
          if (module_started["module_name"] == module.title) flag = true;
        });
      }
    });

    return flag;
  }

  bool checkIfModuleCompleted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    loggedInState.loggedInUser.courses_started.forEach((course_started) {
      if (course_started["course_name"] == widget.course.name &&
          course_started["modules_completed"] != null) {
        course_started["modules_completed"].forEach((module_completed) {
          if (module_completed["module_name"] == module.title) flag = true;
        });
      }
    });

    return flag;
  }

  bool checkIfAllModulesCompleted({required LoggedInState loggedInState}) {
    bool flag = false;

    loggedInState.loggedInUser.courses_started.forEach((course_started) {
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

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;

    double horizontalMargin = MediaQuery.sizeOf(context).width > 900 ? 200 : 10;

    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),

      bottomNavigationBar:
          kIsWeb ? null : BottomNavBar(loggedInState: loggedInState),

      body: FutureBuilder<List<Module>>(
        future: widget.moduleDataMaster!.modules,
        builder: (BuildContext context, AsyncSnapshot<List<Module>> snapshot) {
          if (snapshot.hasData) {
            List<Module> modules = snapshot.data!;

            // compute the grid shape
            // TODO use SliverGridDelegateWithMaxCrossAxisExtent instead
            // requirements
            int tileMinWidth = 300;
            double tileRatio = 16 / 9;
            // available width, in pixels
            double gridMaxWidth = MediaQuery.sizeOf(context).width - (horizontalMargin * 2);
            // number of tiles that can fit vertically on the screen
            int columnsMaxNumber = max((gridMaxWidth / tileMinWidth).floor(), 1);
            // number of tiles that have to fit on the screen
            int itemCount = widget.course.modulesCount;
            // grid width, in tiles
            int columnsNumber = max(1, min(itemCount, columnsMaxNumber));
            // grid width, in pixels
            //double gridWidth = gridMaxWidth * columnsNumber / columnsMaxNumber;

            return Container(
              margin: EdgeInsets.only(
                top: 20,
                left: horizontalMargin,
                right: horizontalMargin),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      child: Row(
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
                              child: const Text("View course exams"),
                            ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamCreation(
                                    course: widget.course,
                                    examtype: EXAMTYPE.courseExam,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Create course exam"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columnsNumber,
                      childAspectRatio: tileRatio,
                    ),
                    itemCount: itemCount,
                    itemBuilder: (BuildContext context, int moduleIndex) {
                      Module module = modules[moduleIndex];
                      return Container(
                        // margin:
                        //     EdgeInsets.symmetric(horizontal: horizontalMargin),
                        child: ModuleTile(
                          course: widget.course,
                          module: module,
                          isModuleStarted: checkIfModuleStarted(
                              loggedInState: loggedInState,
                              module: module),
                          isModuleCompleted: checkIfModuleCompleted(
                              loggedInState: loggedInState,
                              module: module),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const AlertDialog(
                title: Text("Error fetching modules"),
                content: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                ),
              ),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const AlertDialog(
                title: Text("Fetching Modules"),
                content: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator()),
              ),
            );
          }
        },
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
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
