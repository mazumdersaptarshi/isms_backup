import 'package:flutter/material.dart';

import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';

import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import 'createCourseScreen.dart';

class CoursesDisplayScreen extends StatefulWidget {
  CoursesDisplayScreen({super.key});

  @override
  State<CoursesDisplayScreen> createState() => _CoursesDisplayScreenState();
}

class _CoursesDisplayScreenState extends State<CoursesDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("All courses"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: coursesProvider.allCourses.length,
          itemBuilder: (context, courseIndex) {
            return ListTile(
              title: ListTile(
                title: Text(coursesProvider.allCourses[courseIndex].name),
              ),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "Details",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ModulesListScreen(
                                courseIndex: courseIndex,
                              )));
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateCourseScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}