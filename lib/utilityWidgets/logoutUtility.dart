import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/screens/login/loginUI.dart';

class AuthUtils {
  static void logout(BuildContext context) async {
    await GoogleSignIn().disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
