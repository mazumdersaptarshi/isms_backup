import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:isms/utitlityFunctions/auth_service.dart';
import 'package:provider/provider.dart';

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  Future<User?>? _signInFuture;
  bool hasCheckedForChangedDependencies = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!hasCheckedForChangedDependencies &&
        FirebaseAuth.instance.currentUser != null) {
      hasCheckedForChangedDependencies = true;
      if (mounted) {
        await AuthService().handleSignInDependencies(
          context: context,
          customUserProvider:
              Provider.of<CustomUserProvider>(context, listen: false),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomUserProvider customUserProvider =
        Provider.of<CustomUserProvider>(context, listen: false);
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

  Widget signInButton({required CustomUserProvider customUserProvider}) {
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
}