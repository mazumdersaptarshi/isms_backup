import 'package:flutter/material.dart';
import 'package:isms/categoryManagement/categoryProvider.dart';
import 'package:isms/moduleManagement/fetchModules.dart';
import 'package:isms/screens/createCategoryScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/screens/modulesListScreen.dart';
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
                  onTap: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ModulesListScreen(
                                parentCategory:
                                    categoriesProvider.allCategories[index])));
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
