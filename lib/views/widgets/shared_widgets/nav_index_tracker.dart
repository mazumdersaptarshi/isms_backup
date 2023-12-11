// ignore_for_file: constant_identifier_names, file_names

enum NavDestinations {
  HomePage,
  UserProfile,
  AdminConsole,
  AllCourses,
  MyLearning,
  other,
}

class NavIndexTracker {
  static int currentIndex = 0;
  static NavDestinations navDestination = NavDestinations.HomePage;

  static setNavDestination({required NavDestinations navDestination}) {
    if (navDestination == NavDestinations.HomePage) {
      currentIndex = 0;
    } else if (navDestination == NavDestinations.UserProfile) {
      currentIndex = 1;
    } else if (navDestination == NavDestinations.MyLearning) {
      currentIndex = 2;
    } else if (navDestination == NavDestinations.AllCourses) {
      currentIndex = 3;
    } else if (navDestination == NavDestinations.other) {
      currentIndex = -1;
    }
  }
}
