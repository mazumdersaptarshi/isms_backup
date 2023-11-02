import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "${widget.course.name} > ${widget.module.title}",
            style: commonTitleStyle,
          )
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.module.title}",
                style: ModuleDescStyle,
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                //child: Image.network(
                //  "https://blogassets.leverageedu.com/blog/wp-content/uploads/2020/04/23152312/IELTS-Study-Material.png",
                //  fit: BoxFit.cover,
                //),
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
            ],
          ),
        ),
      ),
    );
  }
}
