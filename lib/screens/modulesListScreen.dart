import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/moduleManagement/fetchModules.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/screens/createCourseScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/screens/createSlideScreen.dart';
import 'package:isms/screens/moduleDetailsScreen.dart';
import 'package:isms/sharedWidgets/popupDialog.dart';
import 'package:isms/sharedWidgets/moduleCardWidget.dart';
import 'package:provider/provider.dart';

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
    if (mounted) {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      fetchModules(
              course: coursesProvider.allCourses[widget.courseIndex],
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
    if (isModulesFetched) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.gamepad),
            onPressed: () {
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => CoursesDisplayScreen()));
              // Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          child: ListView.builder(
            itemCount:
                coursesProvider.allCourses[widget.courseIndex].modules?.length,
            itemBuilder: (context, moduleIndex) {
              Module module = coursesProvider
                  .allCourses[widget.courseIndex].modules![moduleIndex];
              return ModuleCardWidget(
                courseIndex: widget.courseIndex,
                coursesProvider: coursesProvider,
                moduleIndex: moduleIndex,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateModuleScreen(
                        parentCourse:
                            coursesProvider.allCourses[widget.courseIndex])));
          },
          child: Icon(Icons.add),
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
