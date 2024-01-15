// format.dart

import 'package:flutter/material.dart';

class Format {
  static TextStyle pageTitle = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle headline = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle description = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  );

  static TextStyle descriptionBold = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: Colors.black,

  );

  static TextStyle bulletPointStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: Colors.black,
  );

  static Widget bulletPoint(String text) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text('• ', style: bulletPointStyle),
        ),
        Text(text, style: description),
      ],
    );

  }
  static Widget numberedItem(int number, String text) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text('$number. ', style: numberedItemStyle),
        ),
        Text(text, style: description),
      ],
    );
  }

  static TextStyle numberedItemStyle = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 18.0,
    color: Colors.black,
  );

  static const TextStyle flipCardText = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static const TextStyle expansionTileTitle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );
  static const TextStyle expansionTileContent = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );
}