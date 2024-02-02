import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/course_page.dart';
import 'package:isms/views/screens/testing/test_runner.dart';
import 'package:isms/views/screens/testing/test_ui_type1/graphs.dart';
import 'package:provider/provider.dart';

class IsmsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext? context;
  final double _paddingValue = 20;

  const IsmsAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () => context.goNamed(NamedRoutes.home.name),
      ),
      centerTitle: true,
      actions: [..._getActionWidgets(context)],
    );
  }

  List<Widget> _getActionWidgets(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    List<Widget> actionWidgets = [];

    actionWidgets.add(_getActionIconButton(
        Icons.list,
        AppLocalizations.of(context)!.appBarButtonCourseList,
        () => context.goNamed(NamedRoutes.courses.name)));
    actionWidgets.add(_getActionIconButton(
        Icons.article,
        "Course Test",
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CoursePage()))));
    actionWidgets.add(_getActionIconButton(
        Icons.bar_chart,
        "Graphs",
        () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => GraphsPage()))));
    actionWidgets.add(_getActionIconButton(
        Icons.track_changes,
        "Tracking",
        () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TestRunner()))));
    if (loggedInState.currentUserRole == 'admin') {
      actionWidgets.add(_getActionIconButton(
          Icons.admin_panel_settings_rounded,
          AppLocalizations.of(context)!.appBarButtonAdminConsole,
          () => context.goNamed(NamedRoutes.adminConsole.name)));
    }
    actionWidgets.add(_getVerticalDivider());
    actionWidgets.add(_getLogoutButton(context));

    return actionWidgets;
  }

  Widget _getLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        tooltip: AppLocalizations.of(context)!.appBarButtonLogout,
        onPressed: () async {
          await LoggedInState.logout().then((value) {
            context.goNamed(NamedRoutes.login.name);
          });
        },
      ),
    );
  }

  Widget _getVerticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: Colors.white.withOpacity(0.5),
      ),
    );
  }

  Widget _getActionIconButton(
      IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}
// mixin CustomAppBarMixin on StatelessWidget {
//   final Map<String, ValueNotifier<bool>> hovering = {
//     "My Courses": ValueNotifier(false),
//     "Course Test": ValueNotifier(false),
//     "Notifications": ValueNotifier(false),
//     "Reminders": ValueNotifier(false),
//     "Account": ValueNotifier(false),
//     "Admin Console": ValueNotifier(false),
//     "Tracking": ValueNotifier(false),
//     "Admin Center": ValueNotifier(false),
//     "Graphs": ValueNotifier(false)
//   };
//
//   void navigateToUserProfilePage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const UserProfilePage()),
//     );
//   }
//
//   void navigateToCourseListPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CourseList()),
//     );
//   }
//
//   void navigateToCourseTestPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const CoursePage()),
//     );
//   }
//
//   void navigateToRemindersPage(
//       BuildContext context, LoggedInState loggedInState) async {
//     String userRole = loggedInState.currentUserRole;
//     if (userRole == "admin") {
//       await checkAndCreateUserDocument(
//         loggedInState.currentUserUid!,
//         loggedInState.currentUserEmail!,
//         loggedInState.currentUserName!,
//       );
//     }
//     if (!context.mounted) return;
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => const ReminderScreen()));
//   }
//
//   void navigateToAdminCenterPage(BuildContext context) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => const AdminUserDetailsScreen()));
//   }
//
//   void navigateToTimedRemindersPage(BuildContext context) {
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => const TimedRemindersScreen()));
//   }
//
//   void navigateToGraphsPage(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const GraphsPage()),
//     );
//   }
//
//   void navigateToTrackingPage(BuildContext context) {
//     Navigator.push(
//         context, MaterialPageRoute(builder: (context) => const TestRunner()));
//   }
//
//   Widget appBarItem(
//       IconData icon, String title, VoidCallback onTap, double paddingValue) {
//     return MouseRegion(
//       cursor: SystemMouseCursors.click,
//       onEnter: (_) => hovering[title]!.value = true,
//       onExit: (_) => hovering[title]!.value = false,
//       child: GestureDetector(
//         onTap: onTap,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: paddingValue)
//               .copyWith(top: 4.0, bottom: 4.0),
//           child: ValueListenableBuilder<bool>(
//             valueListenable: hovering[title]!,
//             builder: (context, isHover, child) {
//               return AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 curve: Curves.easeInOut,
//                 transform: Matrix4.identity()..scale(isHover ? 1.1 : 1.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   // Use the minimum space required by children
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Icon(
//                       icon,
//                       size: 22, // Base size for the icon
//                       color: Colors.white,
//                     ),
//                     const SizedBox(height: 1), // Consistent gap
//                     Flexible(
//                       child: Text(title,
//                           overflow: TextOverflow.ellipsis, // Prevent overflow
//                           style: customTheme.textTheme.bodyMedium
//                               ?.copyWith(fontSize: 10, color: Colors.white)),
//                     ),
//                     Visibility(
//                       maintainAnimation: true,
//                       maintainState: true,
//                       maintainSize: true,
//                       visible: isHover,
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 2), // Reduced margin
//                         height: 2,
//                         width: 30,
//                         color: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget homeButtonItem(BuildContext context, {bool displayText = true}) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).pushReplacement(
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondaryAnimation) =>
//                 const HomePage(),
//             transitionsBuilder:
//                 (context, animation, secondaryAnimation, child) {
//               return FadeTransition(
//                 opacity: animation,
//                 child: child,
//               );
//             },
//             transitionDuration: const Duration(milliseconds: 500),
//           ),
//         );
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(left: kIsWeb ? 16.0 : 0),
//         child: Row(
//           children: [
//             const Icon(Icons.severe_cold_rounded),
//             if (displayText == true)
//               const SizedBox(
//                 width: 10,
//               ),
//             if (displayText == true)
//               const Text(
//                 'ISMS',
//                 style: TextStyle(
//                   fontFamily: 'Montserrat',
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontSize: 24,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget dividerItem() {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       // Adds space above and below the divider
//
//       child: VerticalDivider(
//         width: 1, // Width of the divider line
//         thickness: 1, // Thickness of the divider line
//         color: Colors.white
//             .withOpacity(0.5), // Divider color with some transparency
//       ),
//     );
//   }
//
//   Widget logoutButtonItem(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16.0),
//       child: IconButton(
//         icon: const Icon(Icons.logout),
//         tooltip: 'Logout',
//         onPressed: () async {
//           await LoggedInState.logout().then((value) {
//             Navigator.of(context).pushReplacement(
//               PageRouteBuilder(
//                 pageBuilder: (context, animation, secondaryAnimation) =>
//                     const LoginPage(),
//                 transitionsBuilder:
//                     (context, animation, secondaryAnimation, child) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: child,
//                   );
//                 },
//                 transitionDuration: const Duration(milliseconds: 500),
//               ),
//             );
//           });
//         },
//       ),
//     );
//   }
// }
//
// class CustomAppBarWeb extends StatelessWidget
//     with CustomAppBarMixin
//     implements PreferredSizeWidget {
//   final LoggedInState? loggedInState;
//   final double _paddingValue = 20;
//
//   CustomAppBarWeb({super.key, this.loggedInState});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       title: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH
//             ? homeButtonItem(context)
//             : homeButtonItem(context, displayText: false),
//       ),
//       actions: <Widget>[
//         appBarItem(Icons.list, "My Courses",
//             () => navigateToCourseListPage(context), _paddingValue),
//         appBarItem(Icons.article, "Course Test",
//             () => navigateToCourseTestPage(context), _paddingValue),
//         appBarItem(Icons.track_changes, "Tracking",
//             () => navigateToTrackingPage(context), _paddingValue),
//         appBarItem(Icons.bar_chart, "Graphs",
//             () => navigateToGraphsPage(context), _paddingValue),
//         appBarItem(Icons.admin_panel_settings_rounded, "Admin Center",
//             () => navigateToAdminCenterPage(context), _paddingValue),
//         if (loggedInState?.currentUserRole == 'admin')
//           appBarItem(
//               Icons.notifications_active_rounded,
//               "Notifications",
//               () => navigateToRemindersPage(context, loggedInState!),
//               _paddingValue),
//         appBarItem(Icons.account_circle, "Account",
//             () => navigateToUserProfilePage(context), _paddingValue),
//         if (loggedInState?.currentUserRole == 'admin')
//           appBarItem(Icons.admin_panel_settings_outlined, "Admin Console",
//               () => navigateToAdminCenterPage(context), _paddingValue),
//         if (loggedInState?.currentUserRole == 'admin')
//           appBarItem(Icons.timer_outlined, "Reminders",
//               () => navigateToTimedRemindersPage(context), _paddingValue),
//         dividerItem(),
//         logoutButtonItem(context),
//       ],
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
//
// class CustomAppBarMobile extends StatelessWidget
//     with CustomAppBarMixin
//     implements PreferredSizeWidget {
//   final LoggedInState? loggedInState;
//   final double _paddingValue = 8;
//
//   CustomAppBarMobile({super.key, this.loggedInState});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       automaticallyImplyLeading: true,
//       title: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: homeButtonItem(context, displayText: false),
//       ),
//       actions: <Widget>[
//         if (loggedInState?.currentUserRole == 'admin')
//           appBarItem(Icons.admin_panel_settings_outlined, "Admin Console",
//               () => navigateToAdminCenterPage(context), _paddingValue),
//         if (loggedInState?.currentUserRole == 'admin')
//           appBarItem(
//               Icons.notifications_active_rounded,
//               "Reminders",
//               () => navigateToRemindersPage(context, loggedInState!),
//               _paddingValue),
//         dividerItem(),
//         logoutButtonItem(context),
//       ],
//     );
//   }
//
//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
