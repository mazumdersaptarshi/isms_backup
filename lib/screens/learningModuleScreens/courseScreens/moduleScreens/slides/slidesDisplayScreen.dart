// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../../../models/module.dart';
import '../../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../../utilityFunctions/platformCheck.dart';

class SlidesDisplayScreen extends StatefulWidget {
  const SlidesDisplayScreen(
      {super.key,
      required this.module,
      required this.course,
      required this.slidesDataMaster});
  final Course course;
  final Module module;
  final SlidesDataMaster slidesDataMaster;

  @override
  State<SlidesDisplayScreen> createState() => _SlidesDisplayScreenState();
}

class _SlidesDisplayScreenState extends State<SlidesDisplayScreen> {
  List<Map<String, dynamic>> cardItems = [];
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);
  bool isSlidesFetched = false;
  bool isSlidesListEmpty = false;

  List<Map<String, dynamic>> _initializeCardItems() {
    List<Map<String, dynamic>> slidesMap = [];
    if (!isSlidesListEmpty) {
      for (var element in widget.module.slides!) {
        slidesMap.add({'title': element.title, 'text': element.content});
      }
    }
    return slidesMap;
  }

  fetchSlidesList({required CoursesProvider coursesProvider}) async {
    await widget.slidesDataMaster.fetchSlides();
    cardItems = _initializeCardItems();
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

    if (isSlidesFetched == false) {
      fetchSlidesList(coursesProvider: coursesProvider);
    }

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(
        loggedInState,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        child: isSlidesFetched
            ? Column(
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
                    ],
                  ),
                ],
              )
            : const AlertDialog(
                title: Text("Fetching slides"),
                content: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
