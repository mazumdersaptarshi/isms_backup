// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../../adminManagement/adminDataExporter.dart';
import '../../adminManagement/adminProvider.dart';
import '../../screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import 'adminActionsDropdownModules/allCoursesDropdown.dart';
import 'adminActionsDropdownModules/allUsersDropdown.dart';

final Map<String, dynamic> categories = {
  'people': ['Onboarding', 'Offboarding', 'Termination'],
  'vendors': ['Onboarding', 'Offboarding', 'Termination'],
  'players': ['Code of Conduct', 'Game Rules']
};

class AdminActionDropdown extends StatefulWidget {
  const AdminActionDropdown({
    super.key,
    required this.adminProvider,
    required this.actionId,
  });

  final AdminProvider adminProvider;
  final String actionId;

  @override
  State<AdminActionDropdown> createState() => _AdminActionDropdownState();
}

class _AdminActionDropdownState extends State<AdminActionDropdown> {
  bool isCoursesLoading =
      false; //to manage state of courses button while data is being loaded for downloading
  bool isUsersLoading =
      false; //to manage state of users button while data is being loaded for downloading
  @override
  Widget build(BuildContext context) {
    if (widget.actionId == 'crs_mgmt') {
      return AllCoursesDropdown(
        adminProvider: widget.adminProvider,
      );
    } else if (widget.actionId == 'user_mgmt') {
      return AllUsersDropdown(adminProvider: widget.adminProvider);
    } else if (widget.actionId == 'instr') {
      return AdminInstructionsDropdown(
        categories: categories,
      );
    } else if (widget.actionId == 'dwnld') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          !isUsersLoading
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isUsersLoading = true;
                        });
                        DataExporter dataExporter =
                            DataExporter(collectionDataToDownload: 'users');
                        await dataExporter.downloadCSV();
                        setState(() {
                          isUsersLoading = false; // Set to false after download
                        });
                      },
                      child: GestureDetectorCard(text: 'User Data')),
                )
              : const CircularProgressIndicator(),
          !isCoursesLoading
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          isCoursesLoading = true;
                        });
                        DataExporter dataExporter =
                            DataExporter(collectionDataToDownload: 'courses');
                        await dataExporter.downloadCSV();
                        setState(() {
                          isCoursesLoading =
                              false; // Set to false after download
                        });
                      },
                      child: GestureDetectorCard(
                        text: 'Courses Data',
                      )),
                )
              : const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
                onTap: () async {
                  DataExporter dataExporter =
                      DataExporter(collectionDataToDownload: 'adminconsole');
                  await dataExporter.downloadCSV();
                },
                child: GestureDetectorCard(
                  text: 'Courses Progress Data',
                )),
          )
        ],
      );
    } else {
      return const Text('No data to show!');
    }
  }
}

class AdminInstructionsDropdown extends StatelessWidget {
  const AdminInstructionsDropdown({super.key, this.categories});
  final Map<String, dynamic>? categories;
  void navigateToAdminInstructionsCategories(
      BuildContext context, String category, List<String>? subCategories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdminInstructionsCategories(
          category: category,
          subCategories: subCategories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (String key in categories!.keys)
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
                onTap: () {
                  navigateToAdminInstructionsCategories(
                      context, key, categories?[key]);
                },
                child: GestureDetectorCard(
                  text: key,
                )),
          ),
      ],
    );
  }
}

class GestureDetectorCard extends StatelessWidget {
  const GestureDetectorCard({super.key, this.text});
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Card(
      // Add margin for spacing between cards
      elevation: 4.0, // Adds shadow beneath the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded edges for the card
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          text!,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
