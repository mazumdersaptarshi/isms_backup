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
      required this.courseIndex,
      required this.examtype,
      this.moduleIndex});
  int courseIndex = 0;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && isExamsFetched == false) {
      fetchModuleExams(
              courseIndex: widget.courseIndex,
              coursesProvider: Provider.of<CoursesProvider>(context),
              moduleIndex: widget.moduleIndex!)
          .then((value) {
        setState(() {
          isExamsFetched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    Course course = coursesProvider.allCourses[widget.courseIndex];
    List<NewExam>? exams = [];
    Module? module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = course.modules![widget.moduleIndex!];
      exams = module.exams;
    } else {
      exams = coursesProvider.allCourses[widget.courseIndex].exams;
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
                                        courseIndex: widget.courseIndex,
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
