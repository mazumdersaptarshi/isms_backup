// ignore_for_file: file_names

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/courseManagement/moduleManagement/slideManagement/slidesDataMaster.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesCreationProvider.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:isms/utilityFunctions/platformCheck.dart';
import 'package:provider/provider.dart';

class CreateSlideScreen extends StatelessWidget {
  const CreateSlideScreen(
      {super.key, required this.course, required this.module});
  final Course course;
  final Module module;
  @override
  Widget build(BuildContext context) {
    context.watch<LoggedInState>();

    return SlideFormContainer(
      course: course,
      module: module,
    );
  }
}

class SlideFormContainer extends StatefulWidget {
  const SlideFormContainer(
      {super.key, required this.course, required this.module});

  final Course course;
  final Module module;

  @override
  State<SlideFormContainer> createState() => _SlideFormContainerState();
}

class _SlideFormContainerState extends State<SlideFormContainer> {
  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    SlidesDataMaster slidesDataMaster = SlidesDataMaster(
        course: widget.course,
        coursesProvider: coursesProvider,
        module: widget.module);

    return ChangeNotifierProvider(
      create: (_) => SlidesCreationProvider(),
      child: Consumer<SlidesCreationProvider>(
        builder: (BuildContext context,
            SlidesCreationProvider slidesCreationProvider, Widget? child) {
          LoggedInState loggedInState = context.watch<LoggedInState>();
          return Scaffold(
            appBar:
                PlatformCheck.topNavBarWidget(loggedInState, context: context),
            bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState,
                context: context),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: slidesCreationProvider.noOfForms,
                          itemBuilder: (context, index) {
                            return const SlideForm();
                          },
                        )),
                  ),
                  ElevatedButton(
                      style: customElevatedButtonStyle(),
                      onPressed: () async {
                        await slidesDataMaster.createSlides(
                            slides: slidesCreationProvider.slidesList);

                        slidesCreationProvider.clearSlidesList();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                      child: const Text("Finish creating slides"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SlideForm extends StatefulWidget {
  const SlideForm({super.key});

  @override
  State<SlideForm> createState() => _SlideFormState();
}

class _SlideFormState extends State<SlideForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isSlideAdded = false;
  String result = '';
  final HtmlEditorController controller = HtmlEditorController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SlidesCreationProvider slidesCreationProvider =
        context.watch<SlidesCreationProvider>();
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width - 30,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter a title';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    if (!kIsWeb) {
                      controller.clearFocus();
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      HtmlEditor(
                        controller: controller,
                        htmlEditorOptions: const HtmlEditorOptions(
                          hint: 'Your text here...',
                          shouldEnsureVisible: true,
                          //initialText: "<p>text content initial, if any</p>",
                        ),
                        htmlToolbarOptions: HtmlToolbarOptions(
                          toolbarPosition:
                              ToolbarPosition.aboveEditor, //by default
                          toolbarType:
                              ToolbarType.nativeScrollable, //by default
                          onButtonPressed: (ButtonType type, bool? status,
                              Function? updateStatus) {
                            return true;
                          },
                          onDropdownChanged: (DropdownType type,
                              dynamic changed,
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
                                .child('images')
                                .child(file.name);
                            //
                            // Upload the image to Firebase Storage
                            UploadTask uploadTask =
                                storageRef.putData(file.bytes!);

                            TaskSnapshot taskSnapshot =
                                await uploadTask.whenComplete(() => null);
                            final imageUrl =
                                await taskSnapshot.ref.getDownloadURL();
                            String imgTag =
                                '<img class="myImg" src="$imageUrl"  style="object-fit: cover; width:100%" />';

                            String currentContent = await controller.getText();

                            // Append the image tag with the modified dimensions and the Firebase Storage URL to the current content
                            String modifiedContent = '$currentContent $imgTag';

                            controller.setText(modifiedContent);

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
                            onImageUploadError: (FileUpload? file,
                                String? base64Str, UploadError error) {},
                            onKeyDown: (int? keyCode) {
                              log('$keyCode key downed');
                              log('current character count: ${controller.characterCount}');
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
                                var mentions = <String>[
                                  'test1',
                                  'test2',
                                  'test3'
                                ];
                                return mentions
                                    .where((element) => element.contains(value))
                                    .toList();
                              },
                              mentionsWeb: ['test1', 'test2', 'test3'],
                              onSelect: (String value) {
                                log(value);
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: ElevatedButton(
                                style: customElevatedButtonStyle(),
                                onPressed: () {
                                  controller.undo();
                                },
                                child: const Text('Undo',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: ElevatedButton(
                                style: customElevatedButtonStyle(),
                                onPressed: () {
                                  controller.clear();
                                },
                                child: const Text('Reset',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Flexible(
                              child: ElevatedButton(
                                style: customElevatedButtonStyle(),
                                onPressed: () async {
                                  var txt = await controller.getText();

                                  setState(() {
                                    result = txt;
                                    // widget.setFinalHTMLBody(result);
                                    // saveToFirebase(result);
                                  });
                                  if (_formKey.currentState!.validate()) {
                                    Slide slide = Slide(
                                      id: generateRandomId(),
                                      title: _titleController.text,
                                      content: result,
                                    );
                                    setState(() {
                                      if (isSlideAdded == false) {
                                        slidesCreationProvider
                                            .addSlideToList(slide);
                                        isSlideAdded = true;
                                      }
                                      slidesCreationProvider.incrementFormNo();
                                    });
                                  }
                                },
                                child: const Text(
                                  'Save slide',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: customElevatedButtonStyle(),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Slide slide = Slide(
                        id: generateRandomId(),
                        title: _titleController.text,
                        content: _descriptionController.text,
                      );
                      setState(() {
                        if (isSlideAdded == false) {
                          slidesCreationProvider.addSlideToList(slide);
                          isSlideAdded = true;
                        }
                      });
                    }
                  },
                  child: const Text('Add new slide'),
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
    _descriptionController.dispose();
    super.dispose();
  }
}
