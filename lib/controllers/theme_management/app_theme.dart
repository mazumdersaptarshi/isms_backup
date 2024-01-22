import 'package:flutter/material.dart';

/// App-wide font family override
const String fontFamily = "Poppins";

/// Set of [MaterialStates] used to apply conditional widget style when being interacted with
const Set<MaterialState> interactiveStates = <MaterialState>{
  MaterialState.pressed,
  MaterialState.hovered,
  MaterialState.focused
};

/// App-wide primary colour
Color primary = Colors.deepPurpleAccent.shade100;

/// App-wide widget [BorderRadius]
BorderRadius borderRadius = BorderRadius.circular(10);

/// App-wide theme
final ThemeData ismsTheme = _ismsTheme();

/// Returns app theme as [ThemeData], based on the default light theme with specific widget themes overridden.
ThemeData _ismsTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: primary,
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
    checkboxTheme: _checkboxTheme(base.checkboxTheme),
    elevatedButtonTheme: _elevatedButtonTheme(base.elevatedButtonTheme),
  );
}

// Private functions returning each widget theme type used to override defaults in app theme

/// Returns app-wide [TextTheme].
///
/// Each individual [TextStyle] from the base theme has at least the property `fontFamily` overridden,
/// with other properties also overridden as needed.
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

/// Returns app-wide [AppBarTheme].
AppBarTheme _appBarTheme(AppBarTheme base) =>
    base.copyWith(backgroundColor: primary, foregroundColor: Colors.white, elevation: 0);

/// Returns app-wide [CheckboxThemeData].
///
/// Property `checkColor` is overridden to be the same for all [MaterialState]s of the widget.
CheckboxThemeData _checkboxTheme(CheckboxThemeData base) =>
    base.copyWith(checkColor: MaterialStateProperty.all<Color>(Colors.white));

/// Returns app-wide [ElevatedButtonThemeData].
///
/// Properties `textStyle` and `shape` are overridden to be the same for all [MaterialState]s of the widget.
/// Properties `backgroundColor` and `foregroundColor` are overridden to update conditionally
/// based on the [MaterialState] of the widget.
ElevatedButtonThemeData _elevatedButtonTheme(ElevatedButtonThemeData base) => ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: MaterialStateProperty.resolveWith(_getButtonBackgroundColor),
        foregroundColor: MaterialStateProperty.resolveWith(_getButtonForegroundColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: borderRadius),
        ),
      ),
    );

// Private functions for conditional widget styling in app theme

/// Returns button background colour as [Color] depending on the [MaterialState] of the widget (tracked in [states]).
Color _getButtonBackgroundColor(Set<MaterialState> states) {
  Color color;

  /// If [states] contains any of the [MaterialState]s defined in [interactiveStates],
  /// then the button is being interacted with.
  if (states.any(interactiveStates.contains)) {
    color = Colors.blue.shade700;
  } else if (states.any((state) => state == MaterialState.disabled)) {
    // Button is disabled
    color = Colors.grey.shade400;
  } else {
    // Default case
    color = primary;
  }

  return color;
}

/// Returns button foreground colour as [Color] depending on the [MaterialState] of the widget (tracked in [states]).
Color _getButtonForegroundColor(Set<MaterialState> states) {
  return states.any((state) => state == MaterialState.disabled) ? Colors.white54 : Colors.white;
}

// Public functions for styling which lives outside the app theme and must be applied on a per-widget basis

/// Returns [BoxDecoration] used for styling [FlipCard]s
BoxDecoration getFlipCardBoxDecoration() {
  return BoxDecoration(
    color: Colors.grey[300],
    borderRadius: borderRadius,
  );
}
