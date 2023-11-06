import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme Constants
const primaryColor = Color.fromARGB(255, 128, 132, 255);

const bgColor = Color.fromARGB(255, 255, 255, 255);
// const primaryColor = Color.fromARGB(255, 9, 25, 112);
const textColor = Colors.black54;
const shadowColor = Colors.black54;
const defaultFontSize = 15.0;
const smallFontSize = 12.0;
const defaultFontWeight = FontWeight.bold;

ButtonStyle customElevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

TextStyle ModuleDescStyle =
    TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white);

TextStyle commonTextStyle =
    TextStyle(fontSize: defaultFontSize, color: textColor);

TextStyle commonTitleStyle = TextStyle(
  fontSize: 17,
);

ShapeBorder customCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);
ThemeData customTheme = ThemeData(
  textTheme: TextTheme(
    displayMedium: TextStyle(color: Colors.black),
    displayLarge: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.white, background: Colors.white),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      extendedTextStyle: TextStyle(color: Colors.white)),
  buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        backgroundColor: primaryColor,
        textStyle: TextStyle(color: Colors.black)),
  ),
);
