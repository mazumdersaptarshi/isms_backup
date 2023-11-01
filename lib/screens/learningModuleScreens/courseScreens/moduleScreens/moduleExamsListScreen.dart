import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/takeExamScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/examManagement/fetchExams.dart';

class ModuleExamListScreen extends StatefulWidget {
  ModuleExamListScreen(
      {super.key,
      required this.course,
      required this.examtype,
      this.moduleIndex});
  Course course;
  int? moduleIndex;

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
    await fetchModuleExams(
        course: widget.course,
        coursesProvider: Provider.of<CoursesProvider>(context),
        moduleIndex: widget.moduleIndex!);
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
    Course course = widget.course;
    List<NewExam>? exams = [];
    Module? module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = course.modules![widget.moduleIndex!];
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
          title: Text("${module!.title}"),
          actions: [
            // ElevatedButton(
            //     onPressed: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) => CreateModuleScreen(
            //             courseIndex: widget.courseIndex)));
            // },
            //     child: Text("Add new module"))
          ],
        ),
        body: Column(
          children: [
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TakeExamScreen(
                                        course: widget.course,
                                        examtype: EXAMTYPE.moduleExam,
                                        moduleIndex: widget.moduleIndex,
                                        exam: exam,
                                      )));
                        },
                        child: Text("Take exam"))
                  ],
                );
              },
            ),
            // ElevatedButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ExamCreation(
            //                     courseIndex: widget.courseIndex,
            //                   )));
            //     },
            //     child: Text("Create exam"))
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
