// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/course.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';

class ModuleDetails extends StatefulWidget {
  const ModuleDetails(
      {super.key,
      required this.course,
      required this.module,
      required this.isModuleStarted});
  final Course course;
  final Module module;
  final bool isModuleStarted;
  @override
  State<ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  SlidesDataMaster? slidesDataMaster;
  late String userRole;

  @override
  void initState() {
    super.initState();
  }

  //bool checkIfModuleCompleted(
  //    {required LoggedInState loggedInState}) {
  //  bool flag = false;
  //  loggedInState.loggedInUser.courses_started.forEach((course_started) {
  //    if (course_started["course_name"] == widget.course.name) {
  //      course_started["modules_completed"].forEach((module_completed) {
  //        if (module_completed["module_name"] == widget.module.title) flag = true;
  //      });
  //    }
  //  });

  //  return flag;
  //}

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    slidesDataMaster = SlidesDataMaster(
        course: widget.course,
        coursesProvider: coursesProvider,
        module: widget.module);
    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModuleExamListScreen(
                                  course: widget.course,
                                  examtype: EXAMTYPE.moduleExam,
                                  module: widget.module,
                                )));
                  },
                  child: const Text("View module exams"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await loggedInState.setUserCourseStarted(courseDetails: {
                      "courseID": widget.course.id,
                      "course_name": widget.course.name,
                      "course_modules_count": widget.course.modulesCount
                    });
                    await loggedInState.setUserCourseModuleStarted(
                        courseDetails: {
                          "courseID": widget.course.id,
                          "course_name": widget.course.name,
                          "course_modules_count": widget.course.modulesCount
                        },
                        coursesProvider: coursesProvider,
                        course: widget.course,
                        module: widget.module);
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SlidesDisplayScreen(
                          course: widget.course,
                          module: widget.module,
                          slidesDataMaster: slidesDataMaster!,
                        ),
                      ),
                    );
                  },
                  child: const Text('Study Module'),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.module.title,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.module.contentDescription,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
