// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';

import '../../../../models/course.dart';
import '../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';

class CreateModuleScreen extends StatelessWidget {
  const CreateModuleScreen({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return CourseModuleForm(course: course);
  }
}

class CourseModuleForm extends StatefulWidget {
  const CourseModuleForm({super.key, required this.course});
  final Course course;
  @override
  State<CourseModuleForm> createState() => _CourseModuleFormState();
}

class _CourseModuleFormState extends State<CourseModuleForm> {
  late ModuleDataMaster moduleDataMaster;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create New Module'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                width: 500,
                decoration: customBoxTheme,
                child: TextFormField(
                  cursorColor: secondaryColor,
                  controller: _titleController,
                  decoration: customInputDecoration(hintText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 500,
                decoration: customBoxTheme,
                child: TextFormField(
                  cursorColor: secondaryColor,
                  controller: _descriptionController,
                  decoration: customInputDecoration(hintText: 'Content'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter module content';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: customElevatedButtonStyle(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Module module = Module(
                        id: generateRandomId(),
                        title: _titleController.text,
                        contentDescription: _descriptionController.text,
                      );
                      bool isModuleCreated =
                          await moduleDataMaster.createModule(module: module);
                      if (isModuleCreated) {
                        if (!context.mounted) return;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const CoursesDisplayScreen()));
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: buttonText,
                  ),
                ),
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
