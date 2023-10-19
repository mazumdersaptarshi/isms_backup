import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminConsoleProvider.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/login/loginUI.dart';
import 'package:isms/slideManagement/slidesCreationProvider.dart';
import 'package:isms/userManagement/customUserProvider.dart';
import 'package:provider/provider.dart';
import 'adminManagement/adminConsoleProvider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CustomUserProvider>(create: (context) {
          return CustomUserProvider();
        }),
        ChangeNotifierProvider<CoursesProvider>(create: (context) {
          return CoursesProvider();
        }),
        ChangeNotifierProvider<SlidesCreationProvider>(create: (context) {
          return SlidesCreationProvider();
        }),
        ChangeNotifierProvider<AdminConsoleProvider>(create: (context) {
          return AdminConsoleProvider();
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
