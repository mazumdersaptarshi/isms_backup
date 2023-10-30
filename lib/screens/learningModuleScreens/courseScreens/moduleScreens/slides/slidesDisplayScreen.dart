import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleExamsListScreen.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/modulesListScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/sharedWidgets/htmlSlideDisplay.dart';
import 'package:provider/provider.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/screens/login/loginScreen.dart';

class SlidesDisplayScreen extends StatefulWidget {
  SlidesDisplayScreen(
      {super.key,
      required this.slides,
      required this.moduleIndex,
      required this.courseIndex});
  List<Slide> slides;
  int courseIndex;
  int moduleIndex;
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

    if (loggedInState.user == null) {
      return LoginPage();
    }

    final isWeb = kIsWeb;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.blueGrey),
        title: const Text(
          'Slides',
          style: TextStyle(color: Colors.blueGrey),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.yellow.shade200,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 500,
                  child: PageView(
                    controller: _pageController,
                    children: cardItems.map((item) {
                      return Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          height: 500,
                          child: ListView(
                            children: [
                              Text(
                                '${item['title']}:',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                              SizedBox(height: 10),
                              HTMLSlideDisplay(htmlString: item['text'])
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (isWeb) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_left,
                          size: 30,
                        ),
                        onPressed: () {
                          if (currentIndex > 0) {
                            _pageController.previousPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_right,
                          size: 30,
                        ),
                        onPressed: () {
                          if (currentIndex < cardItems.length - 1) {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ],
                Visibility(
                  visible: currentIndex == cardItems.length - 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModulesListScreen(
                                    courseIndex: widget.courseIndex,
                                  )));
                      print('Finish button pressed');
                    },
                    child: Text('Finish'),
                  ),
                ),
                Visibility(
                  visible: currentIndex == cardItems.length - 1,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ModuleExamListScreen(
                                    courseIndex: widget.courseIndex,
                                    examtype: EXAMTYPE.moduleExam,
                                    moduleIndex: widget.moduleIndex,
                                  )));
                    },
                    child: Text('Take quiz'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.bottomRight,
                  child: Text(
                    'Slide ${currentIndex + 1} of ${cardItems.length}',
                    style: TextStyle(fontSize: 15, color: Colors.blueGrey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
