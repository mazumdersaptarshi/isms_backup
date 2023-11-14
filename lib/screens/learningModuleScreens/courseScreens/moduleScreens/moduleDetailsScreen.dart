// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import '../../../../sharedWidgets/navIndexTracker.dart';

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
  late String userRole;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);
    LoggedInState loggedInState = context.watch<LoggedInState>();

    userRole = loggedInState.currentUserRole;

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    Map<String, dynamic> courseDetailsMap = {
      "courseID": widget.course.id,
      "course_name": widget.course.name,
      "course_modules_count": widget.course.modulesCount,
      "started_at": DateTime.now()
    };
    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(
        loggedInState,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 20),
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
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loggedInState.setUserCourseStarted(
                        courseDetails: courseDetailsMap);
                    await loggedInState.setUserCourseModuleStarted(
                        courseDetails: courseDetailsMap,
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
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.module.title,
                      style: customTheme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text("What you'll learn: "),
                  const SizedBox(height: 20.0),
                  Text(
                    widget.module.contentDescription,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: loggedInState.currentUserRole == "admin"
          ? FloatingActionButton(
              onPressed: () {
                //Navigator.push(
                //    context,
                //    MaterialPageRoute(
                //        builder: (context) => CreateSlideScreen(
                //            course: widget.course, module: widget.module)));
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
