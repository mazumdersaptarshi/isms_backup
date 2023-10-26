import 'package:flutter/material.dart';
import 'package:isms/userManagement/loggedInUserProvider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../adminManagement/adminProvider.dart';
import '../../../screens/userInfo/userProfilePage.dart';
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
                return ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${index + 1}. ${snapshot.data![index].username}',
                        style:
                            TextStyle(fontSize: 14, color: Colors.blueAccent),
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
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        '${snapshot.data![index].courses_completed!.length}',
                        style: TextStyle(fontSize: 12),
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
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        '${snapshot.data![index].courses_started!.length}',
                        style: TextStyle(fontSize: 12),
                      ),
                      children: [
                        for (var courseItem
                            in snapshot.data![index].courses_started!)
                          UserCourseStartedDetailsTile(
                              courseItem: courseItem,
                              coursesProvider: coursesProvider,
                              index: index),
                      ],
                    ),
                  ],
                );
              });
        } else {
          return Text('No data to return, unexpected error');
        }
      },
    );
  }
}

class UserCourseStartedDetailsTile extends StatelessWidget {
  UserCourseStartedDetailsTile(
      {super.key,
      required this.courseItem,
      required this.coursesProvider,
      required this.index});
  var courseItem;
  CoursesProvider coursesProvider;
  int index;
  Map<String, dynamic> getCourseCompletedPercentage() {
    double courseCompletionPercentage = 0;
    int noOfExams = 0;
    bool isValid = false;
    print('Enrolled CoursesDropdown');

    if (courseItem["modules_completed"] != null) {
      int modulesCount = 0;

      for (int i = 0; i < coursesProvider.allCourses.length; i++) {
        var element = coursesProvider.allCourses[i];

        if (element.name == courseItem["course_name"]) {
          modulesCount = element.modulesCount!;
          noOfExams = element.examsCount!;
          isValid = true;
        }
      }

      int modulesCompletedCount = courseItem["modules_completed"] != null
          ? courseItem["modules_completed"].length
          : 0;
      if (isValid) {
        courseCompletionPercentage = modulesCompletedCount / modulesCount;
      }
    }

    return {
      "isValid": isValid,
      "courseCompletionPercentage": courseCompletionPercentage,
      "noOfExams": noOfExams
    };
  }

  @override
  Widget build(BuildContext context) {
    var courseDetailsData = getCourseCompletedPercentage();
    return Container(
      constraints: BoxConstraints(minHeight: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${courseItem["course_name"]}'),
              Text('${courseDetailsData["courseCompletionPercentage"] * 100}'),
              CircularPercentIndicator(
                radius: 20.0,
                lineWidth: 5.0,
                percent: courseDetailsData["courseCompletionPercentage"],
                center: new Text(
                  (courseDetailsData["courseCompletionPercentage"] * 100)
                      .toString(),
                  style: TextStyle(fontSize: 10),
                ),
                progressColor: Colors.yellow.shade900,
              )
            ],
          ),
          if (courseItem["exams_completed"] != null)
            Row(
              children: [
                Text(
                  'Exam completed: ${courseItem["exams_completed"].length} of ${courseDetailsData["noOfExams"]}',
                  textAlign: TextAlign.left,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
