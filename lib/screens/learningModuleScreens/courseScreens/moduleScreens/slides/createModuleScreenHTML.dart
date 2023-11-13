// Ensure you have all necessary imports
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/moduleDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
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
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    moduleDataMaster = ModuleDataMaster(
        course: widget.course, coursesProvider: coursesProvider);

    // Use MediaQuery to get the screen width

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Create New Module'),
      ),
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
                      hintText: 'Title',
                      labelText:
                          'Module Title', // Adds a label above the input field
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
                      hintText: 'Short Description',
                      labelText:
                          'Module Content', // Adds a label above the input field
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
                      debugPrint(
                          "button '${type.name}' pressed, the current selected status is $status");
                      return true;
                    },
                    onDropdownChanged: (DropdownType type, dynamic changed,
                        Function(dynamic)? updateSelectedItem) {
                      debugPrint("dropdown '${type.name}' changed to $changed");
                      return true;
                    },
                    mediaLinkInsertInterceptor:
                        (String url, InsertFileType type) {
                      debugPrint(url);
                      return true;
                    },
                    mediaUploadInterceptor:
                        (PlatformFile file, InsertFileType type) async {
                      debugPrint(
                          "UPLOADDED IMAGGGEE :  ${file.name}"); //filename
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
                  callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                    debugPrint('html before change is $currentHtml');
                  }, onChangeContent: (String? changed) {
                    debugPrint('content changed to $changed');
                  }, onChangeCodeview: (String? changed) {
                    debugPrint('code changed to $changed');
                  }, onChangeSelection: (EditorSettings settings) {
                    debugPrint('parent element is ${settings.parentElement}');
                    debugPrint('font name is ${settings.fontName}');
                  }, onDialogShown: () {
                    debugPrint('dialog shown');
                  }, onEnter: () {
                    debugPrint('enter/return pressed');
                  }, onFocus: () {
                    debugPrint('editor focused');
                  }, onBlur: () {
                    debugPrint('editor unfocused');
                  }, onBlurCodeview: () {
                    debugPrint('codeview either focused or unfocused');
                  }, onInit: () {
                    debugPrint('init');
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
                          UploadError error) {
                    debugPrint(error.name);
                    debugPrint(base64Str ?? '');
                    if (file != null) {
                      if (kDebugMode) {
                        print(file.name);
                        print(file.size);
                        print(file.type);
                      }
                    }
                  }, onKeyDown: (int? keyCode) {
                    debugPrint('$keyCode key downed');
                    debugPrint(
                        'current character count: ${_htmlEditorController.characterCount}');
                  }, onKeyUp: (int? keyCode) {
                    debugPrint('$keyCode key released');
                  }, onMouseDown: () {
                    debugPrint('mouse downed');
                  }, onMouseUp: () {
                    debugPrint('mouse released');
                  }, onNavigationRequestMobile: (String url) {
                    debugPrint(url);
                    return NavigationActionPolicy.ALLOW;
                  }, onPaste: () {
                    debugPrint('pasted into editor');
                  }, onScroll: () {
                    debugPrint('editor scrolled');
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
