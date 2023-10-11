// import 'package:flutter/material.dart';
// import 'models/slide.dart';
// import 'models/module.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Courses',
//       theme: ThemeData(
//         primarySwatch: Colors.grey,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: CoursePage(),
//     );
//   }
// }
//
// class CoursePage extends StatefulWidget {
//   @override
//   _CoursePageState createState() => _CoursePageState();
// }
//
// class _CoursePageState extends State<CoursePage> {
//   List<Module> modules = [
//     Module(
//       title: "Module #1",
//       id: "1",
//       contentDescription: "Module 1 Description",
//       slides: [
//         Slide(
//           id: "1",
//           index: 1,
//           title: "Slide 1",
//           content: "Slide 1 Content",
//         ),
//         Slide(
//           id: "2",
//           index: 2,
//           title: "Slide 2",
//           content: "Slide 2 Content",
//         ),
//         Slide(
//           id: "3",
//           index: 3,
//           title: "Slide 3",
//           content: "Slide 3 Content",
//         ),
//       ],
//     ),
//     Module(
//       title: "Module #2",
//       id: "2",
//       contentDescription: "Module 2 Description",
//       slides: [
//         Slide(
//           id: "4",
//           index: 1,
//           title: "Slide 1",
//           content: "Slide 1 Content",
//         ),
//         Slide(
//           id: "5",
//           index: 2,
//           title: "Slide 2",
//           content: "Slide 2 Content",
//         ),
//         Slide(
//           id: "6",
//           index: 3,
//           title: "Slide 3",
//           content: "Slide 3 Content",
//         ),
//       ],
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Courses'),
//       ),
//       body: ListView.builder(
//         itemCount: modules.length,
//         itemBuilder: (BuildContext context, int index) {
//           return ModuleListWidget(
//             module: modules[index],
//             isModuleCompleted: index % 2 == 0,
//           );
//         },
//       ),
//     );
//   }
// }
