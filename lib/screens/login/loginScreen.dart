// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //Future<User?>? _signInFuture;
  bool hasCheckedForChangedDependencies = false;
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  void main() async {
    super.initState();
    // await Firebase.initializeApp(
    //     options: DefaultFirebaseOptions.currentPlatform);
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser != null) {
      return const HomePage();
    }

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
                    await LoggedInState.login();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: const Text('Google Login ')),
          ],
        ),
      ),
    );
  }

  Widget ISMSText() {
    return const Text('ISMS');
  }
}
