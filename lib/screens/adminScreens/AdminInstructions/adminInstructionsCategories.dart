import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionsSlidesHTML.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class AdminInstructionsCategories extends StatelessWidget {
  const AdminInstructionsCategories({
    super.key,
    required this.category,
    required this.subCategories,
  });

  final String category;
  final List<String>? subCategories;

  @override
  Widget build(BuildContext context) {
    LoggedInState? loggedInState = context.watch<LoggedInState>();
    AdminProvider adminProvider = context.watch<AdminProvider>();

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: subCategories != null
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: subCategories!.length,
                  itemBuilder: (context, index) {
                    var subCategory = subCategories![index];
                    return Card(
                      color: secondaryColor, // Use your secondary color here
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      shape: customCardShape, // Use your custom card shape
                      child: ListTile(
                        title: Text(
                          subCategory,
                          style: buttonText, // Use your button text style
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminInstructionSlidesHTML(
                                adminProvider: adminProvider,
                                category: category,
                                subCategory: subCategory,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(child: Text('No sub-categories found')),
        ),
      ),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
    );
  }
}
