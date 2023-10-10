import 'package:flutter/material.dart';
import 'package:isms/categoryManagement/categoryProvider.dart';
import 'package:isms/models/customCategory.dart';
import 'package:isms/models/module.dart';
import 'package:isms/moduleManagement/fetchModules.dart';
import 'package:isms/screens/createCategoryScreen.dart';
import 'package:isms/screens/createModuleScreen.dart';
import 'package:isms/sharedWidgets/popupDialog.dart';
import 'package:provider/provider.dart';

class ModulesListScreen extends StatefulWidget {
  ModulesListScreen({super.key, required this.parentCategory});
  CustomCategory parentCategory;

  @override
  State<ModulesListScreen> createState() => _ModulesListScreenState();
}

class _ModulesListScreenState extends State<ModulesListScreen> {
  bool isModulesFetched = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchModules(category: widget.parentCategory).then((value) {
        setState(() {
          isModulesFetched = true;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isModulesFetched) {
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: ListView.builder(
            itemCount: widget.parentCategory.modules?.length,
            itemBuilder: (context, index) {
              Module module = widget.parentCategory.modules![index];
              return ListTile(
                title: Text(module.title),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateModuleScreen(
                        parentCategory: widget.parentCategory)));
          },
          child: Icon(Icons.add),
        ),
      );
    } else {
      return Container(
        child: const AlertDialog(
          title: Text("Fetching modules"),
          content: Align(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator()),
        ),
      );
    }
  }
}
