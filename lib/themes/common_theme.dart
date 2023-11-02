import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Theme Constants
const primaryColor = Color.fromARGB(255, 4, 123, 154);
// const primaryColor = Color.fromARGB(255, 9, 25, 112);
const secondaryColor = Colors.white;
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
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor);

TextStyle commonTextStyle =
    TextStyle(fontSize: defaultFontSize, color: secondaryColor);

TextStyle commonTitleStyle = TextStyle(
  fontSize: 17,
);

ShapeBorder customCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);
ThemeData customTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        extendedTextStyle: TextStyle(color: Colors.white)));
