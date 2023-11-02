import 'package:flutter/material.dart';
import 'testdetails.dart';

void main() {
  runApp(Moduledescpage(courseTitle: 'Python Basics'));
}

class Moduledescpage extends StatelessWidget {
  final String courseTitle;

  Moduledescpage({required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.blue[900],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
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
              SizedBox(height: 20.0),
              Spacer(),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.orange[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'This course will show you a detailed explanation of how to cook with the help of the world-famous chef Raj. Get ready with your ladles and spices! To continue, please click on "Study Module".',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Study Module'),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TestDetailsPage()),
                        );
                      },
                      child: Text('Take Exam'),
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orange),
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                      ),
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
