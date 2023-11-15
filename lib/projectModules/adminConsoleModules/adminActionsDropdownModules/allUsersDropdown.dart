// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/sharedWidgets/analyticsSharedWidgets/userCourseCompletedDetailsWidget.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../sharedWidgets/analyticsSharedWidgets/userCourseStartedDetailsWidget.dart';
import '../../courseManagement/coursesProvider.dart';

class AllUsersDropdown extends StatelessWidget {
  const AllUsersDropdown({super.key, required this.adminProvider});

  final AdminProvider adminProvider;

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider =
        Provider.of<CoursesProvider>(context, listen: false);
    return FutureBuilder<List<dynamic>>(
      future: adminProvider.allUsersDataFetcher(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                List<Map<String, dynamic>> completedCoursesForUser = [];

                for (var courseStartedItem
                    in snapshot.data![index].courses_started) {
                  for (var courseCompletedItem
                      in snapshot.data![index].courses_completed) {
                    if (courseCompletedItem['courseID'] ==
                        courseStartedItem['courseID']) {
                      courseStartedItem['completed_at'] =
                          courseCompletedItem['completed_at'] ?? 'n/a';
                      completedCoursesForUser.add(courseStartedItem);
                    }
                  }
                }

                return Card(
                  margin: const EdgeInsets.all(4.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        15.0), // Rounded edges for the card
                  ),
                  child: ExpansionTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}. ',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.account_circle),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('${snapshot.data![index].username}',
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          label: Text(
                            '${snapshot.data![index].role}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    children: [
                      _buildCoursesTile(
                          'Courses Completed',
                          // snapshot.data![index].courses_completed,
                          completedCoursesForUser,
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
          return const Text('No data to return, unexpected error');
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
        style: const TextStyle(
          fontSize: 12,
          // Use theme color for consistency
        ),
      ),
      trailing: Text(
        '${courses.length}',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      children: [
        if (title == 'Courses Completed')
          for (var courseItem in courses)
            UserCourseCompletedDetailsWidget(
                courseItem: courseItem,
                coursesProvider: coursesProvider,
                index: index),
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
