import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
// import '../../../screens/analyticsSharedWidgets/courseDropdownWidget.dart';
// import '../../../screens/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
import '../../../sharedWidgets/analyticsSharedWidgets/courseDropdownWidget.dart';
import '../../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
import '../../courseManagement/coursesProvider.dart';

class AllUsersDropdown extends StatelessWidget {
  AllUsersDropdown({super.key, required this.adminProvider});

  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    return FutureBuilder<List<dynamic>>(
      future: adminProvider.allUsersDataFetcher(),
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
                return Card(
                  margin: EdgeInsets.all(4.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Rounded edges for the card
                  ),
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${index + 1}. ${snapshot.data![index].username}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          label: Text(
                            '${snapshot.data![index].role}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      _buildCoursesTile(
                          'Courses Completed',
                          snapshot.data![index].courses_completed,
                          context,
                          index,
                          coursesProvider),
                      _buildCoursesTile(
                          'Courses Enrolled',
                          snapshot.data![index].courses_started,
                          context,
                          index,
                          coursesProvider),
                    ],
                  ),
                );
              });
        } else {
          return Text('No data to return, unexpected error');
        }
      },
    );
  }

  Widget _buildCoursesTile(String title, List<dynamic> courses,
      BuildContext context, int index, CoursesProvider coursesProvider) {
    return ExpansionTile(
      backgroundColor: Colors.grey.shade100,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          // Use theme color for consistency
        ),
      ),
      trailing: Text(
        '${courses.length}',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      children: [
        if (title == 'Courses Completed')
          for (var courseItem in courses)
            CourseDropdownWidget(
              courseItem: courseItem,
              detailType: 'courses_completed',
            ),
        if (title == 'Courses Enrolled')
          for (var courseItem in courses)
            UserCourseStartedDetailsWidget(
                courseItem: courseItem,
                coursesProvider: coursesProvider,
                index: index),
      ],
    );
  }
}
