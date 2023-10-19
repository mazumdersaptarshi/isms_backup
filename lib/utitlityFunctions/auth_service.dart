import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/screens/login/checkLoggedInScreen.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/userManagement/customUserProvider.dart';

class AuthService {
  final CreateUserDataOperations _createUserDataOperations =
      CreateUserDataOperations();

  Future<User?> signInWithGoogle(CustomUserProvider customUserProvider) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = authResult.user;

      await _createUserDataOperations.checkAndCreateUserIfNotExists(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> handleSignInDependencies({
    required BuildContext context,
    required CustomUserProvider customUserProvider,
  }) async {
    if (await GoogleSignIn().isSignedIn()) {
      final user = FirebaseAuth.instance.currentUser;
      await _createUserDataOperations.checkAndCreateUserIfNotExists(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckLoggedIn()),
      );
    }
  }
}
