import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/examManagement/fetchExams.dart';
import 'package:isms/models/course.dart';

import 'package:isms/models/newExam.dart';
import 'package:isms/models/slide.dart';

import 'package:isms/screens/examCreation.dart';
import 'package:isms/screens/examScreen.dart';
import 'package:provider/provider.dart';

class ExamListScreen extends StatefulWidget {
  ExamListScreen({super.key, required this.courseIndex});
  int courseIndex = 0;

  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  bool isExamsFetched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && isExamsFetched == false) {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      fetchExams(
              courseIndex: widget.courseIndex,
              coursesProvider: Provider.of<CoursesProvider>(context))
          .then((value) {
        setState(() {
          isExamsFetched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    Course course = coursesProvider.allCourses[widget.courseIndex];

    if (isExamsFetched) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("${course.name}"),
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
              itemCount:
                  coursesProvider.allCourses[widget.courseIndex].exams?.length,
              itemBuilder: (BuildContext context, int examIndex) {
                NewExam exam = course.exams![examIndex];
                return Row(
                  children: [
                    Text(exam.title),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TakeExamScreen(
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
