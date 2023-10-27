import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isms/firebase_options.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:isms/utilityFunctions/authUtils.dart';
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

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user != null) {
      return HomePage();
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
                    await AuthUtils.login();
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
