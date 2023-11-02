import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/htmlSlideDisplay.dart';
import 'package:isms/sharedWidgets/leaningModulesAppBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:provider/provider.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/screens/login/loginScreen.dart';

import '../../../../../models/module.dart';

class SlidesDisplayScreen extends StatefulWidget {
  SlidesDisplayScreen(
      {super.key,
      required this.slides,
      required this.module,
      required this.course});
  List<Slide> slides;
  Course course;
  Module module;
  @override
  _SlidesDisplayScreenState createState() => _SlidesDisplayScreenState();
}

class _SlidesDisplayScreenState extends State<SlidesDisplayScreen> {
  List<Map<String, dynamic>> cardItems = [];
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> _initializeCardItems() {
    final String commonText =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

    List<Map<String, dynamic>> slidesMap = [];
    widget.slides.forEach((element) {
      slidesMap.add({'title': element.title, 'text': element.content});
    });
    return slidesMap;
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        cardItems = _initializeCardItems();
      });
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

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    return Scaffold(
      appBar: LearningModulesAppBar(
        leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModuleDetails(
                        course: widget.course, module: widget.module)));
          },
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              SlidesContentWidget(
                  pageController: _pageController,
                  cardItems: cardItems,
                  currentIndex: currentIndex),
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
                      child: Text(
                        'Take quiz',
                        style: customTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Visibility(
                    visible: currentIndex == cardItems.length - 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      child: Text(
                        'Back to Home',
                        style: customTheme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
