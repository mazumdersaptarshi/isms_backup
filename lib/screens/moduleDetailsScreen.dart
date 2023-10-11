import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/modulesListScreen.dart';
import 'package:isms/slideManagement/fetchSlides.dart';
import 'package:isms/temp.dart';
import 'package:provider/provider.dart';

class ModuleDetails extends StatefulWidget {
  ModuleDetails(
      {super.key, required this.courseIndex, required this.moduleIndex});
  int courseIndex;
  int moduleIndex;
  @override
  State<ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  bool isSlidesFetched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      fetchSlides(
              coursesProvider: coursesProvider,
              courseIndex: widget.courseIndex,
              moduleIndex: widget.moduleIndex)
          .then((value) {
        setState(() {
          {
            isSlidesFetched = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    Module module = coursesProvider
        .allCourses[widget.courseIndex].modules![widget.moduleIndex];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.cabin),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Text("${module.title}"),
            Text("${module.contentDescription}"),
            if (isSlidesFetched)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SlidesDisplayScreen(
                                slides: module.slides!,
                              )));
                },
                child: Text("Study module"),
              )
            else
              Container(
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      Text("Loading slides"),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
