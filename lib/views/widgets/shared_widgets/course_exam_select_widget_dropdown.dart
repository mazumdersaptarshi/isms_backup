import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/models/course/course_exam_relationship.dart';

class CourseExamSelectWidget extends StatefulWidget {
  final Function(String?) onExamSelected;

  const CourseExamSelectWidget({super.key, required this.onExamSelected});

  @override
  State<CourseExamSelectWidget> createState() => _CourseExamSelectWidgetState();
}

class _CourseExamSelectWidgetState extends State<CourseExamSelectWidget> {
  Map<String, dynamic> coursesAndExams = {
    'Intro to Python 1': [
      {'examId': 'py102ex', 'examName': 'Assesment 1'},
      {'examId': 'cv101ex', 'examName': 'Assesment 2'},
    ],
    'Intro to Data Science': [
      {'examId': 'py103ds', 'examName': 'Assesment 1'},
      {'examId': 'js101ex', 'examName': 'Assesment 2'},
    ],
    // Add more courses and exams as needed
  };

  List<CourseExamRelationship> courseExams = [];

  String? selectedCourse;
  String? selectedExam;
  List<Map<String, dynamic>> exams = [];

  void updateExams(String? course) {
    exams = course != null ? coursesAndExams[course] ?? [] : [];
    selectedExam = null; // Reset selected exam when course changes
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
        SizedBox(
          height: 10,
        ),

        CustomCourseDropdownWidget(),
        if (selectedCourse != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Exam',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 10,
              ),
              CustomExamDropdownWidget(),
            ],
          ), // Show exam dropdown only if a course is selected
      ],
    );
  }

  Widget CustomCourseDropdownWidget() {
    List<String> displayItems = coursesAndExams.entries.map((entry) => "${entry.key}").toList();

    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200, // Set your minimum width here
          maxWidth: 500, // Set your maximum width here
        ),
        child: CustomDropdown<String>.search(
          items: displayItems,
          hintText: 'Select Course',
          overlayHeight: 342,
          onChanged: (value) {
            String? selectedKey;
            for (var entry in coursesAndExams.entries) {
              if (entry.key == value) {
                selectedKey = entry.key;
                break;
              }
            }
            setState(() {
              selectedCourse = selectedKey;
              updateExams(selectedKey);
            });
          },
          decoration: customDropdownDecoration,
        ),
      ),
    );
  }

  Widget CustomExamDropdownWidget() {
    List<String> displayItems = exams.map((entry) => "${entry['examName']}").toList();
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 200, // Set your minimum width here
          maxWidth: 500, // Set your maximum width here
        ),
        child: CustomDropdown<String>.search(
          hintText: 'Select Exam',
          items: displayItems,
          onChanged: (value) {
            String? selectedKey;
            for (var entry in exams) {
              if (entry['examName'] == value) {
                selectedKey = entry['examId'];
                break;
              }
            }
            setState(
              () {
                selectedExam = selectedKey;
                widget.onExamSelected(selectedExam);
              },
            );
          },
          decoration: customDropdownDecoration,
        ),
      ),
    );
  }
}
