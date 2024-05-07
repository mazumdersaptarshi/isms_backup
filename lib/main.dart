import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:isms/controllers/exam_management/exam_provider.dart';
import 'package:isms/controllers/language_management/language_manager.dart';
import 'package:isms/controllers/reminders_management/reminders_provider.dart';
import 'package:isms/controllers/storage/hive_service/hive_service.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/controllers/user_management/user_progress_tracker.dart';
import 'package:isms/firebase_options.dart';
import 'package:isms/utilities/navigation.dart';
import 'package:logging/logging.dart';
import 'package:postgres/postgres.dart';
import 'package:provider/provider.dart';

import 'controllers/auth_token_management/csrf_token_provider.dart';
import 'controllers/theme_management/theme_manager.dart';

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

  // final conn = await Connection.open(
  //   Endpoint(
  //     host: '10.0.2.2',
  //     port: 5432,
  //     database: 'postgres',
  //     username: 'postgres',
  //     password: '',
  //   ),
  //   // The postgres server hosted locally doesn't have SSL by default. If you're
  //   // accessing a postgres server over the Internet, the server should support
  //   // SSL and you should swap out the mode with `SslMode.verifyFull`.
  //   settings: ConnectionSettings(sslMode: SslMode.disable),
  // );
  //
  // final result0 = await conn
  //     .execute('SELECT * FROM public.courses ORDER BY course_id ASC ;');
  // print(result0[0]); // first row, first column

  runApp(IsmsApp());
}

class IsmsApp extends StatelessWidget {
  IsmsApp({super.key});

  Locale _locale = Locale('en');

  @override
  Widget build(BuildContext context) {
    print('triggered rebuild');
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CsrfTokenProvider>(create: (context) {
          return CsrfTokenProvider();
        }),
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
        ChangeNotifierProvider<ExamProvider>(create: (context) {
          return ExamProvider();
        }),
        ChangeNotifierProvider<ThemeManager>(create: (context) {
          return ThemeManager();
        }),
        ChangeNotifierProvider<LocaleManager>(create: (context) {
          return LocaleManager();
        }),
      ],
      child: Builder(builder: (context) {
        return MaterialApp.router(
          locale: Provider.of<LocaleManager>(context).locale,
          title: 'ISMS',
          // theme: ThemeConfig.dynamicISMSTheme(),
          scrollBehavior: CustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          // Required for localisation functionality
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Supported locales for localisation
          supportedLocales: const [
            Locale('en'),
            Locale('ja'),
          ],
          // Configuration for direct URL linking and access
          routerConfig: ismsRouter,
          // home: const LoginPage(),
        );
      }),
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
