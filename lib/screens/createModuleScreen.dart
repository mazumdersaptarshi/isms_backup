import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/categoryManagement/createCategory.dart';
import 'package:isms/models/module.dart';
import 'package:isms/moduleManagement/createModule.dart';
import 'package:isms/screens/categoriesListScreen.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/customCategory.dart';

import '../main.dart';

class CreateModuleScreen extends StatelessWidget {
  CreateModuleScreen({required this.parentCategory});
  CustomCategory parentCategory;
  @override
  Widget build(BuildContext context) {
    return CategoryModuleForm(parentCategory: parentCategory);
  }
}

class CategoryModuleForm extends StatefulWidget {
  CategoryModuleForm({required this.parentCategory});
  CustomCategory parentCategory;
  @override
  _CategoryModuleFormState createState() => _CategoryModuleFormState();
}

class _CategoryModuleFormState extends State<CategoryModuleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Create New Module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter module content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Module module = Module(
                      id: generateRandomId(),
                      title: _titleController.text,
                      contentDescription: _descriptionController.text,
                    );
                    bool isModuleCreated = await createModule(
                        module: module, category: widget.parentCategory);
                    if (isModuleCreated) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
