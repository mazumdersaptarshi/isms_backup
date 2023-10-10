import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/createCourse.dart';
import 'package:isms/models/module.dart';
import 'package:isms/models/slide.dart';
import 'package:isms/moduleManagement/createModule.dart';
import 'package:isms/screens/coursesListScreen.dart';
import 'package:isms/utitlityFunctions/generateRandom.dart';
import 'package:provider/provider.dart';
import 'package:isms/models/course.dart';

class SlidesCreationProvider with ChangeNotifier {
  List<Slide> slidesList = [];

  addSlideToList(Slide slide) {
    slidesList.add(slide);
    notifyListeners();
  }

  clearSlidesList() {
    slidesList.clear();
    notifyListeners();
  }
}

class CreateSlideScreen extends StatelessWidget {
  CreateSlideScreen({required this.parentModule});
  Module parentModule;
  @override
  Widget build(BuildContext context) {
    return SlideFormContainer(parentModule: parentModule);
  }
}

class SlideFormContainer extends StatefulWidget {
  SlideFormContainer({required this.parentModule});

  Module parentModule;
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
              child: Container(
                  height: 500,
                  child: ListView.builder(
                    itemCount: slidesCreationProvider.slidesList.isEmpty
                        ? 1
                        : slidesCreationProvider.slidesList.length + 1,
                    itemBuilder: (context, index) {
                      return SlideForm(
                        slidesCreationProvider: slidesCreationProvider,
                      );
                    },
                  )),
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
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextFormField(
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
                  widget.slidesCreationProvider.addSlideToList(slide);
                  print(widget.slidesCreationProvider.slidesList);
                });
              }
            },
            child: Text('Create slide'),
          ),
        ],
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
