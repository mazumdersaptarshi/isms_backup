// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';

class PlatformCheck {
  static Widget bottomNavBarWidget(LoggedInState? loggedInState,
      {required BuildContext context}) {
    if (kIsWeb) {
      if (MediaQuery.of(context).size.width > HOME_PAGE_WIDGETS_COLLAPSE_WIDTH)
        return Container(height: 1.0);
      else {
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
      if (MediaQuery.of(context).size.width >
          HOME_PAGE_WIDGETS_COLLAPSE_WIDTH) {
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
