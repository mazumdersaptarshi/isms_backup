import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/firebase_options.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';

import '../homePage.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Future<User?>? _signInFuture;
  bool hasCheckedForChangedDependencies = false;
  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  void main() async {
    super.initState();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

  Future<void> GoogleSignInWeb() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    await userDataGetterMaster.getLoggedInUserInfoFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ISMSText(),
            const SizedBox(height: 40),
            ElevatedButton(
                onPressed: () async {
                  try {
                    await GoogleSignInWeb();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Google Login ')),
          ],
        ),
      ),
    );
  }

  Widget ISMSText() {
    return const Text('ISMS');
  }
}
