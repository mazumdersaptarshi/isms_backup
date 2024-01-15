import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedTileIndex = -1;
  int? _hoveredIndex; // Variable to track the selected tile

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-4nAS8n4lcrd5E82WeVd_6jp3vfAQXPp7sQ&usqp=CAU'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: LinearProgressIndicator(
                    value: 0.5, // Example progress value
                    backgroundColor: Colors.white.withOpacity(0.5),
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Introduction to Document AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildListTile('Section 1', 0),
          SizedBox(height: 20),
          _buildListTile('Section 2', 1),
          SizedBox(height: 20),
          _buildListTile('Section 3', 2),
          SizedBox(height: 20),
          _buildListTile('Section 4', 3),
          SizedBox(height: 20),
          _buildListTile('Section 5', 4),
          // Add more ListTiles if needed
        ],
      ),
    );
  }

  Widget _buildListTile(String title, int index) {
    bool isHovered = _hoveredIndex == index;
    bool isSelected = _selectedTileIndex == index;

    return MouseRegion(
      onEnter: (_) => _setHoveredIndex(index),
      onExit: (_) => _setHoveredIndex(null),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTileIndex = index;
            // Add your navigation logic here if needed
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? Border(left: BorderSide(width: 3.0, color: Colors.blue))
                : null,
            boxShadow: isHovered
                ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 5.0)]
                : [],
          ),
          child: ListTile(
            title: Text(title),
          ),
        ),
      ),
    );
  }

  void _setHoveredIndex(int? index) {
    setState(() {
      _hoveredIndex = index;
    });
  }
}
