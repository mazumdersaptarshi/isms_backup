import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../utilityFunctions/platformCheck.dart';

class ModuleExamListScreen extends StatefulWidget {
  ModuleExamListScreen(
      {super.key,
      required this.course,
      required this.examtype,
      required this.module});
  Course course;
  Module module;
  late ExamDataMaster examDataMaster;
  EXAMTYPE examtype;
  @override
  State<ModuleExamListScreen> createState() => _ModuleExamListScreenState();
}

class _ModuleExamListScreenState extends State<ModuleExamListScreen> {
  bool isExamsFetched = false;
  @override
  void initState() {
    super.initState();
  }

  fetchExamsList({required CoursesProvider coursesProvider}) async {
    await widget.examDataMaster.fetchModuleExams(module: widget.module);
    setState(() {
      isExamsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider = context.watch<CoursesProvider>();

    Course course = widget.course;
    List<NewExam>? exams = [];
    Module? module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = widget.module;
      exams = module.exams;
    } else {
      exams = widget.course.exams;
    }
    widget.examDataMaster =
        ExamDataMaster(course: course, coursesProvider: coursesProvider);
    if (isExamsFetched == false) {
      fetchExamsList(coursesProvider: coursesProvider);
    }

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(
        loggedInState,
      ),
      body: isExamsFetched
          ? ExamListContainer(
              exams: exams ?? [],
              course: course,
              examtype: EXAMTYPE.moduleExam,
              module: module,
              loggedInState: loggedInState)
          : Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const AlertDialog(
                title: Text("Fetching Exams"),
                content: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator()),
              ),
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
