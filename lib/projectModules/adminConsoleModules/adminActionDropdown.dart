import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../adminManagement/adminDataExporter.dart';
import '../../adminManagement/adminProvider.dart';
import '../../screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import 'adminActionsDropdownModules/allCoursesDropdown.dart';
import 'adminActionsDropdownModules/allUsersDropdown.dart';

class AdminActionDropdown extends StatefulWidget {
  AdminActionDropdown({
    required this.adminProvider,
    required this.actionId,
  });

  final AdminProvider adminProvider;
  final String actionId;
  final Map<String, dynamic> categories = {
    'people': ['Onboarding', 'Offboarding', 'Termination'],
    'vendors': ['Onboarding', 'Offboarding', 'Termination'],
    'players': ['Code of Conduct', 'Game Rules']
  };
  @override
  State<AdminActionDropdown> createState() => _AdminActionDropdownState();
}

class _AdminActionDropdownState extends State<AdminActionDropdown> {
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
        categories: widget.categories,
      );
    } else if (widget.actionId == 'dwnld') {
      return Column(
        children: [
          ElevatedButton(
              onPressed: () {
                DataExporter dataExporter =
                    DataExporter(collectionDataToDownload: 'users');
                dataExporter.downloadCSV();
              },
              child: Text('User Data')),
          ElevatedButton(
              onPressed: () {
                DataExporter dataExporter =
                    DataExporter(collectionDataToDownload: 'courses');
                dataExporter.downloadCSV();
              },
              child: Text('Courses Data')),
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
                AdminProvider adminProvider =
                    Provider.of<AdminProvider>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminInstructionsCategories(
                            adminProvider: adminProvider,
                            category: key,
                            subCategories: categories?[key],
                          )),
                );
              },
              child: Text('${key}')),
      ],
    );
  }
}
