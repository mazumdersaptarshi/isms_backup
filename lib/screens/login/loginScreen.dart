import 'dart:convert';
// import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:isms/databaseOperations/databaseManager.dart';
import 'package:isms/firebase_options.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:isms/utitlityFunctions/auth_service.dart';
import 'package:provider/provider.dart';
import "package:universal_html/html.dart" as html;

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

  void GoogleSignInWeb() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
  }

  Future<void> downloadCSV() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    // Initialize a list to store the CSV data
    List<List<dynamic>> csvData = [
      // Define the headers
      ['username', 'uid', 'email', 'courses_started']
    ];
    print(allData);
    // Loop through the documents to populate the CSV data
    for (QueryDocumentSnapshot snapshot in allData) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      csvData.add([
        data['username'].toString(),
        data['uid'].toString(),
        data['email'].toString(),
        data['courses_started'].toString()
      ]);
    }
    print(csvData);
    // Create the CSV content
    StringBuffer buffer = StringBuffer();
    csvData.forEach((row) {
      buffer.writeAll(row, ',');
      buffer.write('\n');
    });
    print(buffer);
    // Convert to Uint8List
    Uint8List bytes = Uint8List.fromList(utf8.encode(buffer.toString()));

    // Create Blob and download the file
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'data.csv')
      ..click();
    html.Url.revokeObjectUrl(url);
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
                onPressed: () {
                  GoogleSignInWeb();
                },
                child: Text('Google Login Web')),
            ElevatedButton(
                onPressed: () {
                  // DataExporter dataExporter = DataExporter();
                  // dataExporter.createCSV();
                  downloadCSV();
                },
                child: Text('Download CSV')),
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
