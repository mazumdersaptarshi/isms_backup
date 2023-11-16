// ignore_for_file: file_names

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
  const ExamListContainer(
      {super.key,
      required this.exams,
      required this.course,
      this.module,
      required this.examtype,
      required this.loggedInState});
  final List<NewExam> exams;
  final Course course;
  final Module? module;
  final EXAMTYPE examtype;
  final LoggedInState loggedInState;
  navigateToCourseExamPage(
      {required BuildContext context, required NewExam exam}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakeExamScreen(
              exam: exam,
              examtype: EXAMTYPE.courseExam,
              course: course,
                  examCompletionStrategy: CourseExamCompletionStrategy(
                      course: course, exam: exam, loggedInState: loggedInState),
            )));
  }

  navigateToModuleExamPage(
      {required BuildContext context, required NewExam exam}) {
    if (module != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakeExamScreen(
                    course: course,
                    examtype: EXAMTYPE.moduleExam,
                    module: module,
                    exam: exam,
                    examCompletionStrategy: ModuleExamCompletionStrategy(
                        course: course,
                        exam: exam,
                        module: module!,
                        loggedInState: loggedInState),
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: MediaQuery.of(context).size.width > 700
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              itemCount: exams.length,
              itemBuilder: (BuildContext context, int examIndex) {
                NewExam exam = exams[examIndex];
                return ExamTile(
                  title: exam.title,
                  onPressed: () {
                    if (examtype == EXAMTYPE.courseExam) {
                      navigateToCourseExamPage(context: context, exam: exam);
                    } else {
                      navigateToModuleExamPage(context: context, exam: exam);
                    }
                  },
                  questionCount: exam.questionAnswerSet.length,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
