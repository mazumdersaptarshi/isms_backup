// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionSlides.dart';
import 'package:provider/provider.dart';

class AdminInstructionsCategories extends StatelessWidget {
  const AdminInstructionsCategories(
      {super.key, required this.category, required this.subCategories});

  final String category;
  final List<String>? subCategories;

  @override
  Widget build(BuildContext context) {
    AdminProvider adminProvider = context.watch<AdminProvider>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (subCategories != null)
              for (var subCategory in subCategories!)
                ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminInstructionSlides(
                                  adminProvider: adminProvider,
                                  category: category,
                                  subCategory: subCategory,
                                )),
                      );
                    },
                    child: Text(subCategory)),
          ],
        ),
      ),
    );
  }
}
