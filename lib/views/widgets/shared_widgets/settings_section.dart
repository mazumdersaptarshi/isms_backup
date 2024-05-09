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
        Row(
          children: [
            Icon(
              Icons.color_lens_outlined,
              color: ThemeConfig.primaryTextColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              '${AppLocalizations.of(context)!.themes}:',
              style: TextStyle(
                fontSize: 18,
                color: ThemeConfig.primaryTextColor,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.lightMode, style: TextStyle(color: ThemeConfig.primaryTextColor)),
          leading: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: ThemeConfig.primaryTextColor, // Color for unselected state
            ),
            child: Radio<ThemeModes>(
              value: ThemeModes.light,
              groupValue: Provider
                  .of<ThemeManager>(context)
                  .selectedTheme,
              onChanged: (ThemeModes? value) {
                if (value != null) _changeTheme(value);
              },
            ),
          ),
          onTap: () => _changeTheme(ThemeModes.light),
        ),
        ListTile(
          title: Text(
            AppLocalizations.of(context)!.darkMode,
            style: TextStyle(color: ThemeConfig.primaryTextColor),
          ),
          leading: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor: ThemeConfig.primaryTextColor, // Color for unselected state
            ),
            child: Radio<ThemeModes>(
              // fillColor: MaterialStateProperty.all(Colors.red),
              value: ThemeModes.dark,
              groupValue: Provider
                  .of<ThemeManager>(context)
                  .selectedTheme,
              onChanged: (ThemeModes? value) {
                if (value != null) _changeTheme(value);
              },
            ),
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
        Row(
          children: [
            Icon(Icons.language_outlined, color: ThemeConfig.primaryTextColor),
            SizedBox(
              width: 10,
            ),
            Text('${AppLocalizations.of(context)!.languageSetting}:',
                style: TextStyle(fontSize: 18, color: ThemeConfig.primaryTextColor)),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Column(
          children: [
            ListTile(
              title: Text(
                // AppLocalizations.of(context)!.localeEnglish,
                'English - EN',
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              leading: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: ThemeConfig.primaryTextColor, // Color for unselected state
                ),
                child: Radio<Locale>(
                  value: Locale('en'),
                  groupValue: Provider
                      .of<LocaleManager>(context)
                      .locale,
                  onChanged: (Locale? value) {
                    print("Changing locale to $value");
                    _changeLanguage(Locale('en')); // Make sure this triggers provider update
                  },
                ),
              ),
              onTap: () {
                print("ListTile tap registered for en");
                _changeLanguage(Locale('en')); // This should also work as expected
              },
            ),
            ListTile(
              title: Text(
                // AppLocalizations.of(context)!.localeJapanese,
                '日本語 - JA',
                style: TextStyle(color: ThemeConfig.primaryTextColor),
              ),
              leading: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: ThemeConfig.primaryTextColor, // Color for unselected state
                ),
                child: Radio<Locale>(
                  value: Locale('ja'),
                  groupValue: Provider
                      .of<LocaleManager>(context)
                      .locale,
                  onChanged: (Locale? value) {
                    print("Changing locale to $value");
                    _changeLanguage(Locale('ja')); // Make sure this triggers provider update
                  },
                ),
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
      child: HoverableSectionContainer(
        onHover: (bool) {},
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   AppLocalizations.of(context)!.buttonSettings, // Replace with actual property name
              //   style: TextStyle(fontSize: 30, color: Colors.grey.shade600),
              // ),
              // SizedBox(height: 20.0), // Add spacing between title and options
              _buildThemeOptions(),
              Divider(
                thickness: 1,
                color: ThemeConfig.borderColor2,
              ),
              SizedBox(height: 20),
              _buildLanguageOptions(),
            ],
          ),
        ),
      ),
    );
  }
}
