import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:isms/controllers/language_management/language_manager.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/theme_management/theme_manager.dart';
import 'package:isms/views/widgets/shared_widgets/hoverable_section_container.dart';
import 'package:provider/provider.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  void _changeLanguage(Locale locale) {
    Provider.of<LocaleManager>(context, listen: false).setLocale(locale);
  }

  void _changeTheme(ThemeModes mode) {
    Provider.of<ThemeManager>(context, listen: false).changeTheme(mode, context);
  }

  @override
  Widget build(BuildContext context) {
    return buildSettingsSection(context);
  }

  Widget _buildThemeOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${AppLocalizations.of(context)!.themes}:',
          style: TextStyle(
            fontSize: 18,
            color: ThemeConfig.primaryTextColor,
          ),
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.lightMode, style: TextStyle(color: ThemeConfig.primaryTextColor)),
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
            AppLocalizations.of(context)!.darkMode,
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

  Widget _buildLanguageOptions() {
    LocaleManager localeProvider = Provider.of<LocaleManager>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${AppLocalizations.of(context)!.languageSetting}:',
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
                groupValue: Provider.of<LocaleManager>(context).locale,
                onChanged: (Locale? value) {
                  print("Changing locale to $value");
                  _changeLanguage(Locale('en')); // Make sure this triggers provider update
                },
              ),
              onTap: () {
                print("ListTile tap registered for en");
                _changeLanguage(Locale('en')); // This should also work as expected
              },
            ),
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.localeJapanese,
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              leading: Radio<Locale>(
                value: Locale('ja'),
                groupValue: Provider.of<LocaleManager>(context).locale,
                onChanged: (Locale? value) {
                  print("Changing locale to $value");
                  _changeLanguage(Locale('ja')); // Make sure this triggers provider update
                },
              ),
              onTap: () {
                print("ListTile tap registered for ja");
                _changeLanguage(Locale('ja')); // This should also work as expected
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSettingsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   AppLocalizations.of(context)!.buttonSettings, // Replace with actual property name
          //   style: TextStyle(fontSize: 30, color: Colors.grey.shade600),
          // ),
          // SizedBox(height: 20.0), // Add spacing between title and options
          Expanded(
            child: HoverableSectionContainer(
              onHover: (bool) {},
              cardColor: ThemeConfig.secondaryCardColor,
              child: _buildThemeOptions(),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: HoverableSectionContainer(
              onHover: (bool) {},
              cardColor: ThemeConfig.secondaryCardColor,
              child: _buildLanguageOptions(),
            ),
          ),
        ],
      ),
    );
  }
}
