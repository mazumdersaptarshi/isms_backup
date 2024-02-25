import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Assuming these imports are correct and the files exist
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';

class IsmsDrawer extends StatelessWidget {
  final BuildContext? context;

  const IsmsDrawer({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    // Use a theme color from your app's theme or define custom ones
    Color backgroundColor = Colors.grey.shade200;
    Color iconColor = Colors.grey.shade700!;
    Color textColor = Colors.grey.shade700!;
    double _fontSize = 14;

    return Drawer(
      child: Container(
        color: backgroundColor, // Adding a background color to the drawer
        child: ListView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            ..._getDrawerItems(context, iconColor, textColor, _fontSize)
          ],
        ),
      ),
    );
  }

  List<Widget> _getDrawerItems(
      BuildContext context, Color iconColor, Color textColor, double fontSize) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    final List<Widget> drawerItemWidgets = [];

    // Custom drawer header with gradient and improved typography
    // drawerItemWidgets.add(
    //   Container(
    //     padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
    //     decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //         begin: Alignment.topLeft,
    //         end: Alignment.bottomRight,
    //         colors: [Theme.of(context).primaryColor, getPrimaryColorShade(50)!],
    //       ),
    //     ),
    //     child: DrawerHeader(
    //       margin: EdgeInsets.zero,
    //       padding: EdgeInsets.all(16),
    //       child: Text(
    //         "General",
    //         style: TextStyle(
    //             fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    //       ),
    //     ),
    //   ),
    // );
    drawerItemWidgets.add(
      Container(
        padding: const EdgeInsets.all(18),
        child: Text(
          "General",
          textAlign: TextAlign.left,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        ),
      ),
    );
    drawerItemWidgets.add(_getDrawerItem(
        context,
        Icons.home,
        AppLocalizations.of(context)!.buttonHome,
        NamedRoutes.home.name,
        iconColor,
        textColor,
        fontSize));
    drawerItemWidgets.add(_getDrawerItem(
        context,
        Icons.list,
        AppLocalizations.of(context)!.buttonCourseList,
        NamedRoutes.assignments.name,
        iconColor,
        textColor,
        fontSize));
    drawerItemWidgets.add(Divider());
    if (loggedInState.currentUserRole == 'admin') {
      // Admin actions are grouped under a visually distinct header
      drawerItemWidgets.add(
        Container(
          padding: const EdgeInsets.all(18),
          child: Text(
            "Admin Actions",
            textAlign: TextAlign.left,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      );
      drawerItemWidgets.add(_getDrawerItem(
          context,
          Icons.admin_panel_settings_rounded,
          AppLocalizations.of(context)!.buttonAdminConsole,
          NamedRoutes.adminConsole.name,
          iconColor,
          textColor,
          fontSize));
      drawerItemWidgets.add(_getDrawerItem(
          context,
          Icons.people_rounded,
          'All Users',
          NamedRoutes.allUsers.name,
          iconColor,
          textColor,
          fontSize));
    }

    return drawerItemWidgets;
  }

  Widget _getDrawerItem(BuildContext context, IconData icon, String label,
      String route, Color iconColor, Color textColor, double fontSize) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title:
          Text(label, style: TextStyle(color: textColor, fontSize: fontSize)),
      onTap: () {
        context.goNamed(route);
        Navigator.pop(context); // Then close the drawer
      },
    );
  }
}
