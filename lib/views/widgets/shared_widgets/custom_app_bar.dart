import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/admin_screens/admin_console/admin_panel.dart';
import 'package:isms/views/screens/admin_screens/admin_console/users_analytics_stats_screen.dart';
import 'package:isms/views/screens/course_page.dart';
import 'package:isms/views/screens/testing/test_runner.dart';
import 'package:isms/views/screens/testing/test_ui_type1/user_test_responses.dart';
import 'package:isms/views/screens/user_screens/notification_page.dart';

import '../../screens/user_screens/settings_page.dart';

class IsmsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext? context;
  final double _paddingValue = 20;

  const IsmsAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ThemeConfig.primaryColor,
      title: _getTitle(context),
      centerTitle: false,
      actions: [..._getActionWidgets(context)],
    );
  }

  List<Widget> _getActionWidgets(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    final List<Widget> actionWidgets = [];

    /// ↓↓↓ To be removed ///

    // actionWidgets.add(_getActionIconButton(context, Icons.list, AppLocalizations.of(context)!.buttonCourseList,
    //     () => context.goNamed(NamedRoutes.assignments.name)));
    //
    // actionWidgets.add(_getActionIconButton(context, Icons.track_changes, AppLocalizations.of(context)!.buttonTracking,
    //     () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TestRunner()))));

    // actionWidgets.add(_getActionIconButton(
    //     context,
    //     Icons.notifications,
    //     AppLocalizations.of(context)!.buttonNotificationPage,
    //     () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()))));
    // actionWidgets.add(_getActionIconButton(
    //     context,
    //     Icons.analytics_rounded,
    //     "Users Analytics",
    //     () => Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (context) => const UsersAnalyticsStatsScreen()))));
    // actionWidgets.add(_getActionIconButton(context, Icons.people_outline_rounded, "All Users",
    //     () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllUsers()))));
    //
    // if (loggedInState.currentUserRole == 'admin') {
    //   actionWidgets.add(_getActionIconButton(context, Icons.admin_panel_settings_rounded,
    //       AppLocalizations.of(context)!.buttonAdminConsole, () => context.goNamed(NamedRoutes.adminConsole.name)));
    // }

    /// ↑↑↑ To be removed ///

    actionWidgets.add(_getActionIconButton(
        context,
        Icons.notifications,
        AppLocalizations.of(context)!.buttonNotificationPage,
        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()))));

    actionWidgets.add(_getActionIconButton(context, Icons.settings, AppLocalizations.of(context)!.buttonSettings,
        () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))));

    actionWidgets.add(_getVerticalDivider());
    actionWidgets.add(_getLogoutButton(context));

    return actionWidgets;
  }

  Widget _getActionIconButton(BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: onPressed,
        style: Theme.of(context).iconButtonTheme.style,
      ),
    );
  }

  Widget _getTitle(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTap: () => context.goNamed(NamedRoutes.home.name),
            child: Row(
              children: [
                Icon(Icons.severe_cold_rounded),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  'ISMS Manager',
                  style: TextStyle(
                    // fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    // color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ],
            )));
  }

  Widget _getLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        tooltip: AppLocalizations.of(context)!.buttonLogout,
        onPressed: () async {
          await LoggedInState.logout().then((value) {
            context.goNamed(NamedRoutes.login.name);
          });
        },
        style: Theme.of(context).iconButtonTheme.style,
      ),
    );
  }

  Widget _getVerticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const VerticalDivider(
        thickness: 2,
        color: Colors.white60,
      ),
    );
  }
}
