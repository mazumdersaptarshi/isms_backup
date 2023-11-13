// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/models/newExam.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:isms/utilityWidgets/questionWidget.dart';
import 'package:provider/provider.dart';

import '../../../models/course.dart';
import '../../../models/module.dart';
import '../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../projectModules/courseManagement/examManagement/examDataMaster.dart';
import '../../../sharedWidgets/navIndexTracker.dart';

List<Map<String, dynamic>> allQuestions = [];

enum EXAMTYPE { courseExam, moduleExam }

class ExamCreation extends StatefulWidget {
  const ExamCreation(
      {super.key, required this.course, required this.examtype, this.module});
  final Course course;
  final EXAMTYPE examtype;
  final Module? module;
  @override
  ExamCreationState createState() => ExamCreationState();
}

class ExamCreationState extends State<ExamCreation> {
  int noOfQuestions = 1;
  late ExamDataMaster examDataMaster;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController passingMarksController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    titleController.dispose();
    passingMarksController.dispose();
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      noOfQuestions++;
    });
  }

  @override
  Widget build(BuildContext context) {
    NavIndexTracker.setNavDestination(navDestination: NavDestinations.other);
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    examDataMaster =
        ExamDataMaster(course: widget.course, coursesProvider: coursesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exam'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 500,
                  decoration: customBoxTheme,
                  child: TextFormField(
                    controller: titleController,
                    decoration:
                        customInputDecoration(hintText: "Enter title for exam"),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: 500,
                  decoration: customBoxTheme,
                  child: TextFormField(
                    controller: passingMarksController,
                    decoration: customInputDecoration(
                        hintText: "Enter passing marks for exam"),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    width: 500,
                    height: 460,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: noOfQuestions,
                      itemBuilder: (context, index) => QuestionWidget(
                        onQuestionSaved: () {},
                        questiontype: QUESTIONTYPE.checkbox,
                      ),
                    )),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: customElevatedButtonStyle(),
                    onPressed: () {
                      _addNewQuestion();
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    },
                    child: Text(
                      'Add a question',
                      style: buttonText,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: customElevatedButtonStyle(),
                    onPressed: () {
                      if (kDebugMode) {
                        print(allQuestions);
                      }

                      NewExam newExam = NewExam(
                          examID: generateRandomId(),
                          passingMarks: int.parse(passingMarksController.text),
                          title: titleController.text,
                          questionAnswerSet: allQuestions);

                      if (widget.examtype == EXAMTYPE.courseExam) {
                        debugPrint("CREATE EXAMM ${widget.course.exams}");
                        examDataMaster.createCourseExam(exam: newExam);
                      } else if (widget.examtype == EXAMTYPE.moduleExam) {
                        examDataMaster.createModuleExam(
                            module: widget.module!, exam: newExam);
                        allQuestions.clear();
                      }

                      allQuestions.clear();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CoursesDisplayScreen()));
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
    );
  }
}

class ExamCreationProvider with ChangeNotifier {
  // List<Map<String, dynamic>>
}
