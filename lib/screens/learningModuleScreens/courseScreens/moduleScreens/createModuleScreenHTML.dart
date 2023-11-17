// Ensure you have all necessary imports
// ignore_for_file: file_names

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class CreateModuleScreenHTML extends StatelessWidget {
  const CreateModuleScreenHTML({super.key, required this.course});
  final Course course;

  @override
  Widget build(BuildContext context) {
    return _CourseModuleFormHTML(course: course);
  }
}

class _CourseModuleFormHTML extends StatefulWidget {
  const _CourseModuleFormHTML({required this.course});
  final Course course;

  @override
  State<_CourseModuleFormHTML> createState() => _CourseModuleFormHTMLState();
}

class _CourseModuleFormHTMLState extends State<_CourseModuleFormHTML> {
  late ModuleDataMaster moduleDataMaster;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final HtmlEditorController _htmlEditorController = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    return Scaffold(
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    cursorColor: secondaryColor,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Title', // Adds a label above the input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: secondaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // You can add additional decoration as needed
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    cursorColor: secondaryColor,
                    controller: _contentController,
                    decoration: InputDecoration(
                      labelText:
                          'Short Description', // Adds a label above the input field
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: secondaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      // Additional decoration can be added as needed
                    ),
                    maxLines:
                        4, // Increase the number of lines for content input
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a short description';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                HtmlEditor(
                  controller: _htmlEditorController,
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: 'Your text here...',
                    shouldEnsureVisible: true,
                    //initialText: "<p>text content initial, if any</p>",
                  ),
                  htmlToolbarOptions: HtmlToolbarOptions(
                    toolbarPosition: ToolbarPosition.aboveEditor, //by default
                    toolbarType: ToolbarType.nativeScrollable, //by default
                    onButtonPressed: (ButtonType type, bool? status,
                        Function? updateStatus) {
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      final storageRef = FirebaseStorage.instance
                          .ref()
                          .child(widget.course.name)
                          .child('modules_images')
                          .child(file.name);

                      // Upload the image to Firebase Storage
                      UploadTask uploadTask = storageRef.putData(file.bytes!);

                      TaskSnapshot taskSnapshot =
                          await uploadTask.whenComplete(() => null);
                      final imageUrl = await taskSnapshot.ref.getDownloadURL();
                      String imgTag =
                          '<img class="myImg" src="$imageUrl"  style="object-fit: cover; width:100%" />';

                      String currentContent =
                          await _htmlEditorController.getText();

                      // Append the image tag with the modified dimensions and the Firebase Storage URL to the current content
                      String modifiedContent = '$currentContent $imgTag';

                      _htmlEditorController.setText(modifiedContent);

                      return false;
                    },
                  ),
                  otherOptions: const OtherOptions(height: 700),
                  callbacks: Callbacks(
                      onBeforeCommand: (String? currentHtml) {
                        log('html before change is $currentHtml');
                      },
                      onChangeContent: (String? changed) {
                        log('content changed to $changed');
                      },
                      onChangeCodeview: (String? changed) {
                        log('code changed to $changed');
                      },
                      onChangeSelection: (EditorSettings settings) {
                        log('parent element is ${settings.parentElement}');
                        log('font name is ${settings.fontName}');
                      },
                      onDialogShown: () {
                        log('dialog shown');
                      },
                      onEnter: () {
                        log('enter/return pressed');
                      },
                      onFocus: () {
                        log('editor focused');
                      },
                      onBlur: () {
                        log('editor unfocused');
                      },
                      onBlurCodeview: () {
                        log('codeview either focused or unfocused');
                      },
                      onInit: () {
                        log('init');
                      },
                      //this is commented because it overrides the default Summernote handlers
                      /*onImageLinkInsert: (String? url) {
                    debugPrint(url ?? "unknown url");
                  },
                  onImageUpload: (FileUpload file) async {
                    debugPrint(file.name);
                    debugPrint(file.size);
                    debugPrint(file.type);
                    debugPrint(file.base64);
                  },*/
                      onImageUploadError: (FileUpload? file, String? base64Str,
                          UploadError error) {},
                      onKeyDown: (int? keyCode) {
                        debugPrint('$keyCode key downed');
                        log('current character count: ${_htmlEditorController.characterCount}');
                      },
                      onKeyUp: (int? keyCode) {
                        log('$keyCode key released');
                      },
                      onMouseDown: () {
                        log('mouse downed');
                      },
                      onMouseUp: () {
                        log('mouse released');
                      },
                      onNavigationRequestMobile: (String url) {
                        log(url);
                        return NavigationActionPolicy.ALLOW;
                      },
                      onPaste: () {
                        log('pasted into editor');
                      },
                      onScroll: () {
                        log('editor scrolled');
                      }),
                  plugins: [
                    SummernoteAtMention(
                        getSuggestionsMobile: (String value) {
                          var mentions = <String>['test1', 'test2', 'test3'];
                          return mentions
                              .where((element) => element.contains(value))
                              .toList();
                        },
                        mentionsWeb: ['test1', 'test2', 'test3'],
                        onSelect: (String value) {
                          debugPrint(value);
                        }),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                    style: customElevatedButtonStyle(),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String htmlContent =
                            await _htmlEditorController.getText();
                        Module module = Module(
                          id: generateRandomId(),
                          title: _titleController.text,
                          contentDescription: _contentController.text,
                          additionalInfo: htmlContent,
                        );
                        bool isModuleCreated =
                            await moduleDataMaster.createModule(module: module);
                        if (isModuleCreated) {
                          if (!context.mounted) return;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const CoursesDisplayScreen()));
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
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
