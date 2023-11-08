// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';
import 'package:isms/screens/login/loginScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';

import '../../../projectModules/courseManagement/coursesDataMaster.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return const LoginPage();
    }

    return const CourseCreationForm();
  }
}

class CourseCreationForm extends StatefulWidget {
  const CourseCreationForm({super.key});

  @override
  State<CourseCreationForm> createState() => _CourseCreationFormState();
}

class _CourseCreationFormState extends State<CourseCreationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create New Course'),
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
                  controller: _nameController,
                  cursorColor: secondaryColor,
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
                      return 'Please enter news content';
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
                      Course course = Course(
                        id: generateRandomId(),
                        name: _nameController.text,
                      );
                      bool isCourseCreated =
                          await CoursesDataMaster.createCourse(course: course);

                      CoursesDetails coursesDetails = CoursesDetails(
                        course_id: generateRandomId(),
                        course_name: _nameController.text,
                        number_of_modules: 0,
                        number_of_exams: 0,
                      );
                      /*bool isCourseAdminConsoleCreated =*/
                      await CoursesDataMaster.createCourseAdminConsole(
                          coursesDetails: coursesDetails);
                      if (isCourseCreated) {
                        if (!context.mounted) return;
                        Navigator.pop(context);
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
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
