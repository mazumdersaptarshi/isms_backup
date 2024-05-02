import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/course_management/course_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/models/course/user_assigned_course_overview.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/widgets/course_widgets/carousel.dart';
import 'package:isms/views/widgets/shared_widgets/build_section_header.dart';
import 'package:isms/views/widgets/shared_widgets/custom_linear_progress_indicator.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

// import '../widgets/course_widgets/carousel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserAssignedCourseOverview> _assignedCourses = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _fetchAssignedCourses();
    });
  }

  void _fetchAssignedCourses() async {
    var loggedInUserId = Provider.of<LoggedInState>(context, listen: false).currentUserUid;
    var fetchedAssignedCourses = await CourseProvider.fetchAssignedCoursesOverviewData(loggedInUserId: loggedInUserId!);
    setState(() {
      _assignedCourses = fetchedAssignedCourses;
    });
  }

  // Utility function to check and potentially create the admin document
  Future<void> checkAndCreateUserDocument(
    String uid,
    String currentUserEmail,
    String currentUserName,
  ) async {
    DocumentReference adminDocRef =
        FirebaseFirestore.instance.collection('adminconsole').doc('allAdmins').collection('admins').doc(uid);

    bool docExists = await adminDocRef.get().then((doc) => doc.exists);

    if (!docExists) {
      await adminDocRef.set({
        'email': currentUserEmail,
        'name': currentUserName,
        'certifications': [],
      });
    }
  }

  // Define the courseTitle list

  @override
  Widget build(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: Container(
        padding: EdgeInsets.all(10),
        height: 300, // Set a fixed height for the horizontal ListView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionHeader(title: 'My Courses'),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Set ListView to scroll horizontally
                itemCount: _assignedCourses.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  UserAssignedCourseOverview course = _assignedCourses[index];
                  return Container(
                    width: 400,
                    margin: EdgeInsets.all(10),
                    child: HoverableSectionContainer(
                      onHover: (bool) {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course.courseTitle,
                                  style: TextStyle(color: ThemeConfig.primaryTextColor),
                                ),
                                SizedBox(height: 10),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    // Using LayoutBuilder to dynamically adjust the child width
                                    return Container(
                                      // Set the width to 50% of the available space
                                      width: constraints.maxWidth * 0.7,
                                      child: CustomLinearProgressIndicator(
                                        value: (course.completedSections?.length ?? 0) / course.courseSections.length,
                                        backgroundColor: ThemeConfig.percentageIconBackgroundFillColor!,
                                        valueColor: ThemeConfig.primaryColor!,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                course.completedSections!.length > 0
                                    ? ElevatedButton(
                                        onPressed: () => context.goNamed(
                                              NamedRoutes.course.name,
                                              pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId},
                                            ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 13),
                                          child: Text(AppLocalizations.of(context)!.buttonResumeCourse,
                                              style: TextStyle(color: ThemeConfig.secondaryTextColor)),
                                        ),
                                        style: ThemeConfig.elevatedBoxButtonStyle())
                                    : ElevatedButton(
                                        onPressed: () => context.goNamed(
                                              NamedRoutes.course.name,
                                              pathParameters: {NamedRoutePathParameters.courseId.name: course.courseId},
                                            ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 13),
                                          child: Text(AppLocalizations.of(context)!.buttonStartCourse,
                                              style: TextStyle(color: ThemeConfig.secondaryTextColor)),
                                        ),
                                        style: ThemeConfig.elevatedBoxButtonStyle())
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
