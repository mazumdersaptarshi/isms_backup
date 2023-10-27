import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesCreationProvider.dart';
import 'package:isms/screens/homePage.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Firebase initialized');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<void> setUser() async {
    UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

    await userDataGetterMaster.getLoggedInUserInfoFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoggedInState>(create: (context) {
          return LoggedInState();
        }),
        ChangeNotifierProvider<CoursesProvider>(create: (context) {
          return CoursesProvider();
        }),
        ChangeNotifierProvider<SlidesCreationProvider>(create: (context) {
          return SlidesCreationProvider();
        }),
        ChangeNotifierProvider<AdminProvider>(create: (context) {
          return AdminProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: LoginPage(),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.data == null) {
                  return LoginPage();
                } else {
                  setUser().then((value) {
                    return HomePage();
                  });
                  print('This_route');
                  return LoginPage();
                }
              }
              return LoginPage();
            }),
      ),
    );
  }
}
