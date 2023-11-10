import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/sharedWidgets/navIndexTracker.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import 'homePageFunctions/getCoursesList.dart';
import 'homePageWidgets/homePageItemsContainer.dart';
import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserInfoFetched = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userRole;
  String? initialLink;

  @override
  void initState() {
    super.initState();

    InitLinkHandler.initLinks(context: context);
  }

  // Utility function to check and potentially create the admin document
  Future<void> checkAndCreateUserDocument(
    String uid,
    String currentUserEmail,
    String currentUserName,
  ) async {
    DocumentReference adminDocRef = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(uid);

    bool docExists = await adminDocRef.get().then((doc) => doc.exists);

    if (!docExists) {
      await adminDocRef.set({
        'email': currentUserEmail,
        'name': currentUserName,
        'certifications': [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double homePageContainerHeight = 1300;
    final loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;
    NavIndexTracker.setNavDestination(
        navDestination: NavDestinations.HomePage, userRole: userRole);

    return Consumer<CoursesProvider>(builder:
        (BuildContext context, CoursesProvider coursesProvider, Widget? child) {
      return Scaffold(
          bottomNavigationBar:
              kIsWeb ? null : BottomNavBar(loggedInState: loggedInState),
          appBar: CustomAppBar(
            loggedInState: loggedInState,
          ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 10,
                backgroundColor: primaryColor.shade100,
                automaticallyImplyLeading: false,
                expandedHeight: 200,
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Welcome back, \n${loggedInState.currentUserName}",
                        style: customTheme.textTheme.bodyMedium
                            ?.copyWith(fontSize: 30, color: Colors.white),
                      ),
                      Flexible(
                        flex:
                            1, // The flex factor. You can adjust this number to take more or less space in the Row or Column.
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.13, // 50% of screen width

                          child: Image.asset(
                            "assets/images/security.png",
                            fit: BoxFit
                                .cover, // This will cover the available space, you can change it to BoxFit.contain to prevent the image from being cropped.
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: homePageContainerHeight,
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
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20))),
                          )),
                      Positioned(
                          top: 0,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.14),
                            child: Text("Your courses...",
                                style: customTheme.textTheme.labelMedium!
                                    .copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                          )),
                      Positioned(
                          top: 20,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: FutureBuilder<List<Widget>>(
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
                              )))
                    ])),
              )
            ],
          ));
    });
  }
}
