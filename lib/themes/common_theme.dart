import 'package:flutter/material.dart';

// Theme Constants
const primaryColor = Color.fromARGB(255, 221, 244, 250);
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


TextStyle buttonText = TextStyle(
  color: white,
  fontSize: defaultFontSize,
);

TextStyle optionButtonText = TextStyle(
    color: white,
    fontSize: smallFontSize,
    fontWeight: FontWeight.bold
);

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
  boxShadow: const[
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
    contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: transparent, width: 1.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
    focusColor: secondaryColor,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: secondaryColor, width: 2.0),
      borderRadius: BorderRadius.circular(10.0),
    ),
  );
}

TextStyle ModuleDescStyle =
TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor);

TextStyle commonTextStyle = TextStyle(fontSize: defaultFontSize, color: black);

TextStyle commonTitleStyle = TextStyle(
  fontSize: 17,
);

ShapeBorder customCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);
ThemeData customTheme = ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        extendedTextStyle: TextStyle(color:white)));