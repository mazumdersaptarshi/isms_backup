import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/admin_screens/admin_console/users_analytics_stats_screen.dart';
import 'package:isms/views/screens/course_page.dart';
import 'package:isms/views/screens/testing/test_runner.dart';
import 'package:isms/views/screens/testing/test_ui_type1/graphs.dart';

class IsmsDrawer extends StatelessWidget {
  final BuildContext? context;

  const IsmsDrawer({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        physics: const ClampingScrollPhysics(),
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [..._getDrawerItems(context)],
      ),
    );
  }

  List<Widget> _getDrawerItems(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    final List<Widget> drawerItemWidgets = [];

    drawerItemWidgets.add(_getDrawerHeader(context, "General"));
    drawerItemWidgets
        .add(_getDrawerItem(context, Icons.home, AppLocalizations.of(context)!.buttonHome, NamedRoutes.home.name));
    drawerItemWidgets.add(_getDrawerItem(
        context, Icons.list, AppLocalizations.of(context)!.buttonCourseList, NamedRoutes.assignments.name));
    if (loggedInState.currentUserRole == 'admin') {
      drawerItemWidgets.add(_getDrawerHeader(context, "Admin Actions"));
      drawerItemWidgets.add(_getDrawerItem(context, Icons.admin_panel_settings_rounded,
          AppLocalizations.of(context)!.buttonAdminConsole, NamedRoutes.adminConsole.name));
    }

    return drawerItemWidgets;
  }

  Widget _getDrawerHeader(BuildContext context, String label) {
    return SizedBox(
      height: 65,
      child: DrawerHeader(
        decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.primary,
          color: getPrimaryColorShade(600),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _getDrawerItem(BuildContext context, IconData icon, String label, String route) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        context.goNamed(route);
        // Then close the drawer
        Navigator.pop(context);
      },
    );
  }
}
