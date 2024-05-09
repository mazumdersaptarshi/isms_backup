import 'package:flutter/material.dart';
import 'package:isms/controllers/language_management/language_manager.dart';
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
      drawer: IsmsDrawer(context: context),
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: buildSettingsSection(context),
    );
  }

  Widget buildSettingsSection(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: 20.0,
          bottom: 20.0,
          left: MediaQuery
              .of(context)
              .size
              .width * 0.03,
          right: MediaQuery
              .of(context)
              .size
              .width * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.buttonSettings,
              style: TextStyle(fontSize: 30, color: ThemeConfig.primaryTextColor),
            ),
            SizedBox(height: 20.0),
            _buildThemeOptions(),
            SizedBox(height: 20),
            _buildLanguageOptions(),
          ],
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
          style: TextStyle(color: ThemeConfig.primaryTextColor, fontSize: 18,),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.lightMode, style: TextStyle(color: ThemeConfig.primaryTextColor)),
          leading: Radio<ThemeModes>(
            value: ThemeModes.light,
            fillColor: MaterialStateProperty.all<Color>(ThemeConfig.primaryTextColor),
            groupValue: Provider
                .of<ThemeManager>(context)
                .selectedTheme,
            onChanged: (ThemeModes? value) {
              if (value != null) _changeTheme(value);
            },
          ),
          onTap: () => _changeTheme(ThemeModes.light),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.darkMode,
            style: TextStyle(color: ThemeConfig.primaryTextColor),
          ),
          leading: Radio<ThemeModes>(
            value: ThemeModes.dark,
            fillColor: MaterialStateProperty.all<Color>(ThemeConfig.primaryTextColor),
            groupValue: Provider
                .of<ThemeManager>(context)
                .selectedTheme,
            onChanged: (ThemeModes? value) {
              if (value != null) _changeTheme(value);
            },
          ),
          onTap: () => _changeTheme(ThemeModes.dark),
        ),
      ],
    );
  }

  void _changeLanguage(Locale locale) {
    Provider.of<LocaleManager>(context, listen: false).setLocale(locale);
  }

  Widget _buildLanguageOptions() {
    LocaleManager localeProvider = Provider.of<LocaleManager>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.languageSetting,
            style: TextStyle(fontSize: 18, color: ThemeConfig.primaryTextColor)),
        Column(
          children: [
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.localeEnglish,
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              leading: Radio<Locale>(
                value: Locale('en'),
                fillColor: MaterialStateProperty.all<Color>(ThemeConfig.primaryTextColor),
                groupValue: Provider
                    .of<LocaleManager>(context)
                    .locale,
                onChanged: (Locale? value) {
                  print("Changing locale to $value");
                  _changeLanguage(Locale('en'));
                },
              ),
              onTap: () {
                print("ListTile tap registered for en");
                _changeLanguage(Locale('en'));
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.localeJapanese,
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              leading: Radio<Locale>(
                value: Locale('ja'),
                fillColor: MaterialStateProperty.all<Color>(ThemeConfig.primaryTextColor),
                groupValue: Provider
                    .of<LocaleManager>(context)
                    .locale,
                onChanged: (Locale? value) {
                  print("Changing locale to $value");
                  _changeLanguage(Locale('ja'));
                },
              ),
              onTap: () {
                print("ListTile tap registered for ja");
                _changeLanguage(Locale('ja'));
              },
            ),
          ],
        ),
      ],
    );
  }

// Widget _buildLanguageOption(
//     LocaleManager localeProvider, String languageCode, String languageText, BuildContext context) {
//   return ListTile(
//     title: Text(languageText),
//     leading: Radio<String>(
//       value: languageCode,
//       groupValue: localeProvider.locale.languageCode,
//       onChanged: (String? value) {
//         print("Changing locale to $value");
//         localeProvider.setLocale(Locale(value!)); // Make sure this triggers provider update
//       },
//     ),
//     onTap: () {
//       print("ListTile tap registered for $languageCode");
//       localeProvider.setLocale(Locale(languageCode)); // This should also work as expected
//     },
//   );
// }
}
