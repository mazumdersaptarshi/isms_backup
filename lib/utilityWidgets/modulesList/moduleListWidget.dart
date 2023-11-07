// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
//import 'package:provider/provider.dart';
import '../../models/course.dart';
import '../../screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import '../../screens/learningModuleScreens/examScreens/examCreationScreen.dart';
//import '../../userManagement/loggedInState.dart';
import 'moduleExpandedItem.dart';

class ModuleListWidget extends StatefulWidget {
  final bool isModuleCompleted;
  final bool isModuleStarted;
  final Course course;
  final Module module;
  const ModuleListWidget(
      {super.key,
      this.isModuleCompleted = false,
      required this.course,
      required this.module,
      this.isModuleStarted = false});

  @override
  State<ModuleListWidget> createState() => _ModuleListWidgetState();
}

class _ModuleListWidgetState extends State<ModuleListWidget> {
  @override
  Widget build(BuildContext context) {
    //LoggedInState loggedInState = context.watch<LoggedInState>();

    return ExpansionTile(
      title: Row(
        children: [
          const Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Icon(CupertinoIcons.book),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Text(
            "#Module${widget.module.index}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      children: [
        ModuleExpandedItem(
          info: {'info_title': widget.module.title, 'info_status': true},
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModuleDetails(
                        course: widget.course, module: widget.module)));
          },
        ),
        if (widget.isModuleStarted)
          ModuleExpandedItem(
            info: const {'info_title': "Quiz", 'info_status': false},
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
          ),
      ],
    );
  }
}
