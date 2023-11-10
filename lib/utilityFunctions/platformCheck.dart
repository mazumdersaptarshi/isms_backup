import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';

class PlatformCheck {
  static Widget bottomNavBarWidget(LoggedInState? loggedInState) {
    if (kIsWeb)
      return Container(height: 1.0);
    else
      return BottomNavBar(
        loggedInState: loggedInState,
      );
  }

  static PreferredSizeWidget topNavBarWidget(
    LoggedInState loggedInState,
  ) {
    if (kIsWeb)
      return CustomAppBarWeb(
        loggedInState: loggedInState,
      );
    else
      return CustomAppBarMobile(
        loggedInState: loggedInState,
      );
  }
}