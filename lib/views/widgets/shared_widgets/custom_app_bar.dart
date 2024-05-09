import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:isms/views/screens/home_screen.dart';
import 'package:isms/views/screens/admin_screens/settings_page.dart';
import 'package:isms/views/screens/admin_screens/notification_page.dart';

class IsmsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final BuildContext? context;
  final double _paddingValue = 20;

  const IsmsAppBar({super.key, required this.context});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: ThemeConfig.primaryTextColor),
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      title: _buildTitleWithSearch(context),
      centerTitle: true,
      actions: [..._getActionWidgets(context)],
    );
  }

  Widget _buildTitleWithSearch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Row(
            children: [
              Icon(
                Icons.severe_cold_rounded,
                color: ThemeConfig.primaryTextColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'ISMS Manager',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: ThemeConfig.primaryTextColor,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              height: 40,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.20 < 300 ? MediaQuery
                  .of(context)
                  .size
                  .width * 0.20 : 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: ThemeConfig.primaryCardColor,
                boxShadow: [
                  BoxShadow(
                    color: ThemeConfig.hoverShadowColor!,
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppLocalizations.of(context)!.searchHint,
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16.0),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                ),
                style: TextStyle(color: Colors.black, fontSize: 16), // Input text color
              ),
            ),
          ),
        ),
        // Placeholder to balance the title position
        Opacity(
          opacity: 0,
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  Icons.severe_cold_rounded,
                  color: ThemeConfig.primaryTextColor,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'ISMS Manager',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: ThemeConfig.primaryTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _getActionWidgets(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();
    final List<Widget> actionWidgets = [];

    actionWidgets.add(_getActionIconButton(
        context,
        Icons.notifications,
        AppLocalizations.of(context)!.buttonNotificationPage,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()))));

    // actionWidgets.add(_getActionIconButton(context, Icons.settings, AppLocalizations.of(context)!.buttonSettings,
    //         () => context.goNamed(NamedRoutes.settings.name)));

    actionWidgets.add(_getVerticalDivider());
    actionWidgets.add(_getLogoutButton(context));

    return actionWidgets;
  }

  Widget _getActionIconButton(BuildContext context, IconData icon, String tooltip, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: IconButton(
        icon: Icon(icon),
        tooltip: tooltip,
        onPressed: onPressed,
        style: Theme
            .of(context)
            .iconButtonTheme
            .style,
      ),
    );
  }

  Widget _getLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: IconButton(
        icon: const Icon(Icons.logout),
        tooltip: AppLocalizations.of(context)!.buttonLogout,
        onPressed: () async {
          await LoggedInState.logout().then((value) {
            context.goNamed(NamedRoutes.login.name);
          });
        },
        style: Theme
            .of(context)
            .iconButtonTheme
            .style,
      ),
    );
  }

  Widget _getVerticalDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: const VerticalDivider(
        thickness: 2,
        color: Colors.white60,
      ),
    );
  }
}
