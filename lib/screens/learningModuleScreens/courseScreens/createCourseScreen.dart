import 'package:flutter/material.dart';

import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/models/course.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';

import '../../../projectModules/courseManagement/createCourse.dart';

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
  _CourseCreationFormState createState() => _CourseCreationFormState();
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter news content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Course course = Course(
                      id: generateRandomId(),
                      name: _nameController.text,
                    );
                    bool isCourseCreated = await createCourse(course: course);

                    CoursesDetails coursesDetails = CoursesDetails(
                      course_id: generateRandomId(),
                      course_name: _nameController.text,
                      number_of_modules: 0,
                      number_of_exams: 0,
                    );
                    bool isCourseAdminConsoleCreated =
                        await createCourseAdminConsole(
                            coursesDetails: coursesDetails);
                    if (isCourseCreated) {
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Submit'),
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
