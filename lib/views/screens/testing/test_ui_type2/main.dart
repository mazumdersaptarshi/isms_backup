// main.dart

import 'package:flutter/material.dart';

import 'first_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter Web App',
      home: CoursePageType2(),
    );
  }
}
