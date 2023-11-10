// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../sharedWidgets/customAppBar.dart';

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
  bool isExamsFetched = false;
  late String userRole;
  late ExamDataMaster examDataMaster;

  @override
  void initState() {
    super.initState();
  }

  fetchExamsList({required CoursesProvider coursesProvider}) async {
    await examDataMaster.fetchModuleExams(module: widget.module);
    setState(() {
      isExamsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

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
    examDataMaster =
        ExamDataMaster(course: course, coursesProvider: coursesProvider);
    if (isExamsFetched == false) {
      fetchExamsList(coursesProvider: coursesProvider);
    }

    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),
      body: isExamsFetched
          ? ExamListContainer(
              exams: exams ?? [],
              course: course,
              examtype: EXAMTYPE.moduleExam,
              module: module,
              loggedInState: loggedInState)
          : SizedBox(
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
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
