import 'package:flutter/material.dart';

import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';

import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../themes/common_theme.dart';
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
            return Card(
              shape: customCardShape,
              color: primaryColor,
              elevation: 4,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios, color: secondaryColor),
                title: Text(coursesProvider.allCourses[courseIndex].name,
                    style: commonTextStyle),
                onTap: () {
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
