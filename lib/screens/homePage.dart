// ignore_for_file: file_names, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/screens/homePageWidgets/homePageMainContent.dart';
import 'package:isms/sharedWidgets/appFooter.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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
    double homePageContainerHeight =
        MediaQuery.of(context).size.width < SCREEN_COLLAPSE_WIDTH ? 1050 : 400;
    // 500;
    final loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;

    return Consumer<CoursesProvider>(builder:
        (BuildContext context, CoursesProvider coursesProvider, Widget? child) {
      return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar:
              PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
          appBar:
              PlatformCheck.topNavBarWidget(loggedInState, context: context),
          body: FooterView(
            footer: kIsWeb
                ? Footer(
                    backgroundColor: Colors.transparent,
                    child: const AppFooter())
                : Footer(
                    backgroundColor: Colors.transparent, child: Container()),
            children: [
              CustomScrollView(
                physics: const ClampingScrollPhysics(),
                shrinkWrap: true,
                slivers: [
                  SliverAppBar(
                    elevation: 10,
                    // backgroundColor: Colors.green,
                    automaticallyImplyLeading: false,
                    expandedHeight: 280,
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
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.2, // 50% of screen width

                              child: Image.asset(
                                "assets/images/security2.png",
                                fit: BoxFit
                                    .contain, // This will cover the available space, you can change it to BoxFit.contain to prevent the image from being cropped.
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HomePageMainContent(
                      coursesProvider: coursesProvider,
                      homePageContainerHeight: homePageContainerHeight,
                    ),
                  )
                ],
              )
            ],
          ));
    });
  }
}
