import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/takeExamScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../sharedWidgets/customAppBar.dart';
import '../../examScreens/sharedWidgets/exam_tile.dart';

class ModuleExamListScreen extends StatefulWidget {
  ModuleExamListScreen(
      {super.key,
        required this.course,
        required this.examtype,
        required this.module});
  Course course;
  Module module;
  late ModuleExamDataMaster moduleExamDataMaster;
  EXAMTYPE examtype;

  @override
  State<ModuleExamListScreen> createState() => _ModuleExamListScreenState();
}

class _ModuleExamListScreenState extends State<ModuleExamListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider = context.watch<CoursesProvider>();

    List<NewExam>? exams = [];
    widget.moduleExamDataMaster =
      ModuleExamDataMaster(
          course: widget.course,
          coursesProvider: coursesProvider,
          module: widget.module);

    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),
      body: FutureBuilder<List<NewExam>>(
        future: widget.moduleExamDataMaster.exams,
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
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const AlertDialog(
                title: Text("Error fetching module exams"),
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
                title: Text("Fetching Exams"),
                content: Align(
                  alignment: Alignment.topCenter,
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
