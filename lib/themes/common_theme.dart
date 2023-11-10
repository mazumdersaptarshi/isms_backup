import 'package:flutter/material.dart';

// Theme Constants
const primaryColor = Colors.deepPurpleAccent;

final secondaryColor = Colors.deepPurpleAccent.shade200;
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

TextStyle buttonText = TextStyle(
  color: white,
  fontSize: defaultFontSize,
);

TextStyle optionButtonText = TextStyle(
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

// TODO
// - build a colorscheme (start with `fromSeed()`)
// - remove as much colors as possible from everywhere else
// - same for other aspects of theme (font size, etc)
ThemeData customTheme = ThemeData(
  fontFamily: 'Poppins',
  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryColor.shade100,
      extendedTextStyle: TextStyle(color: white)),
  textTheme: TextTheme(
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
  buttonTheme: const ButtonThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(primaryColor.shade100),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      minimumSize: MaterialStateProperty.all(Size(150.0, 48.0)),
    ),
  ),
);
