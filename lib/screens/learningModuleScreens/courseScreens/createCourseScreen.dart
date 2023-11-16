// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';
import 'package:isms/projectModules/courseManagement/coursesDataMaster.dart';
import 'package:isms/sharedWidgets/navIndexTracker.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
    LoggedInState loggedInState = context.watch<LoggedInState>();
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);
    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: (MediaQuery.of(context).size.width > 1000
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width) *
                    0.98,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
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
                  const SizedBox(height: 16),
                  TextFormField(
                    cursorColor: secondaryColor,
                    controller: _descriptionController,
                    decoration: customInputDecoration(hintText: 'Description'),
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter news content';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Course course = Course(
                            id: generateRandomId(),
                            name: _nameController.text,
                            description: _descriptionController.text,
                          );
                          bool isCourseCreated =
                              await CoursesDataMaster.createCourse(
                                  course: course);

                          CoursesDetails coursesDetails = CoursesDetails(
                            course_id: generateRandomId(),
                            course_name: _nameController.text,
                          );
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
