import 'package:flutter/material.dart';

class ThemeConfig {
  static bool isDarkMode = false;

  // static ThemeData ismsTheme = isDarkMode ? _ismsThemeDark() : _ismsThemeLight();
  static Color get scaffoldBackgroundColor => isDarkMode ? Color(0xFF0A1521) : Colors.grey.shade50;

  static ThemeData _ismsThemeLight() {
    final ThemeData base = ThemeData.light();

    return base.copyWith(
      colorScheme: base.colorScheme,
      scaffoldBackgroundColor: Colors.grey.shade50,
    );
  }

  static ThemeData _ismsThemeDark() {
    final ThemeData base = ThemeData.dark();
    // Setup dark theme color scheme
    // ColorScheme darkScheme = const ColorScheme.dark().copyWith(
    //   primary: Colors.blueGrey[950],
    //   onPrimary: Colors.white,
    //   // Additional color overrides
    // );

    return base.copyWith(
      // colorScheme: darkScheme,
      // scaffoldBackgroundColor: Colors.grey.shade900, // Dark background color
      scaffoldBackgroundColor: Color(0xFF0A1521),
      // cardColor: Colors.grey[950], // Dark card color
      // Additional dark theme customizations
    );
  }

  static Color? getPrimaryColorShade(int shade) {
    return Colors.blue[shade] ?? Colors.blue[700];
  }

  static Color? get primaryColor => isDarkMode ? getPrimaryColorShade(600) : getPrimaryColorShade(700);

  static Color? get drawerColor => isDarkMode ? Color(0xFF121E2E) : primaryColor;

  static Color? get primaryCardColor => isDarkMode ? Color(0xFF121E2E) : Colors.white;

  static Color? get secondaryCardColor => isDarkMode ? Color(0xFF1B283B) : Colors.white;

  static Color? get hoverFillColor1 => isDarkMode ? primaryColor : getPrimaryColorShade(50);

  static Color? get hoverFillColor2 => isDarkMode ? Color(0xFF1B283B) : getPrimaryColorShade(100);

  static Color? get hoverFillColor3 => isDarkMode ? Color(0xFF23344d) : getPrimaryColorShade(50);

  static Color? get hoverFillColor4 => isDarkMode ? Colors.grey.shade700 : getPrimaryColorShade(50);

  static Color get primaryTextColor => isDarkMode ? Colors.grey.shade300 : Colors.grey.shade800;

  static Color? get secondaryTextColor => isDarkMode ? getPrimaryColorShade(300) : primaryColor;

  static Color get tertiaryTextColor1 => isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

  static Color get tertiaryTextColor2 => isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;

  static Color get secondaryColor => isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200;

  static Color? get tertiaryColor1 => isDarkMode ? Color(0xFF202f45) : getPrimaryColorShade(50);

  static Color get tertiaryColor2 => isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;

  static Color get borderColor1 => isDarkMode ? getPrimaryColorShade(400)! : getPrimaryColorShade(600)!;

  static Color get borderColor2 => isDarkMode ? Color(0xFF2f4363) : Colors.grey.shade200;

  static Color? get hoverBorderColor1 => isDarkMode ? getPrimaryColorShade(400) : getPrimaryColorShade(400);

  static Color? get hoverShadowColor => isDarkMode ? Colors.black.withOpacity(0.7) : Colors.grey.withOpacity(0.2);

  static Color? get hoverTextColor => isDarkMode ? Colors.grey.shade50 : primaryColor;

  static Color get inactiveIconColor => isDarkMode ? Colors.grey.shade600 : Colors.grey.shade500;

  static Color? get activeIconColor => isDarkMode ? Colors.grey.shade300 : primaryColor;

  static Color? get percentageIconBackgroundFillColor => isDarkMode ? Color(0xFF23344d) : getPrimaryColorShade(50);

  static Color? get iconFillColor1 => isDarkMode ? getPrimaryColorShade(400) : primaryColor;

  static Color? get tableRowColor => isDarkMode ? Color(0xFF273752) : Colors.grey.shade200;

  static LinearGradient getBarsGradientColor() {
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

  static BoxDecoration expansionTileOn() =>
      BoxDecoration(color: Colors.grey[300], border: Border(left: BorderSide(width: 3.0, color: primaryColor!)));

  static BoxDecoration expansionTileOff() => BoxDecoration(color: Colors.grey[300]);

  static TextStyle get bulletPointSymbolStyle => TextStyle(
        fontSize: 20,
        height: 1.75,
        color: primaryColor,
      );

  static TextStyle get bulletPointTextStyle => TextStyle(
        fontSize: 1.7 * 10, // 1.7rem
        fontWeight: FontWeight.w400,
        height: 1.75,
      );

  static BoxDecoration get flipCardBoxDecorationBack => BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: primaryColor!, width: 3), // Blue border added for flipped state
      );

  // static ButtonStyle get elevatedBoxButtonStyle => ElevatedButton.styleFrom(
  //       elevation: 0,
  //       backgroundColor: primaryCardColor,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(4),
  //         side: BorderSide(
  //           color: borderColor1,
  //           width: 2.0,
  //         ),
  //       ),
  //     );

  static ButtonStyle elevatedBoxButtonStyle({Color? backgroundColor}) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: backgroundColor ?? primaryCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: borderColor1,
          width: 2.0,
        ),
      ),
    );
  }

  static ButtonStyle elevatedBoxButtonStyleDisabled({Color? backgroundColor}) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: primaryCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(
          color: borderColor2,
          width: 2.0,
        ),
      ),
    );
  }

  static ButtonStyle get elevatedRoundedButtonStyle => ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: primaryCardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: borderColor1,
            width: 2.0,
          ),
        ),
      );
}
