import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/course.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../themes/common_theme.dart';

class ModuleDetails extends StatefulWidget {
  ModuleDetails({super.key, required this.course, required this.module, required this.isModuleStarted});
  Course course;
  Module module;
  bool isModuleStarted;
  SlidesDataMaster? slidesDataMaster;
  @override
  State<ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  bool isSlidesFetched = false;
  bool isSlidesListEmpty = false;

  late String userRole;
  @override
  void initState() {
    super.initState();
  }

  //bool checkIfModuleCompleted(
  //    {required LoggedInState loggedInState}) {
  //  bool flag = false;
  //  loggedInState.loggedInUser.courses_started.forEach((course_started) {
  //    if (course_started["course_name"] == widget.course.name) {
  //      course_started["modules_completed"].forEach((module_completed) {
  //        if (module_completed["module_name"] == widget.module.title) flag = true;
  //      });
  //    }
  //  });

  //  return flag;
  //}

  fetchSlidesList({required CoursesProvider coursesProvider}) async {
    await widget.slidesDataMaster!.fetchSlides();

    setState(() {
      {
        if (widget.module.slides == null || widget.module.slides == []) {
          isSlidesListEmpty = true;
        }
        isSlidesFetched = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    userRole = loggedInState.currentUserRole;
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    widget.slidesDataMaster = SlidesDataMaster(
        course: widget.course,
        coursesProvider: coursesProvider,
        module: widget.module);
    if (isSlidesFetched == false) {
      fetchSlidesList(coursesProvider: coursesProvider);
    }
    return Scaffold(
      appBar: LearningModulesAppBar(
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            //Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ModulesListScreen(course: widget.course)));
          },
        ),
        title: "${widget.course.name} > ${widget.module.title}",
      ),

      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModuleExamListScreen(
                            course: widget.course,
                            examtype: EXAMTYPE.moduleExam,
                            module: widget.module,
                          )
                        )
                      );
                    },
                    child: Text("View module exams"),
                  ),
                // TODO move the slides loading logic here
                //if (/*isSlidesFetched && isSlidesListEmpty ==*/ false)
                //else
                //  Container(
                //    height: 100,
                //    child: Center(
                //      child: Column(
                //        children: [
                //          Text("Loading slides"),
                //          CircularProgressIndicator(),
                //        ],
                //      ),
                //    ),
                //  ),
                ElevatedButton(

                  onPressed: () async {
                    await loggedInState.setUserCourseStarted(
                      courseDetails: {
                        "courseID": widget.course.id,
                        "course_name": widget.course.name,
                        "course_modules_count": widget.course.modulesCount
                      });
                    await loggedInState.setUserCourseModuleStarted(
                      courseDetails: {
                        "courseID": widget.course.id,
                        "course_name": widget.course.name,
                        "course_modules_count": widget.course.modulesCount
                      },
                      coursesProvider: coursesProvider,
                      course: widget.course,
                      module: widget.module);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SlidesDisplayScreen(
                          slides: widget.module!.slides!,
                          course: widget.course,
                          module: widget.module,
                        ),
                      ),
                    );
                  },
                  child: Text('Study Module'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "${widget.module.title}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    widget.module.contentDescription,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
