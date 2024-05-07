import 'package:flutter/cupertino.dart';

class LocaleManager extends ChangeNotifier {
  Locale _locale = Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    // if (!Locale('en').toString().contains(newLocale.languageCode)) return; // Optionally validate locale
    _locale = newLocale;
    print(_locale);
    notifyListeners();
  }
}
