import 'package:flutter/material.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/utilityWidgets/optionTile.dart';
import 'package:isms/utilityWidgets/questionWidget.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';

List<Map<String, dynamic>> allQuestions = [];

class ExamCreation extends StatefulWidget {
  ExamCreation({Key? key}) : super(key: key);
  int noOfQuestions = 1;
  @override
  ExamCreationState createState() => ExamCreationState();
}

class ExamCreationState extends State<ExamCreation> {
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
      widget.noOfQuestions++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: "Enter title for exam",
                  ),
                ),
                TextFormField(
                  controller: passingMarksController,
                  decoration: InputDecoration(
                    hintText: "Enter passing marks for exam",
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                    height: 460,
                    color: Colors.orangeAccent,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: widget.noOfQuestions,
                      itemBuilder: (context, index) => QuestionWidget(
                        onQuestionSaved: () {},
                        questiontype: QUESTIONTYPE.Checkbox,
                      ),
                    )),
                ElevatedButton(
                  onPressed: () {
                    _addNewQuestion();
                    _controller.jumpTo(_controller.position.maxScrollExtent);
                  },
                  child: const Text('Add a question'),
                ),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        print(allQuestions);
      },
      child: const Text('Submit'),
    );
  }
}
