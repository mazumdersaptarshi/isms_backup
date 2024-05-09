import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationExtension on AppLocalizations {
  String? getLocalizedString(String key) {
    var _map = <String, String Function()>{
      // Continue adding all other keys here...
      'avgScore': () => avgScore,
      'maxScore': () => maxScore,
      'minScore': () => minScore,
      'numberOfAttempts': () => noOfAttempts,
      'enable': () => enable,
      'disable': () => disable,
      'january': () => january,
      'february': () => february,
      'march': () => march,
      'april': () => april,
      'may': () => may,
      'june': () => june,
      'july': () => july,
      'august': () => august,
      'september': () => september,
      'october': () => october,
      'november': () => november,
      'december': () => december,
    };

    var result = _map[key];
    return result != null ? result() : null;
  }
}
