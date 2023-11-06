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
  AdminActionDropdown({
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
        children: [
          !isUsersLoading
              ? ElevatedButton(
                  onPressed: () async {
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
                  child: Text('User Data'))
              : CircularProgressIndicator(),
          !isCoursesLoading
              ? ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isCoursesLoading = true;
                    });
                    DataExporter dataExporter =
                        DataExporter(collectionDataToDownload: 'courses');
                    await dataExporter.downloadCSV();
                    setState(() {
                      isCoursesLoading = false; // Set to false after download
                    });
                  },
                  child: Text('Courses Data'))
              : CircularProgressIndicator(),
          ElevatedButton(
              onPressed: () async {
                DataExporter dataExporter =
                    DataExporter(collectionDataToDownload: 'adminconsole');
                await dataExporter.downloadCSV();
              },
              child: Text('Courses Progress Data'))
        ],
      );
    } else {
      return Text('No data to show!');
    }
  }
}

class AdminInstructionsDropdown extends StatelessWidget {
  AdminInstructionsDropdown({super.key, this.categories});
  Map<String, dynamic>? categories;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (String key in categories!.keys)
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AdminInstructionsCategories(
                            category: key, subCategories: categories?[key])));
              },
              child: Text('${key}')),
      ],
    );
  }
}
