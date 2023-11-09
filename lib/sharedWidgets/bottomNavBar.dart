// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/sharedWidgets/navIndexTracker.dart';
import 'package:isms/themes/common_theme.dart';

import '../screens/adminScreens/AdminConsole/adminConsolePage.dart';
import '../screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import '../screens/userInfo/userProfilePage.dart';
import '../userManagement/loggedInState.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, this.loggedInState});
  // final int selectedIndex;
  final LoggedInState? loggedInState;
  @override
  Widget build(BuildContext context) {
    void navigateToUserProfilePage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserProfilePage()),
      );
    }

    void navigateToHomePage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    }

    void navigateToCoursesPage() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CoursesDisplayScreen()));
    }

    void navigateToAdminConsolePage() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AdminConsolePage()));
    }

    void decideNavigation({required int index}) {
      if (index == NavIndexTracker.currentIndex) {
        // print(
        //     "INDEX: $index, NAVINDEXTRACKER INDEX ${NavIndexTracker.currentIndex}");

        return;
      }
      if (index == 0) {
        navigateToHomePage();
      }
      if (loggedInState?.currentUserRole == 'admin') {
        if (index == 1) {
          navigateToUserProfilePage();
        } else if (index == 2) {
          navigateToAdminConsolePage();
        } else if (index == 3) {
          navigateToCoursesPage();
        }
      } else {
        if (index == 1) {
          navigateToUserProfilePage();
        } else if (index == 2) {
          navigateToCoursesPage();
        }
      }
    }

    return Container(
      decoration: const BoxDecoration(
        //Here goes the same radius, u can put into a var or function
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10)),
        color: Colors.transparent,
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0x14000000),
        //     spreadRadius: 0,
        //     blurRadius: 10,
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons
                  .account_circle_outlined), // Fallback icon if no image is available
              label: 'Account',
            ),
            if (loggedInState?.currentUserRole == 'admin')
              const BottomNavigationBarItem(
                icon: Icon(Icons
                    .admin_panel_settings_outlined), // Fallback icon if no image is available
                label: 'Admin Console',
              ),
            const BottomNavigationBarItem(
              icon:
                  Icon(Icons.explore), // Fallback icon if no image is available
              label: 'Explore',
            ),
          ],

          // currentIndex: selectedIndex,
          selectedItemColor: Colors.white,
          backgroundColor: primaryColor.shade100,
          unselectedItemColor: const Color.fromARGB(255, 234, 234, 234),
          type: BottomNavigationBarType.fixed,
          elevation: 5,
          onTap: (int index) {
            decideNavigation(index: index);
          },
          selectedLabelStyle: const TextStyle(
            fontSize: 12, // Adjust the font size here for selected label
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12, // Adjust the font size here for unselected label
          ),

// This will be set when a new tab is tapped
        ),
      ),
    );
  }
}
