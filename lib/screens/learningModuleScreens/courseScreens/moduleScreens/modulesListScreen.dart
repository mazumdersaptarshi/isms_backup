import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';

import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:provider/provider.dart';
import 'package:isms/utilityWidgets/modulesList/moduleListWidget.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/fetchModules.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.courseIndex});
  int courseIndex = 0;

  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  bool isModulesFetched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && isModulesFetched == false) {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      fetchModules(
              courseIndex: widget.courseIndex,
              coursesProvider: Provider.of<CoursesProvider>(context))
          .then((value) {
        setState(() {
          isModulesFetched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    Course course = coursesProvider.allCourses[widget.courseIndex];

    if (isModulesFetched) {
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
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateModuleScreen(
                              courseIndex: widget.courseIndex)));
                },
                child: Text("Add new module"))
          ],
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: coursesProvider
                  .allCourses[widget.courseIndex].modules?.length,
              itemBuilder: (BuildContext context, int moduleIndex) {
                Module module = course.modules![moduleIndex];
                return ModuleListWidget(
                  courseIndex: widget.courseIndex,
                  moduleIndex: moduleIndex,
                  isModuleCompleted: true,
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExamCreation(
                                courseIndex: widget.courseIndex,
                                examtype: EXAMTYPE.courseExam,
                              )));
                },
                child: Text("Create exam")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExamListScreen(
                                courseIndex: widget.courseIndex,
                                examtype: EXAMTYPE.courseExam,
                              )));
                },
                child: Text("View course exams")),
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
