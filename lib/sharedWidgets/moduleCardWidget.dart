import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/moduleDetailsScreen.dart';

import '../projectModules/courseManagement/coursesProvider.dart';

class ModuleCardWidget extends StatelessWidget {
  final int moduleIndex;
  final int courseIndex;
  CoursesProvider coursesProvider;
  ModuleCardWidget(
      {required this.coursesProvider,
      required this.courseIndex,
      required this.moduleIndex});

  @override
  Widget build(BuildContext context) {
    Module module =
        coursesProvider.allCourses[courseIndex].modules![moduleIndex];
    return Card(
      margin: EdgeInsets.all(10),
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
                                courseIndex: courseIndex,
                                moduleIndex: moduleIndex,
                              )));
                },
                child: Text(
                  'Details',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Test',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
