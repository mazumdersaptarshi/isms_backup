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
import 'package:isms/utilityWidgets/modulesList/moduleListWidget.dart';

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
        body: ListView.builder(
          itemCount:
              coursesProvider.allCourses[widget.courseIndex].modules?.length,
          itemBuilder: (BuildContext context, int moduleIndex) {
            Module module = course.modules![moduleIndex];
            return ModuleListWidget(
              courseIndex: widget.courseIndex,
              moduleIndex: moduleIndex,
              isModuleCompleted: true,
            );
          },
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

// class Old extends StatelessWidget {
//   const Old({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: ListView.builder(
//         itemCount:
//         coursesProvider.allCourses[widget.courseIndex].modules?.length,
//         itemBuilder: (context, moduleIndex) {
//           Module module = course.modules![moduleIndex];
//           return ModuleCardWidget(
//             courseIndex: widget.courseIndex,
//             coursesProvider: coursesProvider,
//             moduleIndex: moduleIndex,
//           );
//         },
//       ),
//     );
//   }
// }
