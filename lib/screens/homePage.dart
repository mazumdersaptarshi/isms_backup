import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/reminderScreen.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/sharedWidgets/navIndexTracker.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

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
    List<Widget> homePageItems = [
      HomePageItem(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoursesDisplayScreen()));
        },
        title: "All Courses",
      ),
      HomePageItem(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminConsolePage()));
        },
        title: "Admin Console",
      ),
      HomePageItem(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ReminderScreen()));
        },
        title: "Set Reminders",
      ),
      HomePageItem(
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AdminConsolePage()));
        },
        title: "Admin Console",
      ),
    ];

    final loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    userRole = loggedInState.currentUserRole;
    NavIndexTracker.setNavDestination(
        navDestination: NavDestinations.HomePage, userRole: userRole);

    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
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
                          top: 20,
                          child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: HomePageItemsContainer(
                                  homePageItems: homePageItems)))
                    ])),
              )
            ],
          ));
    });
  }
}

class HomePageItemsContainer extends StatelessWidget {
  HomePageItemsContainer({super.key, required this.homePageItems});
  List<Widget> homePageItems;
  @override
  Widget build(BuildContext context) {
    double itemContainerWidth = MediaQuery.of(context).size.width * 0.5;
    return MediaQuery.of(context).size.width > 800
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homePageItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return homePageItems[index];
                },
              ),
            ),
          )
        : Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: homePageItems,
            ),
          );
  }
}

class HomePageItem extends StatelessWidget {
  HomePageItem({super.key, required this.onTap, required this.title});
  Function onTap;
  String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      constraints: const BoxConstraints(minWidth: 300),
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Card(
          elevation: 10,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(title),
          ),
        ),
      ),
    );
  }
}
