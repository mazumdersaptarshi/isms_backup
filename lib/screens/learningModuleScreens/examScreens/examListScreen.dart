import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/takeExamScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';

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
  late String userRole;

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

    userRole = loggedInState.currentUserRole;

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

    if (isExamsFetched) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("${widget.course.name}"),
        ),
        body: Column(
          children: [
            Text("${exams}"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: exams?.length,
              itemBuilder: (BuildContext context, int examIndex) {
                NewExam exam = exams![examIndex];
                return Row(
                  children: [
                    Text(exam.title),
                    ElevatedButton(
                        onPressed: () {
                          if (widget.examtype == EXAMTYPE.courseExam) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TakeExamScreen(
                                          exam: exam,
                                          examtype: EXAMTYPE.courseExam,
                                          course: widget.course,
                                        )));
                          }
                        },
                        child: Text("Take exam"))
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            if (userRole == "admin")
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExamCreation(
                                  examtype: EXAMTYPE.courseExam,
                                  course: widget.course,
                                )));
                  },
                  child: Text("Create exam")),
          ],
        ),
      );
    } else {
      return Container(
        child: const AlertDialog(
          title: Text("Fetching Exams"),
          content: Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator()),
        ),
      );
    }
  }
}
