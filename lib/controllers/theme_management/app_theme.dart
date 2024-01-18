import 'package:flutter/material.dart';

final ThemeData ismsTheme = _ismsTheme();

ThemeData _ismsTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: Colors.deepPurpleAccent.shade100,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.black,
      tertiary: Colors.orange,
      onTertiary: Colors.black,
      error: Colors.red,
      background: Colors.white,
      onBackground: Colors.red,
    ),
    textTheme: _textTheme(base.textTheme),
    appBarTheme: _appBarTheme(base.appBarTheme),
    cardTheme: _cardTheme(base.cardTheme),
    checkboxTheme: _checkboxTheme(base.checkboxTheme),
    elevatedButtonTheme: _elevatedButtonTheme(base.elevatedButtonTheme),
    radioTheme: _radioTheme(base.radioTheme),
  );
}

TextTheme _textTheme(TextTheme base) => base.copyWith(
      displayLarge: base.displayLarge!.copyWith(fontFamily: "Poppins", fontSize: 36, fontWeight: FontWeight.bold),
      displayMedium: base.displayMedium!.copyWith(fontFamily: "Poppins", fontSize: 30, fontWeight: FontWeight.bold),
      displaySmall: base.displaySmall!.copyWith(fontFamily: "Poppins", fontSize: 26, fontWeight: FontWeight.bold),
      bodyLarge:
          base.bodyLarge!.copyWith(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.normal, height: 1.75),
      bodyMedium: base.bodyMedium!.copyWith(fontFamily: "Poppins", fontSize: 18, fontWeight: FontWeight.normal),
      bodySmall: base.bodyMedium!.copyWith(fontFamily: "Poppins", fontSize: 16, fontWeight: FontWeight.normal),
    );

AppBarTheme _appBarTheme(AppBarTheme base) =>
    base.copyWith(backgroundColor: Colors.deepPurpleAccent.shade100, foregroundColor: Colors.white, elevation: 0);

CardTheme _cardTheme(CardTheme base) => base.copyWith(
      color: Colors.white,
      shadowColor: Colors.black45,
      elevation: 20,
    );

CheckboxThemeData _checkboxTheme(CheckboxThemeData base) =>
    base.copyWith(checkColor: MaterialStateProperty.all<Color>(Colors.white));

ElevatedButtonThemeData _elevatedButtonTheme(ElevatedButtonThemeData base) => ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: MaterialStateProperty.resolveWith(_getButtonBackgroundColor),
        foregroundColor: MaterialStateProperty.resolveWith(_getButtonForegroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );

RadioThemeData _radioTheme(RadioThemeData base) =>
    base.copyWith(fillColor: MaterialStateProperty.resolveWith(_getRadioFillColor));

const Set<MaterialState> interactiveStates = <MaterialState>{
  MaterialState.pressed,
  MaterialState.hovered,
  MaterialState.focused
};

Color _getRadioFillColor(Set<MaterialState> states) {
  return states.any((state) => state == MaterialState.selected) ? Colors.blue : Colors.black;
}

Color _getButtonBackgroundColor(Set<MaterialState> states) {
  Color color;

  if (states.any(interactiveStates.contains)) {
    color = Colors.blue.shade700;
  } else if (states.any((state) => state == MaterialState.disabled)) {
    color = Colors.grey.shade400;
  } else {
    color = Colors.blue;
  }

  return color;
}

Color _getButtonForegroundColor(Set<MaterialState> states) {
  return states.any((state) => state == MaterialState.disabled) ? Colors.white54 : Colors.white;
}

const TextStyle flipCardFrontStyle = TextStyle(
  fontSize: 24,
  color: Colors.black,
);
const TextStyle flipCardBackStyle = TextStyle(
  fontSize: 24,
  color: Colors.black,
);

const TextStyle quizCardQuestionStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.normal,
);
const TextStyle quizCardAnswerStyle = TextStyle(
  fontSize: 16,
  color: Colors.black54,
);

BoxDecoration boxShadowHover() {
  return BoxDecoration(
    color: Colors.grey.shade100,
    boxShadow: const [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 5.0,
        spreadRadius: 1.0,
      ),
    ], // Always have the shadow
  );
}

BoxDecoration boxShadowNoHover() {
  return const BoxDecoration(
    color: Colors.transparent,
    boxShadow: [],
  );
}

const TextStyle expansionTileTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
const TextStyle expansionTileContentStyle = TextStyle(
  fontSize: 16,
  color: Colors.black54,
);
