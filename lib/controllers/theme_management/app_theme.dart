import 'package:flutter/material.dart';

/// App-wide font family override
const String fontFamily = "Poppins";

/// Set of `MaterialStates` used to apply conditional widget style when being interacted with
const Set<MaterialState> interactiveStates = <MaterialState>{
  MaterialState.pressed,
  MaterialState.hovered,
  MaterialState.focused
};

/// App theme
final ThemeData ismsTheme = _ismsTheme();

/// Returns app theme as `ThemeData`, based on the default light theme with specific widget themes overridden.
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
  );
}

// Functions returning each widget theme type used to override defaults

/// Returns app-wide `TextTheme`.
TextTheme _textTheme(TextTheme base) => base.copyWith(
    displayLarge: base.displayLarge!.copyWith(fontFamily: fontFamily, fontSize: 36, fontWeight: FontWeight.bold),
    displayMedium: base.displayMedium!.copyWith(fontFamily: fontFamily, fontSize: 30, fontWeight: FontWeight.bold),
    displaySmall: base.displaySmall!.copyWith(fontFamily: fontFamily, fontSize: 26, fontWeight: FontWeight.bold),
    headlineLarge: base.headlineLarge!.copyWith(fontFamily: fontFamily),
    headlineMedium: base.headlineMedium!.copyWith(fontFamily: fontFamily),
    headlineSmall: base.headlineSmall!.copyWith(fontFamily: fontFamily),
    titleLarge: base.titleLarge!.copyWith(fontFamily: fontFamily),
    titleMedium: base.titleMedium!.copyWith(fontFamily: fontFamily),
    titleSmall: base.titleSmall!.copyWith(fontFamily: fontFamily),
    bodyLarge: base.bodyLarge!.copyWith(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.normal),
    bodyMedium: base.bodyMedium!.copyWith(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.normal),
    bodySmall: base.bodySmall!.copyWith(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.normal),
    labelLarge: base.labelLarge!.copyWith(fontFamily: fontFamily),
    labelMedium: base.labelMedium!.copyWith(fontFamily: fontFamily),
    labelSmall: base.labelSmall!.copyWith(fontFamily: fontFamily));

/// Returns app-wide `AppBarTheme`.
AppBarTheme _appBarTheme(AppBarTheme base) =>
    base.copyWith(backgroundColor: Colors.deepPurpleAccent.shade100, foregroundColor: Colors.white, elevation: 0);

/// Returns app-wide `CardTheme`.
CardTheme _cardTheme(CardTheme base) => base.copyWith(
      color: Colors.white,
      shadowColor: Colors.black45,
      elevation: 20,
    );

/// Returns app-wide `CheckboxThemeData`.
CheckboxThemeData _checkboxTheme(CheckboxThemeData base) =>
    base.copyWith(checkColor: MaterialStateProperty.all<Color>(Colors.white));

/// Returns app-wide `ElevatedButtonThemeData`.
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

// Functions for conditional widget styling

/// Returns button background colour as `Color` depending on the widget state tracked in [states].
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

/// Returns button foreground colour as `Color` depending on the widget state tracked in [states].
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
