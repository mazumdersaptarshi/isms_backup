// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/sharedWidgets/loadingScreenWidget.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
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
      return const HomePage();
    }

    return Scaffold(
      body: Center(
        child: _isLoading
            ? Container(
                height: 200,
                width: MediaQuery.of(context).size.width > SCREEN_COLLAPSE_WIDTH
                    ? 300
                    : MediaQuery.of(context).size.width,
                child: loadingWidget())
            : LoginPageUI(),
      ),
    );
  }

  Widget LoginPageUI() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Define max width for better content management
        const double maxWidthForContent = 600;

        // Use a more consistent font size across different screen sizes
        double titleFontSize = constraints.maxWidth > 600 ? 50 : 40;
        double subTitleFontSize = constraints.maxWidth > 600 ? 20 : 16;
        double buttonFontSize = constraints.maxWidth > 600 ? 24 : 18;

        // You can adjust these paddings/margins as per your UI design
        double horizontalPadding = 40;
        double verticalPadding = 20;

        return Container(
          color: Colors.deepPurpleAccent.shade100,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: maxWidthForContent),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding, vertical: verticalPadding),
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Use MainAxisSize.min to fit content size
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ISMS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: Text(
                        'One app to keep track of all your pending certifications',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: subTitleFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: 200),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => _isLoading = true);
                        try {
                          await LoggedInState.login();
                        } catch (e) {
                          log(e.toString());
                        } finally {
                          _isLoading = false;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(fontSize: buttonFontSize),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
