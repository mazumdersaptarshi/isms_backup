import 'package:flutter/material.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/screens/examCreation.dart';
import 'package:isms/utilityWidgets/optionTile.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';

class QuestionWidget extends StatefulWidget {
  QUESTIONTYPE questiontype;
  final Function() onQuestionSaved;
  List<Map<String, dynamic>> options = [];
  List<bool> optionBools = List.generate(4, (index) => false);
  QuestionWidget(
      {super.key, required this.onQuestionSaved, required this.questiontype});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<String> answers = [];
  final String qID = generateRandomId();
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers =
      List.generate(4, (index) => TextEditingController());
  List<OptionCreationProvider> optionCreationProviders =
      List.generate(4, (index) => OptionCreationProvider());

  @override
  void dispose() {
    super.dispose();
    questionController.dispose();
    optionControllers.forEach((optionController) {
      optionController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        child: Container(
          height: 300,
          child: Column(
            children: [
              TextFormField(
                controller: questionController,
              ),
              Container(
                height: 200,
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return OptionTile(
                      controller: optionControllers[index]!,
                      getTextValue: (optTextValue, optBoolValue) {
                        bool flag = false;
                        try {
                          widget.options.forEach((element) {
                            if (element["optionID"] == index) {
                              element["option_value"] = optTextValue;
                              element["option_bool"] = optBoolValue;

                              widget.optionBools[index] = optBoolValue;

                              flag = true;
                            }

                            print("HHH :${element}");
                          });
                        } catch (e) {}
                        if (flag == false) {
                          widget.options.add({
                            "optionID": index,
                            "option_value": optTextValue,
                            "option_bool": optBoolValue,
                          });

                          widget.optionBools.add(optBoolValue);
                        }
                      },
                      optionCreationProvider: optionCreationProviders[index],
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newQuestionName = questionController.text;
                  bool questionExists = false;
                  for (final question in allQuestions) {
                    if (question["questionID"] == qID) {
                      questionExists = true;
                      print("QUESTION EXISTSSSSS");
                      break;
                    }
                  }

                  if (!questionExists) {
                    setState(() {
                      allQuestions.add({
                        "questionID": qID,
                        "questionName": newQuestionName,
                        "options": widget.options,
                      });
                      print(allQuestions);
                    });
                  } else {
                    allQuestions.forEach((question) {
                      if (question["questionID"] == qID) {
                        question["questionName"] = newQuestionName;
                        question["options"] = widget.options;
                      }
                    });
                  }
                },
                child: Text("Save Question"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DropdownButton<QUESTIONTYPE> buildQuestionTypeDropdown() {
    return DropdownButton<QUESTIONTYPE>(
      value: QUESTIONTYPE.Checkbox,
      onChanged: (QUESTIONTYPE? newValue) {
        setState(() {});
      },
      items: QUESTIONTYPE.values.map<DropdownMenuItem<QUESTIONTYPE>>(
        (QUESTIONTYPE value) {
          return DropdownMenuItem<QUESTIONTYPE>(
            value: value,
            child: Text(EnumToString.getStringValue(value)!),
          );
        },
      ).toList(),
    );
  }
}
