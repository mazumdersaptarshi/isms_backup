import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'coursedetail.dart';

void main() {
  runApp(Sidebar());
}

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Container(
        color: Colors.transparent,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_circle,
                    size: 100.0,
                    color: Colors.orange,
                  ),
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.person,
              title: 'Name',
            ),
            _buildDrawerItem(
              icon: Icons.book,
              title: 'Courses Enrolled',
            ),
            _buildDrawerItem(
              icon: Icons.settings,
              title: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title}) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
      ),
      onTap: () {
        // Handle the tap for each drawer item here.
      },
    );
  }
}





