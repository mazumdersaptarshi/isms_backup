import 'package:flutter/material.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCompletionStrategies.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../../../../models/course.dart';
import '../../../../models/module.dart';
import '../../../../models/newExam.dart';
import '../examCreationScreen.dart';
import 'exam_tile.dart';
import '../takeExamScreen.dart';

class ExamListContainer extends StatelessWidget {
   ExamListContainer({super.key, required this.exams, required this.course, this.module, required this.examtype, required this.loggedInState});
  List<NewExam> exams;
  Course course;
  Module? module;
  EXAMTYPE examtype;
  LoggedInState loggedInState;
  NavigateToCourseExamPage({required BuildContext context, required NewExam exam}){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakeExamScreen(
              exam: exam,
              examtype: EXAMTYPE.courseExam,
              course: course,
              examCompletionStrategy: CourseExamCompletionStrategy(course: course, exam: exam, loggedInState: loggedInState),
            )));
  }
   NavigateToModuleExamPage({required BuildContext context, required NewExam exam}){

    if(module !=null)
     Navigator.push(
         context,
         MaterialPageRoute(
             builder: (context) => TakeExamScreen(
               course: course,
               examtype: EXAMTYPE.moduleExam,
               module: module,
               exam: exam,
               examCompletionStrategy: ModuleExamCompletionStrategy(course: course, exam: exam, module: module!, loggedInState: loggedInState),
             )));
   }
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
              if(examtype== EXAMTYPE.courseExam)
                NavigateToCourseExamPage(context: context, exam: exam);
              else NavigateToModuleExamPage(context: context, exam: exam);

              },
              questionCount: exam.questionAnswerSet.length,
            );
          },
        ),
      ],
    );
  }
}
