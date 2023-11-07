import 'package:flutter/material.dart';
import 'Moduledescpage.dart';

void main() {
  runApp(const CourseDetailsPage(courseTitle: 'Python Basics'));
}

class CourseDetailsPage extends StatelessWidget {
  final String courseTitle;

  const CourseDetailsPage({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: AppBar(
            backgroundColor: Colors.blue[900],
            title: const Text(
              'Course Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Moduledescpage(courseTitle: 'Module ${index + 1}'),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  padding: const EdgeInsets.all(25.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Module ${index + 1}',
                        style: const TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      const Icon(
                        Icons.arrow_downward,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}