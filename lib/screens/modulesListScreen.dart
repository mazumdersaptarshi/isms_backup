import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/moduleManagement/fetchModules.dart';
import 'package:isms/screens/createCourseScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/screens/createSlideScreen.dart';
import 'package:isms/sharedWidgets/popupDialog.dart';
import 'package:provider/provider.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.parentCourse});
  Course parentCourse;

  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  bool isModulesFetched = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchModules(course: widget.parentCourse).then((value) {
        setState(() {
          isModulesFetched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isModulesFetched) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: ListView.builder(
            itemCount: widget.parentCourse.modules?.length,
            itemBuilder: (context, index) {
              Module module = widget.parentCourse.modules![index];
              return ListTile(
                title: Text(module.title),
                trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CreateSlideScreen(parentModule: module)));
                  },
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CreateModuleScreen(parentCourse: widget.parentCourse)));
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
