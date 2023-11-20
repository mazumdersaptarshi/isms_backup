// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createSlideScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/htmlSlideDisplay.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/slidesDisplayScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/sharedWidgets/navIndexTracker.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class ModuleDetails extends StatefulWidget {
  const ModuleDetails(
      {super.key,
      required this.course,
      required this.module,
      required this.isModuleStarted});
  final Course course;
  final Module module;
  final bool isModuleStarted;
  @override
  State<ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  late String userRole;
  final isWeb = kIsWeb;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);
    LoggedInState loggedInState = context.watch<LoggedInState>();

    userRole = loggedInState.currentUserRole;

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    Map<String, dynamic> courseDetailsMap = {
      "courseID": widget.course.id,
      "course_name": widget.course.name,
      "course_modules_count": widget.course.modulesCount,
      "course_exams_count": widget.course.examsCount,
      "started_at": DateTime.now()
    };
    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await loggedInState.setUserCourseStarted(
                            courseDetails: courseDetailsMap);
                        await loggedInState.setUserCourseModuleStarted(
                            courseDetails: courseDetailsMap,
                            coursesProvider: coursesProvider,
                            course: widget.course,
                            module: widget.module);

                        if (!context.mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SlidesDisplayScreen(
                              course: widget.course,
                              module: widget.module,
                            ),
                          ),
                        );
                      },
                      child: const Text('Study Module'),
                    ),
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
                      child: const Text("View module exams"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                surfaceTintColor: Colors.white,
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height:
                        isWeb ? MediaQuery.of(context).size.height - 260 : 500,
                    child: ListView(
                      children: [
                        Text(
                          '${widget.module.title}:',
                          style: const TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        const Divider(
                          height: 2,
                          color: Colors.grey,
                          thickness: 2,
                        ),
                        const SizedBox(height: 20),
                        HTMLSlideDisplay(
                            htmlString: widget.module.additionalInfo),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: loggedInState.currentUserRole == "admin"
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateSlideScreen(
                            course: widget.course, module: widget.module)));
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
    );
  }
}
