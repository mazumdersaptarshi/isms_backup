import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a theme color from your app's theme or define custom ones
    Color iconColor = Colors.grey.shade700!;
    double iconSize = 24; // Adjust icon size as needed

    return Container(
      width: 50.0, // Set sidebar width to 50 points
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          children: [
            _getSidebarItem(context, Icons.home, 'Home', iconColor, iconSize),
            _getSidebarItem(
                context, Icons.list, 'Course List', iconColor, iconSize),
            // Add more sidebar items here following the same pattern
            _getSidebarItem(context, Icons.settings, 'Settings', iconColor, iconSize),
          ],
        ),
      ),
    );
  }

  Widget _getSidebarItem(
      BuildContext context, IconData icon, String tooltipText, Color iconColor, double iconSize) {
    return Tooltip(
      message: tooltipText,
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: iconSize),
        // Handle onPressed event as needed (navigation, etc.)
        onPressed: () {
          // Add your functionality here
        },
      ),
    );
  }
}
