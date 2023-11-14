// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionSlides.dart';
import 'package:isms/sharedWidgets/bottomNavBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import '../../../utilityFunctions/platformCheck.dart';

class AdminInstructionsCategories extends StatelessWidget {
  AdminInstructionsCategories(
      {super.key, required this.category, required this.subCategories});

  final String category;
  final List<String>? subCategories;
  @override
  Widget build(BuildContext context) {
    LoggedInState? loggedInState = context.watch<LoggedInState>();

    AdminProvider adminProvider = context.watch<AdminProvider>();
    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState!, context: context),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(10.0),
            ),
            if (subCategories != null)
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: subCategories!.length,
                itemBuilder: (context, index) {
                  var subCategory = subCategories![index];
                  return Card(
                    elevation: 4,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                      ),
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
                      child: Text(subCategory),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
