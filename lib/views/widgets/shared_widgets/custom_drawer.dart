import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';

class IsmsDrawer extends StatefulWidget {
  final BuildContext context;

  const IsmsDrawer({required this.context, Key? key}) : super(key: key);

  @override
  _IsmsDrawerState createState() => _IsmsDrawerState();
}

class _IsmsDrawerState extends State<IsmsDrawer> {
  String? _hoveredRoute;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const Border(),
      width: 120,
      child: Container(
        // color: Color.fromRGBO(24, 118, 210, 1),
        color: ThemeConfig.drawerColor,
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, bottom: 10, right: 0, left: 0),
          child: Column(
            children: [
              ..._getDrawerItems(widget.context),
              Expanded(child: Container()),
              _getProfileImage(widget.context),
              // SizedBox(height: 20),
              _getLogoutItem(widget.context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _getDrawerItems(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    final List<Widget> drawerItemWidgets = [];

    drawerItemWidgets.add(
        _getDrawerItem(context, Icons.home_outlined, AppLocalizations.of(context)!.buttonHome, NamedRoutes.home.name));
    drawerItemWidgets.add(_getDrawerItem(context, Icons.menu_book_outlined,
        AppLocalizations.of(context)!.buttonCourseList, NamedRoutes.assignments.name));
    if (loggedInState.currentUserRole == 'admin') {
      drawerItemWidgets.add(_getDrawerItem(context, Icons.admin_panel_settings_outlined,
          AppLocalizations.of(context)!.buttonAdminPanel, NamedRoutes.adminPanel.name));
    }
    drawerItemWidgets.add(_getDrawerItem(
        context, Icons.settings_outlined, AppLocalizations.of(context)!.buttonSettings, NamedRoutes.settings.name));
    return drawerItemWidgets;
  }

  Widget _getDrawerItem(BuildContext context, IconData icon, String label, String route) {
    final bool isHovered = route == _hoveredRoute;
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredRoute = route;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredRoute = null;
        });
      },
      child: InkWell(
        onTap: () {
          context.goNamed(route);
          Navigator.pop(context);
        },
        child: Container(
          width: 120,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Expanded(
            // Wrap InkWell with Expanded
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 25),
                SizedBox(height: 0), // Adjust the spacing between icon and text
                Text(label, style: TextStyle(color: Colors.white, fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLogoutItem(BuildContext context) {
    final bool isHovered = _hoveredRoute == 'logout';
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredRoute = 'logout';
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredRoute = null;
        });
      },
      child: InkWell(
        onTap: () async {
          await LoggedInState.logout().then((value) {
            context.goNamed(NamedRoutes.login.name);
          });
        },
        child: Container(
          width: 120,
          padding: EdgeInsets.only(top: 15, bottom: 15),
          decoration: BoxDecoration(
            color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout_outlined, color: Colors.white, size: 25),
              SizedBox(height: 0),
              Text(AppLocalizations.of(context)!.buttonLogout, style: TextStyle(color: Colors.white, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getProfileImage(BuildContext context) {
    final bool isHovered = _hoveredRoute == 'profile';
    var loggedInUser = Provider.of<LoggedInState>(context, listen: false);
    return MouseRegion(
        onEnter: (_) {
          setState(() {
            _hoveredRoute = 'profile';
          });
        },
        onExit: (_) {
          setState(() {
            _hoveredRoute = null;
          });
        },
        child:
            // Container(
            //   // width: 120,
            //   // height: 120,
            //   // padding: EdgeInsets.only(top: 15, bottom: 15),
            //   decoration: BoxDecoration(
            //     color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
            //     borderRadius: BorderRadius.circular(6),
            //   ),
            //   child: Column(
            //     // mainAxisAlignment: MainAxisAlignment.end,
            //     // crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       IconButton(
            //         alignment: Alignment.centerRight,
            //         onPressed: () => {
            //           context.goNamed(NamedRoutes.adminConsole.name, pathParameters: {'uid': loggedInUser.currentUserUid!})
            //         },
            //         icon: Icon(
            //           Icons.account_circle_outlined,
            //           color: Colors.white,
            //           // weight: 0.1,
            //           // fill: 1,
            //           size: 40,
            //         ),
            //       ),
            //       Text(
            //         '${loggedInUser.currentUserName}',
            //         style: TextStyle(color: ThemeConfig.primaryTextColor, fontSize: 14),
            //         textAlign: TextAlign.center,
            //       ),
            //     ],
            //   ),
            // ),
            InkWell(
          onTap: () async {
            context.goNamed(NamedRoutes.userProfile.name, pathParameters: {'uid': loggedInUser.currentUserUid!});
          },
          child: Container(
            width: 120,
            padding: EdgeInsets.only(top: 15, bottom: 15),
            decoration: BoxDecoration(
              color: isHovered ? Colors.white.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.account_circle_outlined, color: Colors.white, size: 40),
                SizedBox(height: 10),
                Text(
                  loggedInUser.currentUserName!,
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }
}
