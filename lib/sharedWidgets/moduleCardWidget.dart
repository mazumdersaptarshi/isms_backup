// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

class ModuleCardWidget extends StatelessWidget {
  final Module module;
  final Course course;
  final CoursesProvider coursesProvider;
  const ModuleCardWidget(
      {super.key, required this.coursesProvider,
      required this.course,
      required this.module});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(module.title),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModuleDetails(
                                course: course,
                                module: module,
                              )));
                },
                child: const Text(
                  'Details',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
                child: const Text(
                  'Test',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
