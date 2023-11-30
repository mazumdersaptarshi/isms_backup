// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/sharedWidgets/loadingScreenWidget.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import '../modulesListScreen.dart';

class SlidesDisplayScreen extends StatefulWidget {
  const SlidesDisplayScreen(
      {super.key, required this.module, required this.course});
  final Course course;
  final Module module;

  @override
  State<SlidesDisplayScreen> createState() => _SlidesDisplayScreenState();
}

class _SlidesDisplayScreenState extends State<SlidesDisplayScreen> {
  late SlidesDataMaster slidesDataMaster;
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> _initializeCardItems(List<Slide> slides) {
    List<Map<String, dynamic>> slidesMap = [];
    for (var element in slides) {
      slidesMap.add({'title': element.title, 'text': element.content});
    }
    return slidesMap;
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _pageController.addListener(() {
        setState(() {
          currentIndex = _pageController.page!.round();
        });
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);

    slidesDataMaster = SlidesDataMaster(
        course: widget.course,
        coursesProvider: coursesProvider,
        module: widget.module);

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Slide>>(
          future: slidesDataMaster.slides,
          builder: (BuildContext context, AsyncSnapshot<List<Slide>> snapshot) {
            if (snapshot.hasData) {
              List<Slide> slides = snapshot.data!;
              List<Map<String, dynamic>> cardItems =
                  _initializeCardItems(slides);

              return Column(
                children: [
                  SlidesContentWidget(
                      pageController: _pageController,
                      cardItems: cardItems,
                      currentIndex: currentIndex),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: currentIndex == cardItems.length - 1,
                        child: ElevatedButton(
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
                          child: const Text(
                            'Take exams',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Visibility(
                        visible: currentIndex == cardItems.length - 1,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                          },
                          child: const Text(
                            'Back to Home',
                          ),
                        ),
                      ),
                      if (loggedInState.currentCourseModule[1]['currentModule']
                              ['examsCount'] ==
                          0)
                        const SizedBox(width: 20),
                      Visibility(
                        visible: currentIndex == cardItems.length - 1,
                        child: ElevatedButton(
                            onPressed: () async {
                              print('test');
                              loggedInState.setUserCourseModuleCompleted(
                                  coursesProvider: coursesProvider,
                                  course: widget.course,
                                  module: widget.module);
                              if (widget.course != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CoursePage(
                                            course: widget.course!)));
                              }
                            },
                            child: Text('Mark Module as Completed')),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: 300,
                child: AlertDialog(
                  elevation: 4,
                  content: Align(
                      alignment: Alignment.topCenter,
                      child: loadingErrorWidget(
                          textWidget: Text(
                        "error loading slides",
                        style: customTheme.textTheme.labelMedium!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ))),
                ),
              );
            } else {
              return SizedBox(
                height: 300,
                child: AlertDialog(
                  elevation: 4,
                  content: Align(
                      alignment: Alignment.topCenter,
                      child: loadingWidget(
                          textWidget: Text(
                        "Loading slides ...",
                        style: customTheme.textTheme.labelMedium!.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ))),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
