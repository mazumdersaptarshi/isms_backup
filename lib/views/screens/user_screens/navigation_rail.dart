import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import '../admin_screens/admin_console/all_users_screen.dart';
import 'package:isms/views/screens/admin_screens/notification_page.dart';
import 'package:isms/views/screens/admin_screens/settings_page.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import '../course_list.dart';
import '../home_screen.dart';

void main() => runApp(NavigationRailPage());

class NavigationRailPage extends StatelessWidget {
  static final String title = 'NavigationRail Example';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primaryColor: Colors.black),
        home: NavigationRailWidget(title: title),
      );
}

class NavigationRailWidget extends StatefulWidget {
  final String title;

  const NavigationRailWidget({
    required this.title,
  });

  @override
  _NavigationRailWidgetState createState() => _NavigationRailWidgetState();
}

class _NavigationRailWidgetState extends State<NavigationRailWidget> {
  int index = 0;
  bool isExtended = false;

  final selectedColor = Colors.grey[800];
  final unselectedColor = Colors.grey[600];
  final labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
  final Color iconColor = Colors.white;
  final Color textColor = Colors.white;
  final double fontSize = 16.0;

  @override
  Widget build(BuildContext context) => Scaffold(
        // appBar: IsmsAppBar(context: context),
        body: LayoutBuilder(
          builder: (context, constraints) => Row(
            children: [
              Stack(
                children: [
                  NavigationRail(
                    backgroundColor: Colors.grey[50],
                    // labelType: isExtended ? null : NavigationRailLabelType.all,
                    selectedIndex: index,
                    extended: isExtended,
                    selectedLabelTextStyle: labelStyle.copyWith(color: selectedColor),
                    unselectedLabelTextStyle: labelStyle.copyWith(color: unselectedColor),
                    selectedIconTheme: IconThemeData(color: selectedColor, size: 25),
                    unselectedIconTheme: IconThemeData(color: unselectedColor, size: 25),
                    onDestinationSelected: (index) => setState(() => this.index = index),
                    useIndicator: true,
                    indicatorColor: Colors.grey[300],
                    destinations: _buildDestinations(),
                    leading: isExtended
                        ? Row(
                            mainAxisSize: MainAxisSize.min, // Set MainAxisSize
                            children: [
                              IconButton(
                                icon: Icon(Icons.menu, size: 30, color: unselectedColor),
                                onPressed: () => setState(() => isExtended = !isExtended),
                              ),
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.buttonMenu,
                                  style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 16.0, color: unselectedColor),
                                ),
                                onPressed: () => setState(() => isExtended = !isExtended),
                              ),
                            ],
                          )
                        : IconButton(
                            icon: Icon(Icons.menu, size: 30, color: unselectedColor),
                            onPressed: () => setState(() => isExtended = !isExtended),
                          ),
                  ),
                  Positioned(
                    bottom: 20.0,
                    left: 20.0,
                    child: isExtended
                        ? InkWell(
                      onTap: () async {
                        await LoggedInState.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Allow Row to shrink
                        children: [
                          IconButton(
                            icon: Icon(Icons.logout, color: unselectedColor), // Use unselectedColor
                            onPressed: () async {
                            },
                          ),
                          Text(
                            AppLocalizations.of(context)!.buttonLogout,
                            style: labelStyle.copyWith(color: unselectedColor), // Use unselectedColor
                          ),
                        ],
                      ),
                    )
                        : IconButton(
                      icon: Icon(Icons.logout, color: unselectedColor), // Use unselectedColor
                      onPressed: () async {
                        await LoggedInState.logout();
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                          ),
                  ),
                ],
              ),
              Expanded(child: buildPages()),
            ],
          ),
        ),
      );

  // Define destinations for NavigationRail
  List<NavigationRailDestination> _buildDestinations() => [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text(AppLocalizations.of(context)!.buttonHome),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.list),
          label: Text(AppLocalizations.of(context)!.buttonCourseList),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text(AppLocalizations.of(context)!.buttonSettings),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.supervisor_account),
          label: Text(AppLocalizations.of(context)!.buttonAdminConsole),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.notifications),
          label: Text(AppLocalizations.of(context)!.buttonNotificationPage),
        ),
      ];

  Widget buildPages() {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return CourseList();
      case 2:
        return SettingsPage();
      case 3:
        return AllUsers();
      case 4:
        return NotificationPage();
      default:
        return NavigationRailWidget(
          title: "title",
        );
    }
  }
}
