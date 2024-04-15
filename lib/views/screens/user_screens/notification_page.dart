import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

final List<Notification> notifications = [
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
  const NotificationPage({super.key}); // Default constructor

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Track selected notifications (indices) and checkbox states
  List<int> selectedNotification = [];
  bool selectAll = false; // Track "Select All" state (checkbox and text)

  void handleNotificationClick(int index) {
    setState(() {
      selectedNotification.contains(index)
          ? selectedNotification.remove(index)
          : selectedNotification.add(index);
      // Update "Select All" based on individual selections
      selectAll = selectedNotification.length == notifications.length;
    });
  }

  void handleMarkUnread() {
    setState(() {
      for (var index in selectedNotification) {
        notifications[index].markAsUnread();
      }
      selectedNotification.clear();
      selectAll = false;
    });
  }

  void handleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      selectedNotification =
          value! ? notifications.map((e) => notifications.indexOf(e)).toList() : [];
    });
  }

  void handleListItemClick(int index) {
    // Handle click on the entire list item (excluding checkbox)
    setState(() {
      final notification = notifications[index];
      if (!notification.isRead) {
        notification.markAsRead();
      }
    });
  }

  void handleDeleteSelected() {
    if (selectedNotification.isEmpty) return; // Prevent deletion if nothing selected

    setState(() {
      // Efficiently remove selected notifications in reverse order to avoid index issues
      selectedNotification.sort((a, b) => b.compareTo(a)); // Sort descending
      for (var index in selectedNotification) {
        notifications.removeAt(index);
      }
      selectedNotification.clear();
      selectAll = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    return Scaffold(
        appBar: IsmsAppBar(context: context),
        bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              left: MediaQuery.of(context).size.width * 0.03,
              right: MediaQuery.of(context).size.width * 0.05,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: selectAll,
                      onChanged: handleSelectAll,
                    ),
                    InkWell(
                      // Make "Select All" text clickable
                      onTap: () => handleSelectAll(!selectAll),
                      // Toggle selection
                      child: Text(AppLocalizations.of(context)!.selectAll,),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Tooltip(
                      message: AppLocalizations.of(context)!.deleteSelected,
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: handleDeleteSelected,
                          color: selectedNotification.isEmpty
                              ? Colors.grey[300]
                              : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: AppLocalizations.of(context)!.markUnreadSelected,
                      child: IconButton(
                        icon: Icon(Icons.mark_as_unread_outlined),
                        onPressed: handleMarkUnread,
                        color: selectedNotification.isEmpty
                            ? Colors.grey[300]
                            : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Divider(),
                // Add a divider to separate "Select All" from the list
                ListView.builder(
                  shrinkWrap: true, // Prevent list from expanding unnecessarily
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return Row(
                      children: [
                        Checkbox(
                          value: selectedNotification.contains(index),
                          // Check if selected
                          onChanged: (bool? value) => handleNotificationClick(index),
                        ),
                        Expanded(
                          // Make remaining space clickable
                          child: InkWell(
                            onTap: () => handleListItemClick(index),
                            child: ListTile(
                              title: Text(notification.title),
                              subtitle: notification.deadline != null
                                  ? Text(DateFormat('y MMMM d')
                                      .format(notification.deadline!))
                                  : Text(''),
                              // Set background color based on isRead
                              tileColor: notification.isRead
                                  ? Colors.grey[300]
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
      );
  }
}