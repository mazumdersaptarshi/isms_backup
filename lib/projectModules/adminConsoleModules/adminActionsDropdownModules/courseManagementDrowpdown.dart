import 'package:flutter/material.dart';

import '../../../adminManagement/adminConsoleProvider.dart';

class CourseManagementDrowpdown extends StatelessWidget {
  const CourseManagementDrowpdown({
    super.key,
    required this.adminConsoleProvider,
  });

  final AdminProvider adminConsoleProvider;

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
                    print(('hguadhkghkafjk'));
                    print(
                        'course started users: ${snapshot.data![index].course_started}');
                    return ExpansionTile(
                      title: Text('${snapshot.data![index].course_name}'),
                      children: [
                        ExpansionTile(
                          title: Text(
                            'Completed',
                            style: TextStyle(color: Colors.green),
                          ),
                          trailing: Text(
                            '${snapshot.data![index].course_completed!.length}',
                            style: TextStyle(color: Colors.green),
                          ),
                          children: [
                            for (var student
                                in snapshot.data![index].course_completed!)
                              Text(
                                '${student['username']}',
                                style: TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Started',
                            style: TextStyle(color: Colors.yellow.shade900),
                          ),
                          trailing: Text(
                            '${snapshot.data![index].course_started!.length}',
                            style: TextStyle(color: Colors.yellow.shade900),
                          ),
                          children: [
                            for (var student
                                in snapshot.data![index].course_started!)
                              Text(
                                '${student['username']}',
                                style: TextStyle(color: Colors.yellow.shade900),
                              ),
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
