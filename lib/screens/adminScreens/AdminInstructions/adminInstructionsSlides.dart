// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class AdminInstructionSlides extends StatefulWidget {
  const AdminInstructionSlides(
      {super.key,
      required this.adminProvider,
      required this.category,
      required this.subCategory});
  final String category;
  final String subCategory;
  final AdminProvider adminProvider;

  @override
  State<AdminInstructionSlides> createState() => _AdminInstructionSlidesState();
}

class _AdminInstructionSlidesState extends State<AdminInstructionSlides> {
  List<dynamic>? slides; // Declare the slides variable here
  List<Map<String, dynamic>> cardItems = [];
  int currentIndex = 0;
  final PageController _pageController = PageController(initialPage: 0);

  Future<List?> fetchSlidesList(
      AdminProvider adminProvider, String category, String subCategory) async {
    var fetchedSlides = await adminProvider.fetchAdminInstructionsFromFirestore(
        category, subCategory);
    debugPrint('slidessdcd: $fetchedSlides');
    return fetchedSlides;
  }

  List<Map<String, dynamic>> _initializeCardItems(List<dynamic>? slides) {
    List<Map<String, dynamic>> slidesMap = [];
    if (slides != null) {
      for (var element in slides) {
        slidesMap.add({'title': element['title'], 'text': element['content']});
      }
    }
    return slidesMap;
  }

  @override
  void initState() {
    super.initState();
    fetchSlidesList(widget.adminProvider, widget.category, widget.subCategory)
        .then((value) {
      setState(() {
        slides = value;
        cardItems = _initializeCardItems(slides); // Initialize cardItems here
      });
      if (mounted) {
        _pageController.addListener(() {
          setState(() {
            currentIndex = _pageController.page!.round();
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    return Scaffold(
        appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
        body: slides != null
            ? Column(
                children: [
                  SlidesContentWidget(
                    pageController: _pageController,
                    cardItems: cardItems, // Use cardItems here
                    currentIndex: currentIndex,
                  ),
                  // Add other UI elements if needed
                ],
              )
            : const CircularProgressIndicator(),
        bottomNavigationBar:
            PlatformCheck.bottomNavBarWidget(loggedInState, context: context));
  }
}
