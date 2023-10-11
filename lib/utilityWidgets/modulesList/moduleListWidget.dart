import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/moduleDetailsScreen.dart';
import 'package:provider/provider.dart';
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
                child: widget.isModuleCompleted
                    ? Icon(Icons.check_circle_rounded, color: Colors.green)
                    : Icon(
                        Icons.circle_outlined,
                        color: Colors.orange,
                      ),
              ),
            ],
          ),
          SizedBox(width: 10),
          Text(
            module.title,
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
