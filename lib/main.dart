import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'package:isms/firebase_options.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/reminders_management/reminders_provider.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/views/screens/authentication/login_screen.dart';

// import 'package:isms/remindersManagement/reminders_provider.dart';
// import 'package:isms/screens/login/login_screen.dart';

void main() async {
  // logging setup
  // lowest level that will be logged (default: Level.INFO)
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // react to logging events by calling developer.log()
    log(record.message, name: record.loggerName, level: record.level.value, error: record.object);
  });
  final Logger logger = Logger('ISMS');

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } on Exception catch (_) {}
  logger.info('Firebase initialized');

  await Hive.initFlutter(); //initializing Hive

  HiveService.registerAdapters(); //Registering Adapters for Hive
  await Hive.openBox('users'); // Opening Users Box

  ChangeNotifierProxyProvider<LoggedInState, UserProgressState?>(
    create: (context) => null,
    update: (context, loggedInState, previousUserProgressState) {
      return UserProgressState(
        userId: loggedInState.currentUser!.uid ?? '',
      );
    },
  );

  runApp(const IsmsApp());
}

class IsmsApp extends StatelessWidget {
  const IsmsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoggedInState>(create: (context) {
          return LoggedInState();
        }),
        ChangeNotifierProxyProvider<LoggedInState, UserProgressState?>(
            create: (context) => null,
            update: (context, loggedInState, previousUserProgressState) {
              return UserProgressState(userId: loggedInState.currentUser!.uid);
            }),
        ChangeNotifierProvider<RemindersProvider>(create: (context) {
          return RemindersProvider();
        }),
      ],
      child: MaterialApp(
        title: 'ISMS',
        theme: ismsTheme,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ja'),
        ],
        scrollBehavior: CustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: const LoginPage(),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
