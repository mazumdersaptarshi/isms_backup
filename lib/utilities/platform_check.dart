import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

import 'package:isms/views/widgets/shared_widgets/bottom_nav_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';

class PlatformCheck {
  static Widget bottomNavBarWidget(LoggedInState? loggedInState, {required BuildContext context}) {
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

  static PreferredSizeWidget topNavBarWidget(BuildContext context, LoggedInState loggedInState) {
    late PreferredSizeWidget appBar;

    if (kIsWeb) {
      if (MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH) {
        appBar = IsmsAppBar(context: context);
        //   } else {
        //     return CustomAppBarMobile(
        //       loggedInState: loggedInState,
        //     );
        //   }
        // } else {
        //   return CustomAppBarMobile(
        //     loggedInState: loggedInState,
        //   );
      }
    }

    return appBar;
  }
}
