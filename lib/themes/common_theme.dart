// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

// Theme Constants
const primaryColor = Colors.deepPurpleAccent;
const secondaryColor = Color.fromARGB(255, 128, 132, 255);
const bgColor = Color.fromARGB(255, 255, 255, 255);
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
  boxShadow: const [
    BoxShadow(
      color: secondaryColor,
      offset: Offset(0, 2),
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
    hintText: hintText,
    contentPadding:
        const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: transparent, width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusColor: secondaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: secondaryColor, width: 2.0),
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
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      extendedTextStyle: TextStyle(color: white)),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontFamily: "Poppins"),
    bodyMedium: TextStyle(fontFamily: "Poppins"),
    labelMedium: TextStyle(fontFamily: "Poppins"),
    displayLarge: TextStyle(fontFamily: "Poppins"),
    displayMedium: TextStyle(fontFamily: "Poppins"),
  ),
  colorScheme:
      ColorScheme.fromSeed(seedColor: Colors.white, background: Colors.white),
  buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(secondaryColor),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      minimumSize: MaterialStateProperty.all(const Size(
          150.0, 48.0)), // You can customize other button properties here.
    ),
  ),
);
