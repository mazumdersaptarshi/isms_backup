// ignore_for_file: file_names
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:isms/uilayout/sidebar.dart';
// import '../screens/userInfo/userProfilePage.dart';
// import 'coursedetail.dart';
//
// void main() {
//   runApp(HomeScreen());
// }
//
// class HomeScreen extends StatelessWidget {
//   final List<String> courseTitles = [
//     'How to Train your Dragon', 'How to cook(ft.Raj)', 'Learn how to Code', 'How to Lose a Guy in 10 Days', 'Learn how to dance', 'How I Met Your Mother', 'How to do Magic',
//     'How to Get Away with Murder', 'How to be rich', 'How the Grinch Stole christmas', 'How are you barbie ', 'How to be happy(ft. sap)'
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(150.0),  // increase the AppBar size
//           child: AppBar(
//             backgroundColor: Colors.blue[900], // Dark blue background
//             title: Text('My Courses', style: TextStyle(color: Colors.white)), // White text
//             centerTitle: true,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.vertical(
//                 bottom: Radius.circular(50),
//               ),
//             ),
//             bottom: PreferredSize(
//               preferredSize: Size.fromHeight(30.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   courseAppBarAction("New", context),
//                   courseAppBarAction("Completed", context),
//                   courseAppBarAction("Ongoing", context),
//                 ],
//               ),
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.account_circle, color: Colors.white),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => UserProfilePage()),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 1,
//               childAspectRatio: 6/3,
//             ),
//             itemCount: courseTitles.length,
//             itemBuilder: (context, index) {
//               return CourseTile(title: courseTitles[index]);
//             },
//           ),
//         ),
//         drawer: Sidebar(),
//       ),
//     );
//   }
// }
// Widget courseAppBarAction(String title, BuildContext context) {
//   return GestureDetector(
//     onTap: () {},
//     child: Padding(
//       padding: EdgeInsets.symmetric(vertical: 5.0),
//       child: Text(title,
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//     ),
//   );
// }
// class CourseTile extends StatelessWidget {
//   final String title;
//
//   CourseTile({required this.title});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.0)
//       ),
//       color: Colors.orange[200],  // Already set as white
//       child: Column(
//         children: [
//           ListTile(
//             title: Text(title,
//         style: TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//             trailing: Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => CourseDetailsPage(courseTitle: title),
//                 ),
//               );
//             },
//           ),
//           Expanded(
//             child: Image.network(
//               "https://t3.ftcdn.net/jpg/00/53/73/42/360_F_53734293_rs3bkrl9n1EJZBj2CdogkmeF6W5aOhy5.jpg",
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
