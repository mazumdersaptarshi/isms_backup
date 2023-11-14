// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:flutter/material.dart';

const double SCREEN_COLLAPSE_WIDTH = 800;

// Theme Constants
const primaryColor = Colors.deepPurpleAccent;

final secondaryColor = Colors.deepPurpleAccent.shade100;
const bgColor = Colors.deepPurpleAccent;

const white = Colors.white;
const black = Colors.black;
const transparent = Colors.transparent;
// const primaryColor = Color.fromARGB(255, 9, 25, 112);
const shadowColor = Colors.black54;
const bigFontSize = 20.0;
const defaultFontSize = 15.0;
const smallFontSize = 12.0;
const defaultFontWeight = FontWeight.bold;

ButtonStyle customElevatedButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

TextStyle buttonText = const TextStyle(
  color: white,
  fontSize: defaultFontSize,
);

TextStyle optionButtonText = const TextStyle(
    color: white, fontSize: smallFontSize, fontWeight: FontWeight.bold);

BoxDecoration customButtonTheme = BoxDecoration(
  color: secondaryColor,
  // boxShadow: [
  //   BoxShadow(
  //     color: secondaryColor,
  //     offset: Offset(0, 2),
  //     blurRadius: 1,
  //   )
  // ],
  borderRadius: BorderRadius.circular(20),
);

BoxDecoration customBoxTheme = BoxDecoration(
  color: white,
  boxShadow: [
    BoxShadow(
      color: secondaryColor,
      offset: const Offset(0, 2),
      blurRadius: 1,
    )
  ],
  borderRadius: BorderRadius.circular(10),
);

InputDecoration customInputDecoration({
  String hintText = '',
  Icon? prefixIcon,
}) {
  return InputDecoration(
    labelText: hintText,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: primaryColor, width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusColor: secondaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

TextStyle ModuleDescStyle = const TextStyle(
    fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor);

TextStyle commonTextStyle =
    const TextStyle(fontSize: defaultFontSize, color: black);

TextStyle commonTitleStyle = const TextStyle(
  fontSize: 17,
);

ShapeBorder customCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);

// TODO
// - build a colorscheme (start with `fromSeed()`)
// - remove as much colors as possible from everywhere else
// - same for other aspects of theme (font size, etc)
ThemeData customTheme = ThemeData(
  fontFamily: 'Poppins',
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor.shade100,
      extendedTextStyle: const TextStyle(color: white)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: "Poppins"),
    bodyMedium: TextStyle(fontFamily: "Poppins"),
    labelMedium: TextStyle(fontFamily: "Poppins"),
    displayLarge: TextStyle(fontFamily: "Poppins"),
    displayMedium: TextStyle(fontFamily: "Poppins"),
  ),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: Colors.deepPurpleAccent.shade100,
    secondary: Colors.grey.shade400,
    tertiary: Colors.grey.shade600,
  ),
  primaryColor: primaryColor,
  buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColor.shade100),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      minimumSize: MaterialStateProperty.all(const Size(
          150.0, 48.0)), // You can customize other button properties here.
    ),
  ),
);
