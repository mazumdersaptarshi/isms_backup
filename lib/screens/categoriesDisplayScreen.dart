import 'package:flutter/material.dart';
import 'package:isms/categoryManagement/categoryProvider.dart';
import 'package:isms/screens/createCategoryScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/sharedWidgets/popupDialog.dart';
import 'package:provider/provider.dart';

class CategoriesDisplayScreen extends StatefulWidget {
  CategoriesDisplayScreen({super.key});

  @override
  State<CategoriesDisplayScreen> createState() =>
      _CategoriesDisplayScreenState();
}

class _CategoriesDisplayScreenState extends State<CategoriesDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (BuildContext context, CategoriesProvider categoriesProvider,
          Widget? child) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            child: ListView.builder(
              itemCount: categoriesProvider.allCategories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(categoriesProvider.allCategories[index].name),
                  onTap: () {
                    if (categoriesProvider.allCategories[index].modules ==
                        null) {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => PopupDialog(
                          title:
                              'No modules in ${categoriesProvider.allCategories[index].name}',
                          description:
                              'There are no modules in ${categoriesProvider.allCategories[index].name}',
                          onPressedOK: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => HomePageScreen()));
                          },
                        ),
                      );
                    }
                  },
                  subtitle: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateModuleScreen(
                                  parentCategory: categoriesProvider
                                      .allCategories[index])));
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateCategoryScreen()));
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}
