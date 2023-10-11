import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/screens/createCourseScreen.dart';
import 'package:isms/screens/createSlideScreen.dart';
import 'package:isms/slideManagement/slidesCreationProvider.dart';
import 'package:provider/provider.dart';
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
        ChangeNotifierProvider<CoursesProvider>(create: (context) {
          return CoursesProvider();
        }),
        ChangeNotifierProvider<SlidesCreationProvider>(create: (context) {
          return SlidesCreationProvider();
        }),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: CoursesDisplayScreen(),
      ),
    );
  }
}
