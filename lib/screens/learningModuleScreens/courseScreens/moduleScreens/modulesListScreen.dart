import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityWidgets/modulesList/moduleListWidget.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.course});
  Course course;
  ModuleDataMaster? moduleDataMaster;
  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  bool isModulesFetched = false;
  late String userRole;

  fetchCourseModules({required CoursesProvider coursesProvider}) async {
    await widget.moduleDataMaster?.fetchModules();
    setState(() {
      isModulesFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool checkIfModuleStarted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    loggedInState.loggedInUser!.courses_started.forEach((course_started) {
      course_started["modules_started"].forEach((module_started) {
        print("CHECKING ${module_started["module_name"]},, ${module.title}");
        if (module_started["module_name"] == module.title) flag = true;
      });
    });
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = context.watch<CoursesProvider>();

    widget.moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    if (isModulesFetched == false) {
      fetchCourseModules(coursesProvider: coursesProvider);
    }

    userRole = loggedInState.currentUserRole!;
    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    if (isModulesFetched) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursesDisplayScreen()));
            },
          ),
          title: Text("${widget.course.name}"),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.course.modules?.length,
              itemBuilder: (BuildContext context, int moduleIndex) {
                return ModuleListWidget(
                  course: widget.course,
                  module: widget.course.modules[moduleIndex],
                  isModuleCompleted: true,
                  isModuleStarted: checkIfModuleStarted(
                      loggedInState: loggedInState,
                      module: widget.course.modules[moduleIndex]),
                );
              },
            ),
            SizedBox(height: 20),
            if (userRole == "admin")
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExamCreation(
                                  examtype: EXAMTYPE.courseExam,
                                  course: widget.course,
                                )));
                  },
                  child: Text("Create exam")),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExamListScreen(
                                course: widget.course,
                                examtype: EXAMTYPE.courseExam,
                              )));
                },
                child: Text("View course exams")),
            SizedBox(height: 20),
            if (userRole == "admin")
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateModuleScreen(course: widget.course)));
                  },
                  child: Text("Add new module"))
          ],
        ),
      );
    } else {
      return Container(
        child: const AlertDialog(
          title: Text("Fetching modules"),
          content: Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator()),
        ),
      );
    }
  }
}
