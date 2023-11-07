import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/exam_tile.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/takeExamScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../sharedWidgets/leaningModulesAppBar.dart';

class ExamListScreen extends StatefulWidget {
  ExamListScreen(
      {super.key,
        required this.course,
        required this.examtype,
        this.moduleIndex});
  Course course;
  int? moduleIndex;
  late ExamDataMaster examDataMaster;
  EXAMTYPE examtype;
  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  bool isExamsFetched = false;
  @override
  void initState() {
    super.initState();
  }

  fetchExamsList({required CoursesProvider coursesProvider}) async {
    await widget.examDataMaster.fetchExams();
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

    List<NewExam>? exams = [];
    Module module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = widget.course.modules![widget.moduleIndex!];
      exams = module.exams;
    } else {
      exams = widget.course.exams;
    }
    widget.examDataMaster =
        ExamDataMaster(course: widget.course, coursesProvider: coursesProvider);
    if (isExamsFetched == false) {
      fetchExamsList(coursesProvider: coursesProvider);
    }


      return Scaffold(
        appBar: LearningModulesAppBar(
          leadingWidget: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          ),
          title: "${widget.course!.name}/ Exams",

        ),
        body: isExamsFetched ?
            ExamListContainer(exams:exams ?? [], course: widget.course, examtype: EXAMTYPE.courseExam, loggedInState: loggedInState)

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
      );

  }
}