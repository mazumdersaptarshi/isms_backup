import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/remindersManagement/remindersProvider.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  // logging setup
  // lowest level that will be logged (default: Level.INFO)
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // react to logging events by calling developer.log()
    log(record.message,
        name: record.loggerName,
        level: record.level.value,
        error: record.object);
  });
  final Logger logger = Logger('ISMS');

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on Exception catch (_) {}
  logger.info('Firebase initialized');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ChangeNotifierProvider<AdminProvider>(create: (context) {
          return AdminProvider();
        }),
        ChangeNotifierProvider<RemindersProvider>(create: (context) {
          return RemindersProvider();
        }),
      ],
      child: MaterialApp(
        scrollBehavior: MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: customTheme,
        home: const LoginPage(),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
