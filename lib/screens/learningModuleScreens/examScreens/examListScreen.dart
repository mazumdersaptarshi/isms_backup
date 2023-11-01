import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/takeExamScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../projectModules/courseManagement/examManagement/fetchExams.dart';

class ExamListScreen extends StatefulWidget {
  ExamListScreen(
      {super.key,
      required this.course,
      required this.examtype,
      this.moduleIndex});
  Course course;
  int? moduleIndex;

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
    await fetchExams(
        course: widget.course,
        coursesProvider: Provider.of<CoursesProvider>(context));
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
    if (isExamsFetched == false) {
      fetchExamsList(coursesProvider: coursesProvider);
    }

    List<NewExam>? exams = [];
    Module module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = widget.course.modules![widget.moduleIndex!];
      exams = module.exams;
    } else {
      exams = widget.course.exams;
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
