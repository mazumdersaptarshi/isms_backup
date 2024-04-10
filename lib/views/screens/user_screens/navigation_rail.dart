import 'package:flutter/material.dart';
import 'package:isms/views/screens/admin_screens/settings_page.dart';
import '../admin_screens/admin_console/all_users_screen.dart';
import '../admin_screens/notification_page.dart';
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
    home: NavigationRailWidget(title: title), // Provide the required title argument
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

  final selectedColor = Colors.white;
  final unselectedColor = Colors.white60;
  final labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  @override
  Widget build(BuildContext context) => Scaffold(
    // appBar: AppBar(
    //   title: Text(widget.title),
    //   leading: Container(
    //     padding: EdgeInsets.only(left: 16.0),
    //     child: IconButton(
    //       icon: Icon(Icons.menu, size: 30),
    //       onPressed: () => setState(() => isExtended = !isExtended),
    //     ),
    //   ),
    // ),
    body: LayoutBuilder(
      builder: (context, constraints) => Row(
        children: [
          NavigationRail(
            backgroundColor: Theme.of(context).primaryColor,
            // labelType: isExtended ? null : NavigationRailLabelType.all,
            selectedIndex: index,
            extended: isExtended,
            selectedLabelTextStyle: labelStyle.copyWith(color: selectedColor),
            unselectedLabelTextStyle: labelStyle.copyWith(color: unselectedColor),
            selectedIconTheme: IconThemeData(color: selectedColor, size: 30),
            unselectedIconTheme: IconThemeData(color: unselectedColor, size: 30),
            onDestinationSelected: (index) => setState(() => this.index = index),
            groupAlignment: -1,
            useIndicator: false,
            leading: IconButton(
              icon: Icon(Icons.menu, size: 30),
              onPressed: () => setState(() => isExtended = !isExtended),
            ),
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list_outlined),
                selectedIcon: Icon(Icons.list),
                label: Text('Course list'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('All users'),
              ),

              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications_none_outlined),
                selectedIcon: Icon(Icons.notifications_active),
                label: Text('Notifications'),
              ),
            ],
          ),
          Expanded(child: buildPages()),
        ],
      ),
    ),
  );

  Widget buildPages() {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return CourseList();
      case 2:
        return AllUsers();
      case 3:
        return SettingsPage();
      case 4:
        return NotificationPage();
      default:
        return HomePage();
    }
  }
}
