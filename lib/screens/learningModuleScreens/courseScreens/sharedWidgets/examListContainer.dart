import 'package:flutter/material.dart';

import '../../../../models/course.dart';
import '../../../../models/module.dart';
import '../../../../models/newExam.dart';
import '../../examScreens/examCreationScreen.dart';
import '../../examScreens/sharedWidgets/exam_tile.dart';
import '../../examScreens/takeExamScreen.dart';

class ExamListContainer extends StatelessWidget {
   ExamListContainer({super.key, required this.exams, required this.course, this.module});
  List<NewExam> exams;
  Course course;
  Module? module;
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: exams?.length,
          itemBuilder: (BuildContext context, int examIndex) {
            NewExam exam = exams![examIndex];
            return ExamTile(
              title: exam.title,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TakeExamScreen(
                          course: course,
                          examtype: EXAMTYPE.moduleExam,
                          module: module,
                          exam: exam,
                        )));
              },
              questionCount: exam.questionAnswerSet.length,
            );
          },
        ),
      ],
    );
  }
}
