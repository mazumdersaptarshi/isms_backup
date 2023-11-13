// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/projectModules/courseManagement/examManagement/examDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/examListContainer.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../sharedWidgets/leaningModulesAppBar.dart';
import '../../../sharedWidgets/loadingScreenWidget.dart';
import '../../../sharedWidgets/navIndexTracker.dart';
import '../../../themes/common_theme.dart';
import '../../../utilityFunctions/platformCheck.dart';

class ExamListScreen extends StatefulWidget {
  const ExamListScreen(
      {super.key,
      required this.course,
      required this.examtype,
      this.moduleIndex});
  final Course course;
  final int? moduleIndex;
  final EXAMTYPE examtype;
  @override
  State<ExamListScreen> createState() => _ExamListScreenState();
}

class _ExamListScreenState extends State<ExamListScreen> {
  bool isExamsFetched = false;
  late String userRole;
  late ExamDataMaster examDataMaster;

  @override
  void initState() {
    super.initState();
  }

  fetchExamsList({required CoursesProvider coursesProvider}) async {
    await examDataMaster.fetchExams();
    setState(() {
      isExamsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);

    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = context.watch<CoursesProvider>();

    List<NewExam>? exams = [];
    Module module;
    if (widget.examtype == EXAMTYPE.moduleExam) {
      module = widget.course.modules[widget.moduleIndex!];
      exams = module.exams;
    } else {
      exams = widget.course.exams;
    }
    examDataMaster =
        ExamDataMaster(course: widget.course, coursesProvider: coursesProvider);
    if (isExamsFetched == false) {
      fetchExamsList(coursesProvider: coursesProvider);
    }

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: isExamsFetched
          ? ExamListContainer(
              exams: exams ?? [],
              course: widget.course,
              examtype: EXAMTYPE.courseExam,
              loggedInState: loggedInState)
          : Container(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingWidget(
                        textWidget: Text(
                      "Loading exams ...",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
              ),
            ),
      floatingActionButton: loggedInState.currentUserRole == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExamCreation(
                            course: widget.course,
                            examtype: EXAMTYPE.courseExam)));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
