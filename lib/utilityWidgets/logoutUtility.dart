import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/screens/login/loginScreen.dart';

class AuthUtils {
  static void logout(BuildContext context) async {
    //await GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
    // userDataGetterMaster.currentUser = null;
    // // userDataGetterMaster.currentUserEmail = '';
    // userDataGetterMaster.currentUserRole = null;
    // userDataGetterMaster.currentUserUid = null;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
