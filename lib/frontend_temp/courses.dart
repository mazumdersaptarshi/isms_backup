import 'package:flutter/material.dart';
import 'package:isms/themes/common_theme.dart';
// import 'package:isms/Frontend/module_desc.dart';
// import 'package:isms/Frontend/test_details.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(CourseDetailsPage(
    title: 'Courses ',
  ));
}

class CourseDetailsPage extends StatelessWidget {
  final String title;

  CourseDetailsPage({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: commonTitleStyle,
          ),
        ),
        body: ListView(
          children: List.generate(7, (index) {
            return Card(
              shape: customCardShape,
              color: primaryColor,
              elevation: 4,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                trailing: Icon(Icons.arrow_forward_ios),
                title: Text('Module ${index + 1}', style: commonTextStyle),
                // You can remove this onTap behavior if not needed
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ModuledescPage(courseTitle: title)),
                  // );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
