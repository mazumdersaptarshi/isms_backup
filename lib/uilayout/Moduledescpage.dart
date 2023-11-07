// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'testdetails.dart';

void main() {
  runApp(const Moduledescpage(courseTitle: 'Python Basics'));
}

class Moduledescpage extends StatelessWidget {
  final String courseTitle;

  const Moduledescpage({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          title: const Text(''),
          backgroundColor: Colors.blue[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Image.network(
                  "https://blogassets.leverageedu.com/blog/wp-content/uploads/2020/04/23152312/IELTS-Study-Material.png",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20.0),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This course will show you a detailed explanation of how to cook with the help of the world-famous chef Raj. Get ready with your ladles and spices! To continue, please click on "Study Module".',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: const Text('Study Module'),
                    ),
                    const SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TestDetailsPage()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      child: const Text('Take Exam'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}