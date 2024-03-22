import 'package:flutter/material.dart';
import 'package:isms/models/course/course_exam_relationship.dart'; // Ensure this import matches your project structure.

class MultiSelectDropdown extends StatefulWidget {
  final List<CourseExamRelationship> courses;

  const MultiSelectDropdown({Key? key, required this.courses}) : super(key: key);

  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<CourseExamRelationship> _selectedCourses = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make the modal adapt to content
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true, // Needed to make the ListView behave in the modal
              itemCount: widget.courses.length,
              itemBuilder: (context, index) {
                CourseExamRelationship course = widget.courses[index];
                return _controller.text.isEmpty ||
                        course.courseTitle!.toLowerCase().contains(_controller.text.toLowerCase())
                    ? CheckboxListTile(
                        title: Text(course.courseTitle ?? 'No Title'), // Added null check
                        subtitle: Text('ID: ${course.courseId}'),
                        value: _selectedCourses.contains(course),
                        onChanged: (bool? selected) {
                          setState(() {
                            if (selected == true) {
                              _selectedCourses.add(course);
                            } else {
                              _selectedCourses.remove(course);
                            }
                          });
                        },
                      )
                    : Container();
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_selectedCourses);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
