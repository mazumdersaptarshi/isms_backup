import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';

class Notification {
  final String title;
  final DateTime? deadline;
  bool isRead;

  Notification({required this.title, this.deadline, required this.isRead});

  void markAsRead() {
    isRead = true;
  }

  void markAsUnread() {
    isRead = false;
  }
}

final List<Notification> courses = [
  Notification(title: "WFH tomorrow", isRead: false),
  Notification(title: "Data Visualization for Storytellers", deadline: DateTime(2024, 3, 21), isRead: false),
  Notification(title: "Astrobiology: Life Beyond Earth", deadline: DateTime(2024, 3, 28), isRead: true),
  Notification(title: "Ethical Hacking: Defending Your Data", deadline: DateTime(2024, 3, 16), isRead: false),
  Notification(title: "The History of Chocolate: From Bean to Bar", deadline: DateTime(2024, 3, 25), isRead: true),
  Notification(title: "The Science of Happiness", deadline: DateTime(2024, 3, 20), isRead: false),
  Notification(title: "3D Printing: From Design to Prototype", deadline: DateTime(2024, 3, 18), isRead: true),
  Notification(title: "Sparkling Idol Songwriting 101", deadline: DateTime(2024, 3, 23), isRead: false),
  Notification(title: "Napping Techniques for Maximum Cuteness", deadline: DateTime(2024, 3, 27), isRead: false),
  Notification(title: "Kawaii Cuisine: Mastering Bento Boxes", deadline: DateTime(2024, 3, 19), isRead: false),
  Notification(title: "Magical Girl History: From Folklore to Franchise", deadline: DateTime(2024, 3, 22), isRead: false),
];

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key); // Default constructor

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Track selected courses (indices) and checkbox states
  List<int> selectedCourses = [];
  bool selectAll = false; // Track "Select All" state (checkbox and text)

  void handleCourseClick(int index) {
    setState(() {
      selectedCourses.contains(index)
          ? selectedCourses.remove(index)
          : selectedCourses.add(index);
      // Update "Select All" based on individual selections
      selectAll = selectedCourses.length == courses.length;
    });
  }

  void handleMarkUnread() {
    setState(() {
      for (var index in selectedCourses) {
        courses[index].markAsUnread();
      }
      selectedCourses.clear();
      selectAll = false;
    });
  }

  void handleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedCourses =
          value! ? courses.map((e) => courses.indexOf(e)).toList() : [];
    });
  }

  void handleListItemClick(int index) {
    // Handle click on the entire list item (excluding checkbox)
    setState(() {
      final course = courses[index];
      if (!course.isRead) {
        course.markAsRead();
      }
    });
  }

  void handleDeleteSelected() {
    if (selectedCourses.isEmpty) return; // Prevent deletion if nothing selected

    setState(() {
      // Efficiently remove selected courses in reverse order to avoid index issues
      selectedCourses.sort((a, b) => b.compareTo(a)); // Sort descending
      for (var index in selectedCourses) {
        courses.removeAt(index);
      }
      selectedCourses.clear();
      selectAll = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final loggedInState = context.watch<LoggedInState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Course Notifications',
      home: Scaffold(
        // bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
        // appBar: IsmsAppBar(context: context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      onChanged: handleSelectAll, // Update "Select All" on tap
                    ),
                    InkWell(
                      // Make "Select All" text clickable
                      onTap: () => handleSelectAll(!selectAll),
                      // Toggle selection
                      child: Text('Select All'),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Tooltip(
                      message: 'Delete Selected',
                      child: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: selectedCourses.isEmpty
                            ? null
                            : handleDeleteSelected,
                        disabledColor:
                            Colors.grey, // Gray out when nothing selected
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: 'Mark Unread Selected',
                      child: IconButton(
                        icon: Icon(Icons.mark_as_unread_outlined),
                        onPressed:
                            selectedCourses.isEmpty ? null : handleMarkUnread,
                        disabledColor: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Divider(),
                // Add a divider to separate "Select All" from the list
                ListView.builder(
                  shrinkWrap: true, // Prevent list from expanding unnecessarily
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedCourses.contains(index),
                          // Check if selected
                          onChanged: (bool? value) => handleCourseClick(index),
                        ),
                        Expanded(
                          // Make remaining space clickable
                          child: InkWell(
                            onTap: () => handleListItemClick(index),
                            child: ListTile(
                              title: Text(course.title),
                              subtitle: course.deadline != null
                                  ? Text(DateFormat('y MMMM d')
                                      .format(course.deadline!))
                                  : Text(''),
                              // Set background color based on isRead
                              tileColor: course.isRead
                                  ? Colors.grey[200]
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
