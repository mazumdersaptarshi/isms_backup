import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/createCourse.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/course.dart';

import '../main.dart';

class CreateCourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CourseCreationForm();
  }
}

class CourseCreationForm extends StatefulWidget {
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Create New Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
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
                    return 'Please enter news content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Course course = Course(
                      id: generateRandomId(),
                      name: _nameController.text,
                    );
                    bool isCourseCreated = await createCourse(course: course);
                    if (isCourseCreated) {
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
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
