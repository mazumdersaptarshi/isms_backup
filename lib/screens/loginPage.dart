import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/screens/checkLoggedInScreen.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/models/customUser.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Future<User?>? _signInFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => isSignedIn(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loginText(),
            const SizedBox(height: 150),
            bugHubLogo(),
            const SizedBox(height: 150),
            bugHubText(),
            const SizedBox(height: 40),
            signInButton(),
            SignInFutureBuilder(),
          ],
        ),
      ),
    );
  }

  Widget loginText() {
    return const Text(
      'Login',
    );
  }

  Widget bugHubLogo() {
    return const SizedBox(
      width: 150,
      height: 150,
      child: Text(
        'LOGO',
      ),
    );
  }

  Widget bugHubText() {
    return const Text('ISMS');
  }

  Widget signInButton() {
    if (_signInFuture == null) {
      return ElevatedButton.icon(
        onPressed: () {
          setState(() {
            _signInFuture = signInWithGoogle();
          });
        },
        icon: const Icon(Icons.mail),
        label: const Text('Sign in with Google'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget SignInFutureBuilder() {
    if (_signInFuture != null) {
      return FutureBuilder<User?>(
        future: _signInFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
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

  Future<void> isSignedIn(BuildContext context) async {
    if (await GoogleSignIn().isSignedIn()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        debugPrint(user.displayName);
        debugPrint(user.email);
      }
      await createUserIfNotExists(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckLoggedIn()),
      );
    }
  }

  Future<User?> signInWithGoogle() async {
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
      final String? email = user?.email;
      debugPrint(user!.displayName);
      debugPrint(user.email);
      //final List<String> allowedDomains = ['pvp.co.jp'];

      if (email != null) {
        //bool isAllowed = true;
        // bool isAllowed = false;
        // for (String domain in allowedDomains) {
        //   if (email.endsWith('@$domain')) {
        //     isAllowed = true;
        //     break;
        //   }
        // }
        /*
        if (!isAllowed) {
          await FirebaseAuth.instance.signOut();
          print('Please use your PVP email.');
          return null;
        }*/
      }

      //print(user);
      await createUserIfNotExists(user);
      return user;
    } catch (e) {
      debugPrint('Error signing in with Google: $e');
      return null;
    }
  }

  Future<void> createUserIfNotExists(User? user) async {
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!userDoc.exists) {
      await CreateUserDataOperations().createUser(
          user.uid,
          CustomUser(
            username: user.displayName!,
            email: user.email!,
            role: 'user',
            courses_started: [],
            courses_completed: [],
          ));
    }
  }
}
