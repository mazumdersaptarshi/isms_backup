import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLoading = false; // Add this line to track loading state

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser != null) {
      return HomePage();
    }

    return Scaffold(
      body: Center(
        child: _isLoading ? const CircularProgressIndicator() : buildLoginUI(),
      ),
    );
  }

  Widget buildLoginUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ISMSText(),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true; // Set loading to true when login starts
            });
            try {
              await LoggedInState.login();
            } catch (e) {
              print(e);
            } finally {
              setState(() {
                _isLoading = false; // Set loading to false when login ends
              });
            }
          },
          child: const Text('Google Login'),
        ),
      ],
    );
  }

  Widget ISMSText() {
    return const Text('ISMS');
  }
}
