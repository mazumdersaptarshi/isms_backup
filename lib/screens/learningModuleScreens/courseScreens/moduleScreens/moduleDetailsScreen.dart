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
  ModuleDetails({super.key, required this.course, required this.module});
  Course course;
  Module module;
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

    userRole = loggedInState.currentUserRole!;
    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
            "${widget.module.title}",
              style: ModuleDescStyle,
            ),
            SizedBox(height: 20),
            Spacer(),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange[200],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.module.contentDescription,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  // TODO move the slides loading logic into
                  // SlidesDisplayScreen
                  if (isSlidesFetched && isSlidesListEmpty == false)
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () async {
                        await loggedInState.setUserCourseStarted(
                            courseDetails: {
                              "courseID": widget.course.id,
                              "course_name": widget.course.name
                            });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SlidesDisplayScreen(
                                      slides: widget.module!.slides!,
                                      course: widget.course,
                                      module: widget.module,
                                    )));
                      },
                      child: Text('Study Module', style: commonTextStyle),
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
                  SizedBox(height: 20.0),
                  ElevatedButton(
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
                    child: Text('Module Exams', style: commonTextStyle),
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orange),
                      foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                    ),
                  ),

                  //SizedBox(height: 20),
                  //if (userRole == "admin")
                  //  SizedBox(
                  //    width: 200,
                  //    child: ElevatedButton(
                  //      style: customElevatedButtonStyle(),
                  //      onPressed: () {
                  //        Navigator.push(
                  //            context,
                  //            MaterialPageRoute(
                  //                builder: (context) => CreateSlideScreen(
                  //                    course: widget.course,
                  //                    module: widget.module)));
                  //      },
                  //      child:
                  //          Text('Add new slide', style: commonTextStyle),
                  //    ),
                  //  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            // Study Module button aligned to the bottom and centered
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  if (isSlidesFetched && isSlidesListEmpty == false)
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: customElevatedButtonStyle(),
                        onPressed: () async {
                          await loggedInState.setUserCourseStarted(
                              courseDetails: {
                                "courseID": widget.course.id,
                                "course_name": widget.course.name
                              });
                          await loggedInState.setUserCourseModuleStarted(
                              courseDetails: {
                                "courseID": widget.course.id,
                                "course_name": widget.course.name
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
                                      )));
                        },
                        child: Text('Study Module', style: commonTextStyle),
                      ),
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
                  SizedBox(height: 20),
                  if (userRole == "admin")
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: customElevatedButtonStyle(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExamCreation(
                                        course: widget.course,
                                        examtype: EXAMTYPE.moduleExam,
                                        module: widget.module,
                                      )));
                        },
                        child:
                            Text('Create new exam', style: commonTextStyle),
                      ),
                    ),
                  SizedBox(height: 20),
                  if (userRole == "admin")
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        style: customElevatedButtonStyle(),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateSlideScreen(
                                      course: widget.course,
                                      module: widget.module)));
                        },
                        child:
                            Text('Add new slide', style: commonTextStyle),
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
