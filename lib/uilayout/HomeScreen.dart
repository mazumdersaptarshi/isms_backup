// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/uilayout/sidebar.dart';
import '../screens/userInfo/userProfilePage.dart';
import 'coursedetail.dart';

void main() {
  runApp(HomeScreen());
}

class HomeScreen extends StatelessWidget {
  final List<String> courseTitles = [
    'How to Train your Dragon', 'How to cook(ft.Raj)', 'Learn how to Code', 'How to Lose a Guy in 10 Days', 'Learn how to dance', 'How I Met Your Mother', 'How to do Magic',
    'How to Get Away with Murder', 'How to be rich', 'How the Grinch Stole christmas', 'How are you barbie ', 'How to be happy(ft. sap)'
  ];

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),  // increase the AppBar size
          child: AppBar(
            backgroundColor: Colors.blue[900], // Dark blue background
            title: const Text('My Courses', style: TextStyle(color: Colors.white)), // White text
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  courseAppBarAction("New", context),
                  courseAppBarAction("Completed", context),
                  courseAppBarAction("Ongoing", context),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.account_circle, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserProfilePage()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 6/3,
            ),
            itemCount: courseTitles.length,
            itemBuilder: (context, index) {
              return CourseTile(title: courseTitles[index]);
            },
          ),
        ),
        drawer: const Sidebar(),
      ),
    );
  }
}
Widget courseAppBarAction(String title, BuildContext context) {
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}
class CourseTile extends StatelessWidget {
  final String title;

  const CourseTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.orange[200],  // Already set as white
      child: Column(
        children: [
          ListTile(
            title: Text(title,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailsPage(courseTitle: title),
                ),
              );
            },
          ),
          Expanded(
            child: Image.network(
              "https://t3.ftcdn.net/jpg/00/53/73/42/360_F_53734293_rs3bkrl9n1EJZBj2CdogkmeF6W5aOhy5.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
