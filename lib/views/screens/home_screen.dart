// ignore_for_file: file_names, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
// import 'package:isms/screens/homePageWidgets/homePageMainContent.dart';
// import 'package:isms/screens/login/login_screen.dart';
// import 'package:isms/sharedWidgets/app_footer.dart';
// import 'package:isms/themes/common_theme.dart';
// import 'package:isms/userManagement/logged_in_state.dart';
// import 'package:isms/utilityFunctions/platform_check.dart';
import 'package:provider/provider.dart';

import '../../controllers/course_management/course_provider.dart';
import '../../controllers/theme_management/common_theme.dart';
import '../../controllers/user_management/logged_in_state.dart';
// import '../controllers/themes/common_theme.dart';
// import '../controllers/userManagement/logged_in_state.dart';
// import '../sharedWidgets/app_footer.dart';
import '../../controllers/utility_functions/platform_check.dart';
import '../widgets/shared_widgets/app_footer.dart';
import 'authentication/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userRole;

  @override
  void initState() {
    super.initState();
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

    return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar:
            PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
        appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
        body: FooterView(
          footer: kIsWeb
              ? Footer(
                  backgroundColor: Colors.transparent, child: const AppFooter())
              : Footer(backgroundColor: Colors.transparent, child: Container()),
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
                              "assets/images/security.png",
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
                  child: ElevatedButton(
                    onPressed: () async {
                      String courseId = 'ip78hd';
                      Map<String, dynamic> course = {};
                      //gets Course details by ID from Local storage. For now, we neeed to load this data from
                      //Course Provider, but in the actual implementation this data will be loaded in the memory so we won't have to fetch it from the Provider
                      course = await CourseProvider.getCourseByIDLocal(
                          courseId: courseId);
                      await loggedInState.updateCourseProgress(
                          courseId: courseId,
                          courseName: course['courseName'],
                          completionStatus: 'not_completed',
                          currentSectionId: 'mod1',
                          currentSection:
                              CourseProvider.getCourseSectionByIdLocal(
                                  sectionId: 'mod1',
                                  sections: course['courseSections']));

                      // await LoggedInState.updateUserLocalData();
                    },
                    child: Text('Update courses'),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
