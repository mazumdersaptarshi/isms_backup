import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/databaseOperations/databaseManager.dart';
import 'package:isms/firebase_options.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:isms/utitlityFunctions/auth_service.dart';
import 'package:provider/provider.dart';

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

  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasCheckedForChangedDependencies &&
        DatabaseManager.auth.currentUser != null) {
      hasCheckedForChangedDependencies = true;
      if (mounted) {
        await AuthService().handleSignInDependencies(
          context: context,
          customUserProvider:
              Provider.of<LoggedInUserProvider>(context, listen: false),
        );
      }
    }
  }

  Future<void> GoogleSignInWeb() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
  }

  @override
  Widget build(BuildContext context) {
    LoggedInUserProvider customUserProvider =
        Provider.of<LoggedInUserProvider>(context, listen: false);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginText(),
            const SizedBox(height: 150),
            ISMSLogo(),
            const SizedBox(height: 150),
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
                child: Text('Google Test Login Web')),
            signInButton(customUserProvider: customUserProvider),
            SignInFutureBuilder(_signInFuture),
          ],
        ),
      ),
    );
  }

  Widget loginText() {
    return const Text('Login');
  }

  Widget ISMSLogo() {
    return const SizedBox(
      width: 150,
      height: 150,
      child: Text('LOGO'),
    );
  }

  Widget ISMSText() {
    return const Text('ISMS');
  }

  Widget signInButton({required LoggedInUserProvider customUserProvider}) {
    if (_signInFuture == null) {
      return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _signInFuture = AuthService().signInWithGoogle(customUserProvider);
          });
        },
        icon: const Icon(Icons.mail),
        label: const Text('Sign in with Google'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget SignInFutureBuilder(Future<User?>? signInFuture) {
    if (signInFuture != null) {
      return FutureBuilder<User?>(
        future: signInFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              userDataGetterMaster.getLoggedInUserInfoFromFirestore();
              await AuthService.setLoggedInUser(
                  customUserProvider: Provider.of<LoggedInUserProvider>(context,
                      listen: false));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            });
          }
          return const CircularProgressIndicator();
        },
      );
    }
    return const SizedBox.shrink();
  }
}
