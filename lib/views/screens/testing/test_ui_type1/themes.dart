import 'package:flutter/material.dart';

class AppThemes {
  static const Color primaryColor = Colors.deepPurpleAccent;
  static const Color secondaryColor = Colors.green;
  static const Color tertiaryColor = Colors.orange;

  static const TextStyle headingStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle contentStyle = TextStyle(
    fontSize: 1.7 * 12,
    fontWeight: FontWeight.w400,
    height: 1.75,
  );

  static const TextStyle flipCardFrontStyle = TextStyle(
    fontSize: 24,
    color: Colors.black,
  );
  static const TextStyle flipCardBackStyle = TextStyle(
    fontSize: 24,
    color: Colors.black,
  );

  static const TextStyle quizCardQuestionStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
  );
  static const TextStyle quizCardAnswerStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  static BoxDecoration boxshadowisHover() {
    return BoxDecoration(
      color: Colors.grey.shade100,
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 5.0,
          spreadRadius: 1.0,
        ),
      ], // Always have the shadow
    );
  }

  static BoxDecoration boxshadowNotHover() {
    return BoxDecoration(
      color: Colors.transparent,
      boxShadow: [],
    );
  }

  static const TextStyle expansionTileTitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
  static const TextStyle expansionTileContentStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );

  static final CardTheme quizCard = CardTheme(
    color: Colors.white,
    shadowColor: Colors.black45,
    elevation: 20,
  );

  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}
