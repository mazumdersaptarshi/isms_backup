import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

/// App-wide font family override
// const String fontFamily = 'Poppins';
const String fontFamily = '';

/// Set of [MaterialStates] used to apply conditional widget style when being interacted with
const Set<MaterialState> interactiveStates = <MaterialState>{
  MaterialState.pressed,
  MaterialState.hovered,
  MaterialState.focused
};

//For now this value is hard coded to 700, we can make it dynamic if needed
///This function returns the Primary color of the App
///It is set to shade 700 for any basic color we choose
Color? get primary => getPrimaryColorShade(700);

//For now the Color is Hard Coded as blue, but a function can be added to make it dynamic
///This function is used to get the shades of the Primary Color all across the app
///Provide the value of Shade in the function to get the color
///The limitation is that It doesn't work well with Accent colors, since they don't have shades
Color? getPrimaryColorShade(int shade) {
  return Colors.blue[shade];
}

LinearGradient? getBarsGradientColor() {
  return LinearGradient(
    colors: [
      getPrimaryColorShade(800)!,
      getPrimaryColorShade(400)!,
      getPrimaryColorShade(200)!,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}

/// App-wide theme
final ThemeData ismsTheme = _ismsTheme();

/// Returns app theme as [ThemeData], based on the default light theme with specific widget themes overridden.
ThemeData _ismsTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
    colorScheme: base.colorScheme.copyWith(
      primary: getPrimaryColorShade(700),
      onPrimary: Colors.white,
      secondary: getPrimaryColorShade(700),
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
    drawerTheme: _drawerTheme(base.drawerTheme),
    elevatedButtonTheme: _elevatedButtonTheme(base.elevatedButtonTheme),
    expansionTileTheme: _expansionTileTheme(base.expansionTileTheme),
    iconButtonTheme: _iconButtonTheme(base.iconButtonTheme),
    listTileTheme: _listTileTheme(base.listTileTheme),
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

/// Returns app-wide [DrawerThemeData].
DrawerThemeData _drawerTheme(DrawerThemeData base) =>
    base.copyWith(shape: const ContinuousRectangleBorder(), scrimColor: Colors.black26, width: 350);

/// Returns app-wide [ElevatedButtonThemeData].
///
/// Properties `textStyle` and `shape` are overridden to be the same for all [MaterialState]s of the widget.
/// Properties `backgroundColor` and `foregroundColor` are overridden to update conditionally
/// based on the [MaterialState] of the widget.
ElevatedButtonThemeData _elevatedButtonTheme(ElevatedButtonThemeData base) => ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: const MaterialStatePropertyAll(0),
        textStyle: const MaterialStatePropertyAll(TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: MaterialStateProperty.resolveWith(_getButtonBackgroundColor),
        foregroundColor: MaterialStateProperty.resolveWith(_getButtonForegroundColor),
        shape: MaterialStatePropertyAll(
          getRoundedRectangleBorder(),
        ),
      ),
    );

/// Returns app-wide [ExpansionTileThemeData].
ExpansionTileThemeData _expansionTileTheme(ExpansionTileThemeData base) => ExpansionTileThemeData(
      // backgroundColor: getPrimaryColor(),
      // collapsedBackgroundColor: Colors.grey[300],

      iconColor: primary,
      collapsedIconColor: Colors.black,
      // textColor: Colors.white,
      // collapsedTextColor: Colors.black,
      shape: getRoundedRectangleBorder(),
      collapsedShape: getRoundedRectangleBorder(),
    );

/// Returns app-wide [IconButtonThemeData].
IconButtonThemeData _iconButtonTheme(IconButtonThemeData base) => const IconButtonThemeData(
        style: ButtonStyle(
      iconSize: MaterialStatePropertyAll(30),
      foregroundColor: MaterialStatePropertyAll(Colors.white),
      // tapTargetSize: MaterialTapTargetSize.padded
    ));

/// Returns app-wide [ListTileThemeData].
ListTileThemeData _listTileTheme(ListTileThemeData base) => const ListTileThemeData(
    // textColor: Colors.black
    );

CustomDropdownDecoration get customDropdownDecoration => CustomDropdownDecoration(
    closedFillColor: Colors.grey.shade100,
    expandedFillColor: Colors.white,
    closedBorder: Border.all(color: Colors.grey.shade200, width: 1),
    expandedBorder: Border.all(
      color: getPrimaryColorShade(50)!,
      width: 2,
    ),
    listItemStyle: TextStyle(
      color: primary,
      fontSize: 14,
    ),
    headerStyle: TextStyle(
      fontSize: 14,
      color: primary,
    ));

// Private functions for conditional widget styling in app theme

/// Returns button background [Color] depending on the [MaterialState] of the widget (tracked in [states]).
Color _getButtonBackgroundColor(Set<MaterialState> states) {
  Color color;

  /// If [states] contains any of the [MaterialState]s defined in [interactiveStates],
  /// then the button is being interacted with.
  if (states.any(interactiveStates.contains)) {
    color = getPrimaryColorShade(700)!;
  } else if (states.any((state) => state == MaterialState.disabled)) {
    // Button is disabled
    color = Colors.grey.shade400;
  } else {
    // Default case
    color = primary!;
  }

  return color;
}

/// Returns button foreground [Color] depending on the [MaterialState] of the widget (tracked in [states]).
Color _getButtonForegroundColor(Set<MaterialState> states) {
  return states.any((state) => state == MaterialState.disabled) ? Colors.white54 : Colors.white;
}

// Public functions for styling which either lives outside the app theme or
// otherwise needs to be accessible globally to be applied on a per-widget basis

/// Returns app-wide primary [Color]

/// Returns app-wide secondary [Color]

Color getTertiaryColor1() {
  return Colors.grey.shade300;
}

Color getSecondaryTextColor() {
  return Colors.grey.shade500;
}

Color getTertiaryTextColor1() {
  return Colors.grey.shade700;
}

/// Returns app-wide widget [BorderRadius]
BorderRadius _getBorderRadius() {
  return BorderRadius.circular(5);
}

/// Returns [BoxDecoration] used for styling [ExpansionTile]s
BoxDecoration getExpansionTileBoxDecoration() {
  return BoxDecoration(color: primary, borderRadius: _getBorderRadius(), boxShadow: [getTileBoxShadow()]);
}

/// Returns [BoxShadow] used for styling [ExpansionTile]s and [ListTile]s
BoxShadow getTileBoxShadow() {
  return const BoxShadow(
    color: Colors.black38,
    spreadRadius: 1.5,
    blurRadius: 1.5,
    offset: Offset(0, 1.5),
  );
}

/// Returns [BoxShadow] used for styling [Icon]s when drawn on top of widgets with poorly contrasting colours
BoxShadow getIconBoxShadow() {
  return const BoxShadow(
    color: Colors.black,
    blurRadius: 2.5,
  );
}

/// Returns [ButtonStyle] used for styling [IconButton]s by removing on hover and on select colours
/// to hide the fact that they are separate widgets
ButtonStyle getIconButtonStyleTransparent() {
  return const ButtonStyle(overlayColor: MaterialStatePropertyAll(Colors.transparent));
}

/// Returns [BoxDecoration] used for styling [FlipCard]s
BoxDecoration getFlipCardBoxDecorationFront() {
  return BoxDecoration(
    color: Colors.grey[100],
    borderRadius: _getBorderRadius(),
  );
}

/// Returns app-wide widget [RoundedRectangleBorder]
RoundedRectangleBorder getRoundedRectangleBorder() {
  return RoundedRectangleBorder(borderRadius: _getBorderRadius());
}

BoxDecoration getFlipCardBoxDecorationBack() {
  return BoxDecoration(
    color: Colors.grey[200],
    borderRadius: _getBorderRadius(),
    border: Border.all(color: primary!, width: 3), // Blue border added for flipped state
  );
}

BoxDecoration expansionTileOff() {
  return BoxDecoration(
    color: Colors.grey[300],
  );
}

BoxDecoration expansionTileOn() {
  return BoxDecoration(
      color: Colors.grey[300], border: Border(left: BorderSide(width: 3.0, color: Colors.deepPurpleAccent.shade100)));
}

TextStyle bulletPointSymbolStyle = TextStyle(
  fontSize: 20,
  height: 1.75,
  color: primary,
);

TextStyle bulletPointTextStyle = TextStyle(
  fontSize: 1.7 * 10, // 1.7rem
  fontWeight: FontWeight.w400,
  height: 1.75,
);
