// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../views/widgets/shared_widgets/bottom_nav_bar.dart';
import '../views/widgets/shared_widgets/custom_app_bar.dart';
import '../controllers/theme_management/common_theme.dart';
// import '../userManagement/logged_in_state.dart';
import '../controllers/user_management/logged_in_state.dart';

// import 'package:isms/sharedWidgets/bottom_nav_bar.dart';
// import 'package:isms/sharedWidgets/custom_app_bar.dart';

// import '../controllers/themes/common_theme.dart';
// import '../controllers/userManagement/logged_in_state.dart';
// // import '../views/sharedWidgets/bottom_nav_bar.dart';
// // import '../views/sharedWidgets/custom_app_bar.dart';
// import '../views/widgets/sharedWidgets/bottom_nav_bar.dart';
// import '../views/widgets/sharedWidgets/custom_app_bar.dart';

class PlatformCheck {
  static Widget bottomNavBarWidget(LoggedInState? loggedInState,
      {required BuildContext context}) {
    if (kIsWeb) {
      if (MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH) {
        return Container(height: 1.0);
      } else {
        return BottomNavBar(
          loggedInState: loggedInState,
        );
      }
    } else {
      return BottomNavBar(
        loggedInState: loggedInState,
      );
    }
  }

  static PreferredSizeWidget topNavBarWidget(LoggedInState loggedInState,
      {required BuildContext context}) {
    if (kIsWeb) {
      if (MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH) {
        return CustomAppBarWeb(
          loggedInState: loggedInState,
        );
      } else {
        return CustomAppBarMobile(
          loggedInState: loggedInState,
        );
      }
    } else {
      return CustomAppBarMobile(
        loggedInState: loggedInState,
      );
    }
  }
}
