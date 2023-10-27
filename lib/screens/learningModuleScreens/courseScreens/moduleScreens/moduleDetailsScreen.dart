import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/userManagement/userCourseOperations.dart';
import 'package:provider/provider.dart';

import 'package:isms/screens/login/loginScreen.dart';

import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/slideManagement/fetchSlides.dart';
import '../../../../themes/common_theme.dart';

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
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    LoggedInState loggedInState = Provider.of<LoggedInState>(context);
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
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    coursesProvider.allCourses[widget.courseIndex].name,
                    style: ModuleDescStyle,
                  ),
                  SizedBox(height: 20),
                  // Card with course description
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Card(
                      elevation: 4,
                      shape: customCardShape,
                      color: primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          module.contentDescription,
                          style: commonTextStyle,
                        ),
                      ),
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
                                await setUserCourseStarted(
                              loggedInState: loggedInState,
                                    courseDetails: {
                                      "courseID": coursesProvider
                                          .allCourses[widget.courseIndex].id,
                                      "course_name": coursesProvider
                                          .allCourses[widget.courseIndex].name
                                    });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SlidesDisplayScreen(
                                              slides: module!.slides!,
                                              courseIndex: widget.courseIndex,
                                              moduleIndex: widget.moduleIndex,
                                            )));
                              },
                              child:
                                  Text('Study Module', style: commonTextStyle),
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
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: customElevatedButtonStyle(),
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
                            child:
                                Text('Create new exam', style: commonTextStyle),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            style: customElevatedButtonStyle(),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CreateSlideScreen(
                                            courseIndex: widget.courseIndex,
                                            moduleIndex: widget.moduleIndex,
                                          )));
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
            )
          : Container(
              child: Text("No modules"),
            ),
    );
  }
}
