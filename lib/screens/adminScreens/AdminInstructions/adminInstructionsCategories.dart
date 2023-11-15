// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionsSlides.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class AdminInstructionCategories extends StatelessWidget {
  const AdminInstructionCategories({
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
              ? Center(
                  // Centers horizontally
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: (MediaQuery.of(context).size.width > 1000
                              ? MediaQuery.of(context).size.width * 0.4
                              : MediaQuery.of(context).size.width) *
                          0.60,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // Centers vertically
                      children: [
                        Flexible(
                          // Makes ListView flexible in the column
                          child: ListView.builder(
                            shrinkWrap:
                                true, // Important to wrap content in ListView
                            itemCount: subCategories!.length,
                            itemBuilder: (context, index) {
                              var subCategory = subCategories![index];
                              return Card(
                                color: secondaryColor,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                shape: customCardShape,
                                child: ListTile(
                                  title: Text(
                                    subCategory,
                                    style: buttonText,
                                    textAlign:
                                        TextAlign.center, // Text alignment
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminInstructionSlides(
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
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const Center(child: Text('No sub-categories found')),
        ),
      ),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
    );
  }
}
