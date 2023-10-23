import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminConsoleProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesCreationProvider.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  print('Firebase initialized');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoggedInUserProvider>(create: (context) {
          return LoggedInUserProvider();
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
        home: LoginPage(),
      ),
    );
  }
}
