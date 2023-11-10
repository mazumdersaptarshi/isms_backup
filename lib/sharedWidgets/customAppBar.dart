// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/myLearningScreen.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/screens/reminderScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../screens/adminScreens/AdminConsole/adminConsolePage.dart';
import '../screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import '../screens/userInfo/userProfilePage.dart';

mixin CustomAppBarMixin on StatelessWidget {
  final Map<String, ValueNotifier<bool>> _hovering = {
    "Explore": ValueNotifier(false),
    "Reminders": ValueNotifier(false),
    "Account": ValueNotifier(false),
    "Admin": ValueNotifier(false),
    "My Learning": ValueNotifier(false),
  };

  void navigateToUserProfilePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserProfilePage()),
    );
  }

  void navigateToCoursesPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const CoursesDisplayScreen()));
  }

  void navigateToMyLearningPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyLearningScreen()));
  }

  void navigateToRemindersPage(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ReminderScreen()));
  }

  void navigateToAdminConsolePage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AdminConsolePage()));
  }

  Widget appBarItem(
      IconData icon, String title, VoidCallback onTap, double paddingValue) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => hovering[title]!.value = true,
      onExit: (_) => hovering[title]!.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: paddingValue)
              .copyWith(top: 4.0, bottom: 4.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: hovering[title]!,
            builder: (context, isHover, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(isHover ? 1.1 : 1.0),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Use the minimum space required by children
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 22, // Base size for the icon
                      color: Colors.white,
                    ),
                    const SizedBox(height: 1), // Consistent gap
                    Flexible(
                      child: Text(title,
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                          style: customTheme.textTheme.bodyMedium
                              ?.copyWith(fontSize: 10, color: Colors.white)),
                    ),
                    Visibility(
                      maintainAnimation: true,
                      maintainState: true,
                      maintainSize: true,
                      visible: isHover,
                      child: Container(
                        margin: const EdgeInsets.only(top: 2), // Reduced margin
                        height: 2,
                        width: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget homeButtonItem(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      },
      child: const Padding(
        padding: EdgeInsets.only(left: kIsWeb ? 16.0 : 0),
        child: Row(
          children: [
            Icon(Icons.severe_cold_rounded),
            SizedBox(
              width: 10,
            ),
            Text(
              'ISMS',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dividerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(
          vertical: 8), // Adds space above and below the divider

      child: VerticalDivider(
        width: 1, // Width of the divider line
        thickness: 1, // Thickness of the divider line
        color: Colors.white
            .withOpacity(0.5), // Divider color with some transparency
      ),
    );
  }

  Widget logoutButtonItem(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        tooltip: 'Logout',
        onPressed: () async {
          await LoggedInState.logout().then((value) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const LoginPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          });
        },
      ),
    );
  }
}

class CustomAppBarWeb extends StatelessWidget
    with CustomAppBarMixin
    implements PreferredSizeWidget {
  final LoggedInState? loggedInState;
  final double _paddingValue = 20;
  CustomAppBarWeb({super.key, this.loggedInState});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: kIsWeb ? false : true,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: homeButtonItem(context),
      ),
      actions: <Widget>[
        appBarItem(Icons.explore, "Explore",
            () => navigateToCoursesPage(context), _paddingValue),
        appBarItem(Icons.lightbulb, "My Learning",
            () => navigateToMyLearningPage(context), _paddingValue),
        if (loggedInState?.currentUserRole == 'admin')
          appBarItem(Icons.notifications_active_rounded, "Reminders",
              () => navigateToRemindersPage(context), _paddingValue),
        appBarItem(Icons.account_circle, "Account",
            () => navigateToUserProfilePage(context), _paddingValue),
        if (loggedInState?.currentUserRole == 'admin')
          appBarItem(Icons.admin_panel_settings_outlined, "Admin",
              () => navigateToAdminConsolePage(context), _paddingValue),
        dividerItem(),
        logoutButtonItem(context),
      ],
      backgroundColor: Colors.deepPurpleAccent.shade100,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBarMobile extends StatelessWidget
    with CustomAppBarMixin
    implements PreferredSizeWidget {
  final LoggedInState? loggedInState;
  final double _paddingValue = 8;
  CustomAppBarMobile({super.key, this.loggedInState});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: kIsWeb ? false : true,
      title: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: homeButtonItem(context),
      ),
      actions: <Widget>[
        appBarItem(Icons.lightbulb, "My Learning",
            () => navigateToAdminConsolePage(context), _paddingValue),
        if (loggedInState?.currentUserRole == 'admin')
          appBarItem(Icons.notifications_active_rounded, "Reminders",
              () => navigateToRemindersPage(context), _paddingValue),
        if (loggedInState?.currentUserRole == 'admin')
          appBarItem(Icons.admin_panel_settings_outlined, "Admin",
              () => navigateToAdminConsolePage(context), _paddingValue),
        dividerItem(),
        logoutButtonItem(context),
      ],
      backgroundColor: Colors.deepPurpleAccent.shade100,
      elevation: 0,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
