import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/createModuleScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:isms/userManagement/userCourseOperations.dart';
import 'package:provider/provider.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/slideManagement/fetchSlides.dart';

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
  bool isSlidesListEmpty = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted && isSlidesFetched == false) {
      CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
      fetchSlides(
              coursesProvider: coursesProvider,
              courseIndex: widget.courseIndex,
              moduleIndex: widget.moduleIndex)
          .then((value) {
        setState(() {
          {
            Module module = coursesProvider
                .allCourses[widget.courseIndex].modules![widget.moduleIndex];
            print("MODULE.SLIDES: ${module.slides}");
            if (module.slides == null || module.slides == []) {
              isSlidesListEmpty = true;
            }
            isSlidesFetched = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context);
    Module? module;
    try {
      module = coursesProvider
          .allCourses[widget.courseIndex].modules![widget.moduleIndex];
    } catch (e) {}

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: module != null ? Text("${module.title}") : Text("No modules"),
      ),
      body: module != null
          ? Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(187, 210, 206, 100),
                  borderRadius: BorderRadius.circular(20)),
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${module!.title}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: Text("${module!.contentDescription}"),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExamCreation(
                                        courseIndex: widget.courseIndex,
                                        examtype: EXAMTYPE.moduleExam,
                                        moduleIndex: widget.moduleIndex,
                                      )));
                        },
                        child: Text("Create new exam")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateSlideScreen(
                                        courseIndex: widget.courseIndex,
                                        moduleIndex: widget.moduleIndex,
                                      )));
                        },
                        child: Text("Add new slide")),
                    if (isSlidesFetched && isSlidesListEmpty == false)
                      ElevatedButton(
                        onPressed: () async {
                          await setUserCourseStarted(
                              customUserProvider: customUserProvider,
                              courseDetails: {
                                "courseID": coursesProvider
                                    .allCourses[widget.courseIndex].id,
                                "course_name": coursesProvider
                                    .allCourses[widget.courseIndex].name
                              });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SlidesDisplayScreen(
                                        slides: module!.slides!,
                                        courseIndex: widget.courseIndex,
                                        moduleIndex: widget.moduleIndex,
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
                      ),
                  ],
                ),
              ),
            )
          : Container(
              child: Text("No modules"),
            ),
    );
  }
}
