// UserCoursesList.dart

import 'package:flutter/material.dart';

class UserCoursesList extends StatelessWidget {
  final List<Map<String, dynamic>> userData;

  UserCoursesList({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: userData.length,
      itemBuilder: (context, index) {
        var courseData = userData[index];
        return ExpansionTile(
          title: Text(courseData['courseName']),
          leading: Icon(
            courseData['isEnrolled'] ? Icons.check_circle_outline : Icons.cancel,
            color: courseData['isEnrolled'] ? Colors.green : Colors.red,
          ),
          subtitle: Text('Status: ${courseData['status']}'),
          children: [
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Attempt')),
                DataColumn(label: Text('Score')),
                DataColumn(label: Text('Result')),
              ],
              rows: List<DataRow>.generate(
                courseData['attempts'].length,
                (index) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(courseData['attempts'][index]['date'])),
                    DataCell(Text(courseData['attempts'][index]['attempt'].toString())),
                    DataCell(Text('${courseData['attempts'][index]['score']}%')),
                    DataCell(Text(courseData['attempts'][index]['result'])),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
