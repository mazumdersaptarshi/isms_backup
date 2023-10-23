import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../../adminManagement/adminConsoleProvider.dart';
import '../../screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import 'adminActionsDropdownModules/courseManagementDrowpdown.dart';
import 'adminActionsDropdownModules/userManagementDropdown.dart';

class AdminActionDropdown extends StatefulWidget {
  AdminActionDropdown({
    required this.adminConsoleProvider,
    required this.actionId,
  });

  final AdminProvider adminConsoleProvider;
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
      return CourseManagementDrowpdown(
          adminConsoleProvider: widget.adminConsoleProvider);
    } else if (widget.actionId == 'user_mgmt') {
      return UsermanagementDropdown(
          adminConsoleProvider: widget.adminConsoleProvider);
    } else if (widget.actionId == 'instr') {
      return AdminInstructionsDropdown(
        categories: widget.categories,
      );
    } else if (widget.actionId == 'dwnld') {
      return ElevatedButton(
          onPressed: () {
            DataExporter dataExporter = DataExporter();
            dataExporter.createCSV();
          },
          child: Text('Download as CSV'));
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

class DataExporter {
  Future<void> createCSV() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final List<QueryDocumentSnapshot> allData = querySnapshot.docs;

    List<List<String>> csvData = [
      // Headers
      ['username', 'uid', 'role']
    ];

    for (QueryDocumentSnapshot snapshot in allData) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      csvData.add([
        data['username'].toString(),
        data['uid'].toString(),
        data['role'].toString()
      ]);
    }
    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getTemporaryDirectory();
    // final desktopDirectory = Directory('C:/Users/mazumders/Desktop');
    final pathOfTheFileToWrite = directory!.path + "/myCsvFile.csv";
    File file = File(pathOfTheFileToWrite);
    print(directory?.path);
    await file.writeAsString(csv);
  }
}
