import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/createCourse.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/moduleManagement/createModule.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/slideManagement/createSlide.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/course.dart';
import 'package:isms/slideManagement/slidesCreationProvider.dart';

class CreateSlideScreen extends StatelessWidget {
  CreateSlideScreen({required this.parentModule, required this.parentCourse});
  Module parentModule;
  Course parentCourse;
  @override
  Widget build(BuildContext context) {
    return SlideFormContainer(
      parentModule: parentModule,
      parentCourse: parentCourse,
    );
  }
}

class SlideFormContainer extends StatefulWidget {
  SlideFormContainer({required this.parentModule, required this.parentCourse});

  Module parentModule;
  Course parentCourse;
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
                            module: widget.parentModule,
                            course: widget.parentCourse,
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
          color: Colors.blue.shade400,
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
              Expanded(
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Content'),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter slide content';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
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
                child: Text('Create slide'),
              ),
              ElevatedButton(
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
                        print(
                            "${widget.slidesCreationProvider.slidesList},,, ${isSlideAdded}");
                        isSlideAdded = true;
                      }
                      widget.slidesCreationProvider.incrementFormNo();
                    });
                  }
                },
                child: Text('Add new Slide'),
              ),
            ],
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
