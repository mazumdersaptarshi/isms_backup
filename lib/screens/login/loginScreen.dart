import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser != null) {
      return HomePage();
    }

    return Scaffold(
      body: Center(
        child: _isLoading ? loadingWidget() : LoginPageUI(),
      ),
    );
  }

  Widget loadingWidget() {
    Size size = MediaQuery.of(context).size;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Loading",
          style: TextStyle(
            fontSize: size.width * 0.1,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: Lottie.asset('assets/images/loading_animation.json'),
        ),
      ],
    );
  }

  Widget LoginPageUI() {
    Size size = MediaQuery.of(context).size;
    double paddingValue = size.width * 0.1;
    double spacing = size.height * 0.02;

    Color deepAccentPurple = Colors.deepPurpleAccent.shade100;
    Color buttonColorDark = Colors.black87;

    return Container(
      color: deepAccentPurple,
      padding: EdgeInsets.symmetric(horizontal: paddingValue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          Text(
            'ISMS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: spacing),
          Text(
            'One app to keep track of all your pending certifications',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: size.width * 0.04,
            ),
          ),
          const Spacer(flex: 8),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await LoggedInState.login();
              } catch (e) {
                print(e);
              } finally {
                _isLoading = false;
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: buttonColorDark,
              padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text(
              'LOGIN',
              style: TextStyle(fontSize: size.width * 0.045),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
