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
import '../../../../../projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';

import '../../../../../models/module.dart';
import '../../../../../sharedWidgets/customAppBar.dart';

class SlidesDisplayScreen extends StatefulWidget {
  SlidesDisplayScreen(
      {super.key,
      required this.module,
      required this.course});
  Course course;
  Module module;
  late SlidesDataMaster slidesDataMaster;

  @override
  _SlidesDisplayScreenState createState() => _SlidesDisplayScreenState();
}

class _SlidesDisplayScreenState extends State<SlidesDisplayScreen> {
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  List<Map<String, dynamic>> _initializeCardItems(List<Slide> slides) {
    List<Map<String, dynamic>> slidesMap = [];
    slides.forEach((element) {
      slidesMap.add({'title': element.title, 'text': element.content});
    });
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

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    CoursesProvider coursesProvider =
      Provider.of<CoursesProvider>(context);

    widget.slidesDataMaster = SlidesDataMaster(
        course: widget.course,
        coursesProvider: coursesProvider,
        module: widget.module);

    return Scaffold(
      appBar: CustomAppBar(
        loggedInState: loggedInState,
      ),

      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: FutureBuilder<List<Slide>>(
          future: widget.slidesDataMaster.slides,
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
                  SizedBox(height: 20),
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
                            'Take exams',
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return AlertDialog(
                title: Text("Error fetching module exams"),
                content: Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                ),
              );
            } else {
              return AlertDialog(
                title: Text("Fetching slides"),
                content: Align(
                    alignment: Alignment.topCenter,
                    child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}
