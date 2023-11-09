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

    widget.examDataMaster =
      ExamDataMaster(
          course: widget.course,
          coursesProvider: coursesProvider);

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

      body: FutureBuilder<List<NewExam>>(
        future: widget.examDataMaster.exams,
        builder: (BuildContext context, AsyncSnapshot<List<NewExam>> snapshot) {
          if (snapshot.hasData) {
            List<NewExam> exams = snapshot.data!;

            return ExamListContainer(
              exams: exams,
              course: widget.course,
              examtype: EXAMTYPE.courseExam,
              loggedInState: loggedInState,
            );
          } else if (snapshot.hasError) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: const AlertDialog(
                title: Text("Error fetching course exams"),
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
