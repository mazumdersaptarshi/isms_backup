import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/screens/reminderScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../screens/adminScreens/AdminConsole/adminConsolePage.dart';
import '../screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import '../screens/userInfo/userProfilePage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar({super.key, this.loggedInState});
  LoggedInState? loggedInState;
  final Map<String, ValueNotifier<bool>> _hovering = {
    "Explore": ValueNotifier(false),
    "Reminders": ValueNotifier(false),
    "Account": ValueNotifier(false),
    "Admin": ValueNotifier(false),
  };

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    void navigateToUserProfilePage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserProfilePage()),
      );
    }

    void navigateToCoursesPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => CoursesDisplayScreen()));
    }

    void navigateToRemindersPage() {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ReminderScreen()));
    }

    void navigateToAdminConsolePage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminConsolePage()));
    }

    return AppBar(
      automaticallyImplyLeading: kIsWeb ? false : true,
      title: const Padding(
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
      actions: <Widget>[
        if (kIsWeb) appBarItem(Icons.explore, "Explore", navigateToCoursesPage),
        if (kIsWeb)
          appBarItem(
              Icons.lightbulb_outline, "Reminders", navigateToRemindersPage),
        if (kIsWeb)
          appBarItem(
              Icons.account_circle, "Account", navigateToUserProfilePage),
        if (loggedInState?.currentUserRole == 'admin' && kIsWeb)
          appBarItem(Icons.admin_panel_settings_outlined, "Admin",
              navigateToAdminConsolePage),
        Container(
          margin: const EdgeInsets.symmetric(
              vertical: 8), // Adds space above and below the divider

          child: VerticalDivider(
            width: 1, // Width of the divider line
            thickness: 1, // Thickness of the divider line
            color: Colors.white
                .withOpacity(0.5), // Divider color with some transparency
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await LoggedInState.logout().then((value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              });
            },
          ),
        ),
      ],
      backgroundColor: Colors.deepPurpleAccent.shade100,
      elevation: 0,
    );
  }

  Widget appBarItem(IconData icon, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _hovering[title]!.value = true,
      onExit: (_) => _hovering[title]!.value = false,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0)
              .copyWith(top: 4.0, bottom: 4.0),
          child: ValueListenableBuilder<bool>(
            valueListenable: _hovering[title]!,
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
                    const SizedBox(height: 4), // Consistent gap
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
}
