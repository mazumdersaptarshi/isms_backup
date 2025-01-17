// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:isms/models/enums.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/examCreationScreen.dart';
import 'package:isms/screens/learningModuleScreens/examScreens/sharedWidgets/optionTile.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';

class QuestionWidget extends StatefulWidget {
  final QUESTIONTYPE questiontype;
  final Function() onQuestionSaved;
  const QuestionWidget(
      {super.key, required this.onQuestionSaved, required this.questiontype});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  List<Map<String, dynamic>> options = [];
  List<bool> optionBools = List.generate(4, (index) => false);
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
    for (var optionController in optionControllers) {
      optionController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customBoxTheme, // Set the background color here
      child: SingleChildScrollView(
        child: Form(
          child: SizedBox(
            height: 450,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0), // Add margin for spacing
                  decoration: BoxDecoration(
                    color: Colors.white, // Set white background color
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  child: TextFormField(
                    controller: questionController,
                    decoration:
                        customInputDecoration(hintText: 'Enter Question'),
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: ListView.builder(
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return OptionTile(
                        controller: optionControllers[index],
                        getTextValue: (optTextValue, optBoolValue) {
                          bool flag = false;

                          try {
                            for (var element in options) {
                              if (element["optionID"] == index) {
                                element["option_value"] = optTextValue;
                                element["option_bool"] = optBoolValue;

                                optionBools[index] = optBoolValue;

                                flag = true;
                              }
                            }
                          } catch (e) {
                            log(e.toString());
                          }
                          if (flag == false) {
                            options.add({
                              "optionID": index,
                              "option_value": optTextValue,
                              "option_bool": optBoolValue,
                            });

                            optionBools.add(optBoolValue);
                          }
                        },
                        optionCreationProvider: optionCreationProviders[index],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity, // Expand to full width
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: customElevatedButtonStyle(),
                    onPressed: () {
                      final newQuestionName = questionController.text;
                      bool questionExists = false;
                      for (final question in allQuestions) {
                        if (question["questionID"] == qID) {
                          questionExists = true;
                          if (newQuestionName != "") {
                            question["questionName"] = newQuestionName;
                          }

                          List<Map<String, dynamic>> tempOptions =
                              question["options"];
                          for (int i = 0; i < tempOptions.length; i++) {
                            var option = tempOptions[i];
                            for (int j = 0; j < options.length; j++) {
                              if (option["optionID"] ==
                                  options[j]["optionID"]) {
                                if (options[j]["option_value"] != null &&
                                    options[j]["option_value"] != "") {
                                  option = options[j];
                                  question["options"][i] = options[j];
                                }
                              }
                            }
                          }

                          break;
                        }
                      }

                      if (questionExists == false) {
                        setState(() {
                          allQuestions.add({
                            "questionID": qID,
                            "questionName": newQuestionName,
                            "options": options,
                          });
                        });
                      }
                    },
                    child: Text(
                      "Save Question",
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
