import 'package:flutter/material.dart';

class ModuleDetailPage extends StatelessWidget {
  final String moduleTitle;

  ModuleDetailPage({required this.moduleTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(moduleTitle),
        centerTitle: true, // Centering the title
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              'Description for $moduleTitle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Text(
                'Random text description goes here. This is a detailed description about the module. Feel free to replace this with your module-specific content.',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add the functionality to start the module here
              },
              child: Text('Click here to start this module'),
            ),
          ],
        ),
      ),
    );
  }
}
