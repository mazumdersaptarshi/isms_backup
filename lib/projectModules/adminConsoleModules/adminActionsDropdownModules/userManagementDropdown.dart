import 'package:flutter/material.dart';

import '../../../adminManagement/adminConsoleProvider.dart';

class UsermanagementDropdown extends StatelessWidget {
  const UsermanagementDropdown({
    super.key,
    required this.adminConsoleProvider,
  });

  final AdminProvider adminConsoleProvider;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: adminConsoleProvider.getAllUsersList(),
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${index + 1}. ${snapshot.data![index].username}',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '${snapshot.data![index].role}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  children: [
                    ExpansionTile(
                      title: const Text(
                        'Courses Completed',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        '${snapshot.data![index].courses_completed!.length}',
                        style: TextStyle(fontSize: 14),
                      ),
                      children: [
                        for (var courseItem
                            in snapshot.data![index].courses_completed!)
                          Text('${courseItem['course_name']}'),
                      ],
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Courses Started',
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Text(
                        '${snapshot.data![index].courses_started!.length}',
                        style: TextStyle(fontSize: 14),
                      ),
                      children: [
                        for (var courseItem
                            in snapshot.data![index].courses_started!)
                          Text('${courseItem['course_name']}'),
                      ],
                    ),
                  ],
                );
              },
            );
          } else {
            return Text('No data');
          }
        });
  }
}
