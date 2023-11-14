import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../../projectModules/courseManagement/coursesProvider.dart';
import '../../themes/common_theme.dart';
import '../homePageFunctions/getCoursesList.dart';
import '../learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'homePageItemsContainer.dart';

class HomePageMainContent extends StatelessWidget {
  HomePageMainContent(
      {super.key,
      required this.homePageContainerHeight,
      required this.loggedInState,
      required this.coursesProvider});
  double homePageContainerHeight;
  LoggedInState loggedInState;
  CoursesProvider coursesProvider;
  bool hasEnrolledCourses = false;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: homePageContainerHeight,

        // height: 100,
        child: Stack(children: [
          Positioned(
              top: 0,
              child: Container(
                height: homePageContainerHeight,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: primaryColor.shade100,
                ),
              )),
          Positioned(
              top: 100,
              child: Container(
                height: homePageContainerHeight,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(20))),
              )),
          Positioned(
              top: 20,
              child: Container(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: getCoursesListForUser(
                    context: context,
                    loggedInState: loggedInState,
                    coursesProvider: coursesProvider,
                  ),
                  builder:
                      (BuildContext context, AsyncSnapshot<Map>? snapshot) {
                    if (snapshot?.data == null) {
                      return const CircularProgressIndicator();
                    } else {
                      hasEnrolledCourses =
                          snapshot?.data!["hasEnrolledCourses"];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (MediaQuery.of(context).size.width <=
                              SCREEN_COLLAPSE_WIDTH)
                            HomePageLabel(
                                hasEnrolledCourses: hasEnrolledCourses),
                          HomePageItemsContainer(
                              homePageItems: snapshot?.data!["widgetsList"]),
                          if (MediaQuery.of(context).size.width >
                              SCREEN_COLLAPSE_WIDTH)
                            HomePageLabel(
                                hasEnrolledCourses: hasEnrolledCourses)
                        ],
                      );
                    }
                  },
                ),
              )),
        ]));
  }
}

class HomePageLabel extends StatelessWidget {
  HomePageLabel({super.key, required this.hasEnrolledCourses});
  bool hasEnrolledCourses;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.14),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CoursesDisplayScreen()));
          },
          child: Row(
            children: [
              Text(
                  hasEnrolledCourses == true
                      ? "Resume Learning "
                      : "Recommended Courses",
                  style: customTheme.textTheme.labelMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: customTheme.primaryColor)),
              Icon(
                Icons.arrow_circle_right_outlined,
                color: customTheme.primaryColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
