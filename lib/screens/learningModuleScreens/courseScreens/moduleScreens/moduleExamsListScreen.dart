// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../sharedWidgets/loadingScreenWidget.dart';
import '../../../../sharedWidgets/navIndexTracker.dart';
import '../../../../themes/common_theme.dart';
import '../../../../utilityFunctions/platformCheck.dart';

class ModuleExamListScreen extends StatefulWidget {
  const ModuleExamListScreen(
      {super.key,
      required this.course,
      required this.examtype,
      required this.module});
  final Course course;
  final Module module;
  final EXAMTYPE examtype;

  @override
  State<ModuleExamListScreen> createState() => _ModuleExamListScreenState();
}

class _ModuleExamListScreenState extends State<ModuleExamListScreen> {
  late ModuleExamDataMaster moduleExamDataMaster;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);

    LoggedInState loggedInState = context.watch<LoggedInState>();

    CoursesProvider coursesProvider = context.watch<CoursesProvider>();

    List<NewExam>? exams = [];
    moduleExamDataMaster =
      ModuleExamDataMaster(
          course: widget.course,
          coursesProvider: coursesProvider,
          module: widget.module);

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: FutureBuilder<List<NewExam>>(
        future: moduleExamDataMaster.exams,
        builder: (BuildContext context, AsyncSnapshot<List<NewExam>> snapshot) {
          if (snapshot.hasData) {
            List<NewExam> exams = snapshot.data!;

            return ExamListContainer(
              exams: exams,
              course: widget.course,
              examtype: EXAMTYPE.moduleExam,
              module: widget.module,
              loggedInState: loggedInState,
            );
          } else if (snapshot.hasError) {
            return Container(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingErrorWidget(
                        textWidget: Text(
                      "Error loading quizes",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
              ),
            );
          } else {
            return Container(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingWidget(
                        textWidget: Text(
                      "Loading quizes ...",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
              ),
            );
          }
        },
      ),

      floatingActionButton: loggedInState.currentUserRole == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExamCreation(
                              course: widget.course,
                              examtype: EXAMTYPE.moduleExam,
                              module: widget.module,
                            )));
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
