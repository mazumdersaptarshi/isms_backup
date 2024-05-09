import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:restart_app/restart_app.dart';

enum ThemeModes { light, dark }

class ThemeManager extends ChangeNotifier {
  ThemeModes _selectedTheme = ThemeModes.light;

  ThemeModes get selectedTheme => _selectedTheme;

  void changeTheme(ThemeModes mode, BuildContext context) {
    _selectedTheme = mode;
    ThemeConfig.isDarkMode = _selectedTheme == ThemeModes.dark;

    print(_selectedTheme);
    // notifyListeners();
    // Restart.restartApp(webOrigin: '${NamedRoutes.login.name}');

    context.goNamed(
      NamedRoutes.home.name,
    );
  }
}
