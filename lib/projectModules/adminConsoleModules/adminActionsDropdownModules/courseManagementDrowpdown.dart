import 'package:flutter/material.dart';

import '../../../adminManagement/adminConsoleProvider.dart';

class CourseManagementDrowpdown extends StatelessWidget {
  const CourseManagementDrowpdown({
    super.key,
    required this.adminConsoleProvider,
  });

  final AdminConsoleProvider adminConsoleProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Courses'),
        FutureBuilder<List<dynamic>>(
            future: adminConsoleProvider.getAllCoursesList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data != null) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text('${snapshot.data![index].course_name}'),
                      children: [
                        for (var student in snapshot.data![index].students!)
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('${student.email}'),
                                  Text('${student.isPassed}'),
                                  Text('${student.course_percent_completed}'),
                                  Text('${student.exams_percent_completed}'),
                                ],
                              )
                            ],
                          )
                      ],
                    );
                  },
                );
              } else {
                return Text('No data');
              }
            }),
      ],
    );
  }
}
