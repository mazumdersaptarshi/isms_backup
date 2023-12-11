// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SideNavigationBar extends StatefulWidget {
  const SideNavigationBar({super.key});

  @override
  State<SideNavigationBar> createState() => _SideNavigationBarState();
}

class _SideNavigationBarState extends State<SideNavigationBar> {
  int _selectedIndex = 0;
  final bool _extended = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: _extended
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.selected,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.favorite_border),
                selectedIcon: Icon(Icons.favorite),
                label: Text('Favorites'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bookmark_border),
                selectedIcon: Icon(Icons.book),
                label: Text('Bookmarks'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.star_border),
                selectedIcon: Icon(Icons.star),
                label: Text('Stars'),
              ),
              // Add other destinations here
            ],
            extended: _extended,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // This is the main content area
          Expanded(
            child: Center(
              child: Text('Selected Index: $_selectedIndex'),
            ),
          ),
        ],
      ),
    );
  }
}
