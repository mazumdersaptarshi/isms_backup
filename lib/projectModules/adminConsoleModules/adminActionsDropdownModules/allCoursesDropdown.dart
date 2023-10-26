import 'package:flutter/material.dart';

import '../../../adminManagement/adminProvider.dart';

class AllCoursesDropdown extends StatelessWidget {
  AllCoursesDropdown({super.key, required this.adminProvider});
  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: adminProvider.allCoursesDataFetcher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    '${index + 1}.  ${snapshot.data![index].course_name}',
                    style: TextStyle(color: Colors.blueAccent),
                  ),
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
              });
        }
        return Text('Could not load data, unforseen error!');
      },
    );
  }
}
