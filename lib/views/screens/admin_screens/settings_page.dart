import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/theme_management/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key}); // Const constructor

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // ThemeMode _selectedTheme = ThemeMode.light; // Initialize with a default theme
  ThemeModes _selectedThemeMode = ThemeModes.light;
  String _selectedLanguage = 'en'; // Initialize with a default language

  void _changeTheme(ThemeModes mode) {
    Provider.of<ThemeManager>(context, listen: false).changeTheme(mode, context);
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      appBar: IsmsAppBar(context: context),
      // Actual implementation
      // drawer: IsmsDrawer(context: context),
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      // Assuming PlatformCheck is accessible
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
            left: MediaQuery.of(context).size.width * 0.03,
            right: MediaQuery.of(context).size.width * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.buttonSettings, // Replace with actual property name
                style: TextStyle(fontSize: 30, color: Colors.grey.shade600),
              ),
              SizedBox(height: 20.0), // Add spacing between title and options
              _buildThemeOptions(),
              SizedBox(height: 20),
              _buildLanguageOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.themes,
          style: TextStyle(color: ThemeConfig.primaryTextColor),
        ),
        ListTile(
          title: Text(ThemeModes.light.name, style: TextStyle(color: ThemeConfig.primaryTextColor)),
          leading: Radio<ThemeModes>(
            value: ThemeModes.light,
            groupValue: Provider.of<ThemeManager>(context).selectedTheme,
            onChanged: (ThemeModes? value) {
              if (value != null) _changeTheme(value);
            },
          ),
          onTap: () => _changeTheme(ThemeModes.light),
        ),
        ListTile(
          title: Text(
            ThemeModes.dark.name,
            style: TextStyle(color: ThemeConfig.primaryTextColor),
          ),
          leading: Radio<ThemeModes>(
            value: ThemeModes.dark,
            groupValue: Provider.of<ThemeManager>(context).selectedTheme,
            onChanged: (ThemeModes? value) {
              if (value != null) _changeTheme(value);
            },
          ),
          onTap: () => _changeTheme(ThemeModes.dark),
        ),
      ],
    );
  }

  Widget _themeOption(ThemeModes mode) {
    return InkWell(
      onTap: () => _changeTheme(mode),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<ThemeModes>(
              value: mode,
              groupValue: Provider.of<ThemeManager>(context).selectedTheme,
              onChanged: (ThemeModes? value) {
                if (value != null) _changeTheme(value);
              },
            ),
            Text(mode.name,
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeConfig.primaryTextColor,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.languageSetting,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700)),
        Column(
          children: [
            Row(
              children: [
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'en';
                      // Apply the selected language here
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'en',
                        groupValue: _selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLanguage = value!;
                            // Apply the selected language here
                          });
                        },
                      ),
                      Text(AppLocalizations.of(context)!.localeEnglish,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 20),
                InkWell(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = 'ja';
                      // Apply the selected language here
                    });
                  },
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'ja',
                        groupValue: _selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLanguage = value!;
                            // Apply the selected language here
                          });
                        },
                      ),
                      Text(AppLocalizations.of(context)!.localeJapanese,
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
