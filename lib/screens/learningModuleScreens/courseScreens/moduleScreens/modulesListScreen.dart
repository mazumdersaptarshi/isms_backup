// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/sharedWidgets/moduleTile.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/createModuleScreenHTML.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../models/module.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import '../../../../sharedWidgets/loadingScreenWidget.dart';
import '../../../../sharedWidgets/navIndexTracker.dart';
import '../../../../utilityFunctions/platformCheck.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key, required this.course});
  final Course course;
  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  bool isModulesFetched = false;
  late String userRole;
  ModuleDataMaster? moduleDataMaster;

  fetchCourseModules({required CoursesProvider coursesProvider}) async {
    await moduleDataMaster?.fetchModules();
    setState(() {
      isModulesFetched = true;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  bool checkIfModuleStarted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    for (Map<String, dynamic> course_started
        in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name) {
        if (course_started.containsKey("modules_started")) {
          course_started["modules_started"].forEach((module_started) {
            if (module_started == module.title) flag = true;
          });
        }
      }
    }

    return flag;
  }

  bool checkIfModuleCompleted(
      {required LoggedInState loggedInState, required Module module}) {
    bool flag = false;
    for (var course_started in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name &&
          course_started["modules_completed"] != null) {
        course_started["modules_completed"].forEach((module_completed) {
          if (module_completed["module_name"] == module.title) flag = true;
        });
      }
    }

    return flag;
  }

  bool checkIfAllModulesCompleted({required LoggedInState loggedInState}) {
    bool flag = false;

    for (var course_started in loggedInState.loggedInUser.courses_started) {
      if (course_started["course_name"] == widget.course.name) {
        if (course_started["modules_completed"] != null &&
            course_started["modules_completed"].length >=
                widget.course.modulesCount) flag = true;
      }
    }
    return flag;
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);

    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = context.watch<CoursesProvider>();
    bool isALlModulesCompleted =
        checkIfAllModulesCompleted(loggedInState: loggedInState);
    moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    if (isModulesFetched == false) {
      fetchCourseModules(coursesProvider: coursesProvider);
    }

    userRole = loggedInState.currentUserRole;

    // compute the grid shape:
    // requirements
    int tileMinWidth = 300;
    int tileMinHeight = 200;
    double tileRatio =
        MediaQuery.sizeOf(context).width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
            ? 2
            : 2.5;
    // available width, in pixels
    double horizontalMargin =
        MediaQuery.sizeOf(context).width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
            ? MediaQuery.of(context).size.width * 0.2
            : 10;
    double screenWidth = MediaQuery.sizeOf(context).width;

    // int maxColumns =
    //     max(((screenWidth - (horizontalMargin * 2)) / tileMinWidth).floor(), 1);
    // number of tiles that have to fit on the screen
    int itemCount = widget.course.modulesCount ?? 0;
    // grid width, in tiles
    int numberColumns = 1;

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: isModulesFetched
          ? Container(
              // margin: EdgeInsets.only(
              //     left: horizontalMargin, right: horizontalMargin),
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: primaryColor.shade100,
                        // borderRadius:
                        //     const BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Flexible(flex: 1, child: Container()),
                              Flexible(
                                flex: 8,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.school_rounded,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            Text(
                                              widget.course.name.toString(),
                                              style: customTheme
                                                  .textTheme.labelLarge!
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month_rounded,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              'Created ',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '${widget.course.dateCreated}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text('What you\'ll learn',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.course.description.toString(),
                                          style: customTheme
                                              .textTheme.labelLarge!
                                              .copyWith(color: Colors.white),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20, bottom: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                if (isALlModulesCompleted)
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ExamListScreen(
                                                            course:
                                                                widget.course,
                                                            examtype: EXAMTYPE
                                                                .courseExam,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                        "View course exams",
                                                        style: TextStyle(
                                                            color:
                                                                primaryColor)),
                                                    style: customTheme
                                                        .elevatedButtonTheme
                                                        .style!
                                                        .copyWith(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .white)),
                                                  ),
                                                if (isALlModulesCompleted)
                                                  SizedBox(width: 20),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ExamCreation(
                                                          course: widget.course,
                                                          examtype: EXAMTYPE
                                                              .courseExam,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Create course exam",
                                                    style: TextStyle(
                                                        color: primaryColor),
                                                  ),
                                                  style: customTheme
                                                      .elevatedButtonTheme
                                                      .style!
                                                      .copyWith(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all<Color>(
                                                                      Colors
                                                                          .white)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                body: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width >
                                    HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
                                ? MediaQuery.of(context).size.width * 0.5
                                : MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'Course Content',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          Column(
                            children: List.generate(
                                itemCount,
                                (moduleIndex) => Container(
                                      // height: 200,
                                      width: MediaQuery.of(context).size.width >
                                              HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
                                          ? MediaQuery.of(context).size.width *
                                              0.5
                                          : MediaQuery.of(context).size.width,
                                      child: ModuleTile(
                                        course: widget.course,
                                        module:
                                            widget.course.modules[moduleIndex],
                                        isModuleStarted: checkIfModuleStarted(
                                            loggedInState: loggedInState,
                                            module: widget
                                                .course.modules[moduleIndex]),
                                        isModuleCompleted:
                                            checkIfModuleCompleted(
                                                loggedInState: loggedInState,
                                                module: widget.course
                                                    .modules[moduleIndex]),
                                      ),
                                    )),
                          )
                        ],
                      ),
                    )),
              ),
            )
          : Container(
              height: 300,
              child: AlertDialog(
                elevation: 4,
                content: Align(
                    alignment: Alignment.topCenter,
                    child: loadingWidget(
                        textWidget: Text(
                      "Loading modules ...",
                      style: customTheme.textTheme.labelMedium!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ))),
              ),
            ),
      floatingActionButton: userRole == 'admin'
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            //CreateModuleScreen(course: widget.course)));
                            CreateModuleScreenHTML(course: widget.course)));
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
