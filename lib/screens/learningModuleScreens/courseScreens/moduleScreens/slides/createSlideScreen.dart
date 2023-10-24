import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/utilityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/course.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../../projectModules/courseManagement/coursesProvider.dart';
import '../../../../../projectModules/courseManagement/moduleManagement/slideManagement/createSlide.dart';
import '../../../../../projectModules/courseManagement/moduleManagement/slideManagement/slidesCreationProvider.dart';

class CreateSlideScreen extends StatelessWidget {
  CreateSlideScreen({required this.courseIndex, required this.moduleIndex});
  int courseIndex;
  int moduleIndex;
  @override
  Widget build(BuildContext context) {
    return SlideFormContainer(
      courseIndex: courseIndex,
      moduleIndex: moduleIndex,
    );
  }
}

class SlideFormContainer extends StatefulWidget {
  SlideFormContainer({required this.courseIndex, required this.moduleIndex});

  int courseIndex;
  int moduleIndex;
  @override
  _SlideFormContainerState createState() => _SlideFormContainerState();
}

class _SlideFormContainerState extends State<SlideFormContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  // try GPT??
  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    return Consumer<SlidesCreationProvider>(
      builder: (BuildContext context,
          SlidesCreationProvider slidesCreationProvider, Widget? child) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  slidesCreationProvider.clearSlidesList();
                  Navigator.pop(context);
                },
              ),
              title: Text('Create New Slide'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: slidesCreationProvider.noOfForms,
                          itemBuilder: (context, index) {
                            return SlideForm(
                              slidesCreationProvider: slidesCreationProvider,
                            );
                          },
                        )),
                  ),
                  FilledButton(
                      onPressed: () async {
                        await createSlides(
                            courseIndex: widget.courseIndex,
                            coursesProvider: coursesProvider,
                            moduleIndex: widget.moduleIndex,
                            slides: slidesCreationProvider.slidesList);

                        slidesCreationProvider.clearSlidesList();
                        Navigator.pop(context);
                      },
                      child: Text("Finish creating slides"))
                ],
              ),
            ));
      },
    );
  }
}

class SlideForm extends StatefulWidget {
  SlideForm({super.key, required this.slidesCreationProvider});
  SlidesCreationProvider slidesCreationProvider;

  @override
  State<SlideForm> createState() => _SlideFormState();
}

class _SlideFormState extends State<SlideForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isSlideAdded = false;
  String contentBody = "";

  String result = '';
  final HtmlEditorController controller = HtmlEditorController();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        width: MediaQuery.of(context).size.width - 50,
        decoration: BoxDecoration(
            color: Color.fromRGBO(190, 213, 207, 100),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),
                // Expanded(
                //   child: TextFormField(
                //     controller: _descriptionController,
                //     decoration: InputDecoration(labelText: 'Content'),
                //     maxLines: 4,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter slide content';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
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
                        htmlEditorOptions: HtmlEditorOptions(
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
                            print(
                                "button '${describeEnum(type)}' pressed, the current selected status is $status");
                            return true;
                          },
                          onDropdownChanged: (DropdownType type,
                              dynamic changed,
                              Function(dynamic)? updateSelectedItem) {
                            print(
                                "dropdown '${describeEnum(type)}' changed to $changed");
                            return true;
                          },
                          mediaLinkInsertInterceptor:
                              (String url, InsertFileType type) {
                            print(url);
                            return true;
                          },
                          mediaUploadInterceptor:
                              (PlatformFile file, InsertFileType type) async {
                            print(
                                "UPLOADDED IMAGGGEE :  ${file.name}"); //filename
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
                        otherOptions: OtherOptions(height: 550),
                        callbacks: Callbacks(
                            onBeforeCommand: (String? currentHtml) {
                          print('html before change is $currentHtml');
                        }, onChangeContent: (String? changed) {
                          print('content changed to $changed');
                        }, onChangeCodeview: (String? changed) {
                          print('code changed to $changed');
                        }, onChangeSelection: (EditorSettings settings) {
                          print('parent element is ${settings.parentElement}');
                          print('font name is ${settings.fontName}');
                        }, onDialogShown: () {
                          print('dialog shown');
                        }, onEnter: () {
                          print('enter/return pressed');
                        }, onFocus: () {
                          print('editor focused');
                        }, onBlur: () {
                          print('editor unfocused');
                        }, onBlurCodeview: () {
                          print('codeview either focused or unfocused');
                        }, onInit: () {
                          print('init');
                        },
                            //this is commented because it overrides the default Summernote handlers
                            /*onImageLinkInsert: (String? url) {
                  print(url ?? "unknown url");
                },
                onImageUpload: (FileUpload file) async {
                  print(file.name);
                  print(file.size);
                  print(file.type);
                  print(file.base64);
                },*/
                            onImageUploadError: (FileUpload? file,
                                String? base64Str, UploadError error) {
                          print(describeEnum(error));
                          print(base64Str ?? '');
                          if (file != null) {
                            print(file.name);
                            print(file.size);
                            print(file.type);
                          }
                        }, onKeyDown: (int? keyCode) {
                          print('$keyCode key downed');
                          print(
                              'current character count: ${controller.characterCount}');
                        }, onKeyUp: (int? keyCode) {
                          print('$keyCode key released');
                        }, onMouseDown: () {
                          print('mouse downed');
                        }, onMouseUp: () {
                          print('mouse released');
                        }, onNavigationRequestMobile: (String url) {
                          print(url);
                          return NavigationActionPolicy.ALLOW;
                        }, onPaste: () {
                          print('pasted into editor');
                        }, onScroll: () {
                          print('editor scrolled');
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
                                print(value);
                              }),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                controller.undo();
                              },
                              child: Text('Undo',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                controller.clear();
                              },
                              child: Text('Reset',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.green),
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
                                      widget.slidesCreationProvider
                                          .addSlideToList(slide);
                                      print(
                                          "${widget.slidesCreationProvider.slidesList},,, ${isSlideAdded}");
                                      isSlideAdded = true;
                                    }
                                    widget.slidesCreationProvider
                                        .incrementFormNo();
                                  });
                                }
                              },
                              child: Text(
                                'Save slide',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Slide slide = Slide(
                          id: generateRandomId(),
                          title: _titleController.text,
                          content: _descriptionController.text,
                        );
                        setState(() {
                          if (isSlideAdded == false) {
                            widget.slidesCreationProvider.addSlideToList(slide);
                            isSlideAdded = true;
                            print(widget.slidesCreationProvider.slidesList);
                          }
                        });
                      }
                    },
                    child: Text('Add empty slide'),
                  ),
                ),
                // Container(
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: () async {
                //       if (_formKey.currentState!.validate()) {
                //         Slide slide = Slide(
                //           id: generateRandomId(),
                //           title: _titleController.text,
                //           content: contentBody,
                //         );
                //         setState(() {
                //           if (isSlideAdded == false) {
                //             widget.slidesCreationProvider.addSlideToList(slide);
                //             print(
                //                 "${widget.slidesCreationProvider.slidesList},,, ${isSlideAdded}");
                //             isSlideAdded = true;
                //           }
                //           widget.slidesCreationProvider.incrementFormNo();
                //         });
                //       }
                //     },
                //     child: Text('Add new Slide'),
                //   ),
                // ),
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
