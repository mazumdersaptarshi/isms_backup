import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:provider/provider.dart';
import '../../projectModules/courseManagement/coursesProvider.dart';
import 'moduleExpandedItem.dart';

class ModuleListWidget extends StatefulWidget {
  bool isModuleCompleted;
  int courseIndex;
  int moduleIndex;
  ModuleListWidget(
      {super.key,
      this.isModuleCompleted = false,
      required this.courseIndex,
      required this.moduleIndex});

  @override
  _ModuleListWidgetState createState() => _ModuleListWidgetState();
}

class _ModuleListWidgetState extends State<ModuleListWidget> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    Module module = coursesProvider
        .allCourses[widget.courseIndex].modules![widget.moduleIndex];
    return ExpansionTile(
      title: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Icon(CupertinoIcons.book),
              ),
            ],
          ),
          SizedBox(width: 10),
          Text(
            "#Module${module.index}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      children: [
        ModuleExpandedItem(
          info: {'info_title': module.title, 'info_status': true},
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModuleDetails(
                        courseIndex: widget.courseIndex,
                        moduleIndex: widget.moduleIndex)));
          },
        ),
        ModuleExpandedItem(info: {'info_title': "Quiz", 'info_status': false}),
      ],
    );
  }
}
