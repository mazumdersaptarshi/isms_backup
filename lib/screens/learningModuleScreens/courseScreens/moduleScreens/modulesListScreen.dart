// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../../../sharedWidgets/bottomNavBar.dart';
import '../../../../sharedWidgets/navIndexTracker.dart';
import '../../../../utilityFunctions/platformCheck.dart';
import 'sharedWidgets/moduleTile.dart';

class ModulesListScreen extends StatefulWidget {
  const ModulesListScreen({super.key, required this.course});
  final Course course;
  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  late ModuleDataMaster moduleDataMaster;
  late String userRole;

  @override
  void initState() {
    super.initState();
  }

  bool checkIfModuleStarted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    for (Map<String, dynamic> course_started
        in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name) {
        if (course_started.containsKey("modules_started")) {
          course_started["modules_started"].forEach((module_started) {
            if (module_started == module.title) flag = true;
          });
        }
      }
    }

    return flag;
  }

  bool checkIfModuleCompleted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    for (var course_started in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name &&
          course_started["modules_completed"] != null) {
        course_started["modules_completed"].forEach((module_completed) {
          if (module_completed["module_name"] == module.title) flag = true;
        });
      }
    }

    return flag;
  }

  bool checkIfAllModulesCompleted({required LoggedInState loggedInState}) {
    bool flag = false;

    for (var course_started in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name) {
        if (course_started["modules_completed"] != null &&
            course_started["modules_completed"].length >=
                widget.course.modulesCount) flag = true;
      }
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);

    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = context.watch<CoursesProvider>();
    bool isALlModulesCompleted =
        checkIfAllModulesCompleted(loggedInState: loggedInState);
    moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    userRole = loggedInState.currentUserRole;

    // compute the grid shape:
    // requirements
    int tileMinWidth = 300;
    int tileMinHeight = 200;
    double tileRatio =
        MediaQuery.sizeOf(context).width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
            ? 2
            : 2.5;
    // available width, in pixels
    double horizontalMargin =
        MediaQuery.sizeOf(context).width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
            ? 200
            : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;
    // number of tiles that can fit vertically on the screen
    int maxColumns =
        max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = widget.course.modulesCount ?? 0;
    // grid width, in tiles
    int numberColumns = 1;
    // min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    if (itemCount <= 0) {
      numberColumns = 1;
    } else if (itemCount < 3 && maxColumns >= 3) {
      numberColumns = 3;
    } else {
      numberColumns =
          min(itemCount, maxColumns) > 0 ? min(itemCount, maxColumns) : 1;
    }
    // grid width, in pixels
    //double gridWidth = screenWidth * numberColumns / maxColumns;

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(
        loggedInState,
      ),

      bottomNavigationBar:
          kIsWeb ? null : BottomNavBar(loggedInState: loggedInState),

      body: FutureBuilder<List<Module>>(
        future: moduleDataMaster.modules,
        builder: (BuildContext context, AsyncSnapshot<List<Module>> snapshot) {
          if (snapshot.hasData) {
            List<Module> modules = snapshot.data!;

            return Container(
              margin: EdgeInsets.only(
                top: 20,
                left: horizontalMargin,
                right: horizontalMargin),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
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
                  SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: numberColumns,
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
            return SizedBox(
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
            return SizedBox(
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
