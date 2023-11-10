// ignore_for_file: constant_identifier_names, file_names

enum NavDestinations { HomePage, UserProfile, AdminConsole, AllCoures }

class NavIndexTracker {
  static int currentIndex = 0;
  static NavDestinations navDestination = NavDestinations.HomePage;

  static setNavDestination(
      {required NavDestinations navDestination, required String userRole}) {
    if (navDestination == NavDestinations.HomePage) {
      currentIndex = 0;
    } else if (navDestination == NavDestinations.UserProfile) {
      currentIndex = 1;
    } else if (navDestination == NavDestinations.AdminConsole) {
      if (userRole == "admin") {
        currentIndex = 2;
      }
    } else if (navDestination == NavDestinations.AllCoures) {
      if (userRole == "admin") {
        currentIndex = 3;
      } else {
        currentIndex = 2;
      }
    }
  }
}
