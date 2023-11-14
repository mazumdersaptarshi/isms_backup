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
              child: Column(
                // Align children to the start of the cross axis
                children: [
                  FutureBuilder<List<Widget>>(
                    future: getHomePageCoursesList(
                      context: context,
                      loggedInState: loggedInState,
                      coursesProvider: coursesProvider,
                    ),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Widget>>? snapshot) {
                      if (snapshot?.data == null) {
                        return const CircularProgressIndicator();
                      } else {
                        return HomePageItemsContainer(
                            homePageItems: snapshot?.data);
                      }
                    },
                  ),
                ],
              )),
          Positioned(
              top: MediaQuery.of(context).size.width >
                      HOME_PAGE_WIDGETS_COLLAPSE_WIDTH
                  ? 320
                  : 0,
              child: Container(
                margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.14),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CoursesDisplayScreen()));
                    },
                    child: Row(
                      children: [
                        Text("Resume Learning ",
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
              )),
        ]));
  }
}
