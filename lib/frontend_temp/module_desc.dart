import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../themes/common_theme.dart';

class ModuledescPage extends StatelessWidget {
  final String courseTitle;

  ModuledescPage({required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    final int maxLines = 15; // Specify the maximum number of lines

    // Generate the course description with a specified number of lines
    String description =
        'This course will show you a detailed explanation of how to cook with the help of the world-famous chef Raj. Get ready with your ladles and spices! To continue, please click on "Study Module".';
    for (int i = 0; i < maxLines; i++) {
      description += '\n'; // Add empty lines for the remaining lines
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Module Description', style: commonTitleStyle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseTitle,
              style: ModuleDescStyle,
            ),
            SizedBox(height: 20),
            // Card with course description
            Card(
              elevation: 4,
              shape: customCardShape,
              color: primaryColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: commonTextStyle,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Study Module button aligned to the bottom and centered
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: customElevatedButtonStyle(),
                      onPressed: () {
                        // Add your action for the "Study Module" button here
                      },
                      child: Text('Study Module', style: commonTextStyle),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: customElevatedButtonStyle(),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        // //   MaterialPageRoute(
                        // //       builder: (context) => ExamScreen()),
                        // // );
                      },
                      child: Text('Take Test', style: commonTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
