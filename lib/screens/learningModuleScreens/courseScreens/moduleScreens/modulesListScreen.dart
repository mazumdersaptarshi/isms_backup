// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreenHTML.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/sharedWidgets/moduleTile.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../../../sharedWidgets/loadingScreenWidget.dart';
import '../../../../sharedWidgets/navIndexTracker.dart';
import '../../../../utilityFunctions/platformCheck.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.course});
  final Course course;
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
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

    int itemCount = widget.course.modulesCount;

    // Determining the screen width
    double screenWidth = MediaQuery.of(context).size.width;

    // Extracting the Row widget for flexibility
    Row rowWidget() {
      return Row(
        children: [
          ElevatedButton(
            onPressed: () {
              if (isALlModulesCompleted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExamListScreen(
                      course: widget.course,
                      examtype: EXAMTYPE.courseExam,
                    ),
                  ),
                );
              }
            },
            style: customTheme.elevatedButtonTheme.style!.copyWith(
                backgroundColor: isALlModulesCompleted
                    ? MaterialStateProperty.all<Color>(Colors.white)
                    : MaterialStateProperty.all<Color>(Colors.grey.shade200)),
            child: Text("View course exams",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: isALlModulesCompleted ? primaryColor : Colors.grey)),
          ),
          const SizedBox(width: 20),
          if (userRole == "admin")
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
              style: customTheme.elevatedButtonTheme.style!.copyWith(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              child: const Text(
                "Create course exam",
                textAlign: TextAlign.center,
                style: TextStyle(color: primaryColor),
              ),
            ),
        ],
      );
    }

    // Function to get the appropriate button layout
    Widget View_and_Create_exams_button() {
      // Check if the screen width is greater than the threshold
      if (screenWidth > SCREEN_COLLAPSE_WIDTH) {
        return rowWidget();
      } else {
        // Only wrap the ElevatedButtons with Expanded
        return Row(
          children: rowWidget().children.map((child) {
            if (child is ElevatedButton) {
              return Expanded(child: child);
            }
            return child;
          }).toList(),
        );
      }
    }

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: FutureBuilder<List<Module>>(
        future: moduleDataMaster.modules,
        builder: (BuildContext context, AsyncSnapshot<List<Module>> snapshot) {
          if (snapshot.hasData) {
            List<Module> modules = snapshot.data!;

            return NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Container(
                    // margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: primaryColor.shade100,
                      // borderRadius:
                      //     const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            //Expanded(flex: 1, child: Container()),
                            Expanded(
                              //flex: 10,
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 20),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.school_rounded,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                          Expanded(
                                            child: Text(
                                              widget.course.name.toString(),
                                              style: customTheme
                                                  .textTheme.labelLarge!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            'Created ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            widget.course.dateCreated,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text('What you\'ll learn',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        widget.course.description.toString(),
                                        style: customTheme.textTheme.labelLarge!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: View_and_Create_exams_button(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              body: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width >
                                  SCREEN_COLLAPSE_WIDTH
                              ? MediaQuery.of(context).size.width * 0.5
                              : MediaQuery.of(context).size.width,
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Course Content',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        Column(
                          children: List.generate(
                            itemCount,
                            (moduleIndex) {
                              Module module = modules[moduleIndex];
                              return SizedBox(
                                // height: 200,
                                width: MediaQuery.of(context).size.width >
                                        SCREEN_COLLAPSE_WIDTH
                                    ? MediaQuery.of(context).size.width * 0.5
                                    : MediaQuery.of(context).size.width,
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
                        ),
                      ],
                    ),
                  )),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingErrorWidget(
                        textWidget: Text(
                      "Error loading modules",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
              ),
            );
          } else {
            return SizedBox(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingWidget(
                        textWidget: Text(
                      "Loading",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
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
                            //CreateModuleScreen(course: widget.course)));
                            CreateModuleScreenHTML(course: widget.course)));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
