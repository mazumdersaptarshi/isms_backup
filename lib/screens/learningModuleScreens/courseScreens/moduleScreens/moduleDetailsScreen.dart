import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/course.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../utilityFunctions/platformCheck.dart';

class ModuleDetails extends StatefulWidget {
  ModuleDetails(
      {super.key,
      required this.course,
      required this.module,
      required this.isModuleStarted});
  Course course;
  Module module;
  bool isModuleStarted;
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
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

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
        margin: EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
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
                  child: Text("View module exams"),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await loggedInState.setUserCourseStarted(
                        courseDetails: courseDetailsMap);
                    await loggedInState.setUserCourseModuleStarted(
                        courseDetails: courseDetailsMap,
                        coursesProvider: coursesProvider,
                        course: widget.course,
                        module: widget.module);

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
                  child: Text('Study Module'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "${widget.module.title}",
                      style: customTheme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text("What you'll learn: "),
                  SizedBox(height: 20.0),
                  Text(
                    widget.module.contentDescription,
                    style: TextStyle(
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
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
