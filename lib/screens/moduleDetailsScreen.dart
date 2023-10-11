import 'package:flutter/material.dart';
import 'package:isms/models/course.dart';
import 'package:isms/models/module.dart';
import 'package:isms/slideManagement/fetchSlides.dart';
import 'package:isms/temp.dart';

class ModuleDetails extends StatefulWidget {
  ModuleDetails({super.key, required this.course, required this.module});
  Course course;
  Module module;

  @override
  State<ModuleDetails> createState() => _ModuleDetailsState();
}

class _ModuleDetailsState extends State<ModuleDetails> {
  bool isSlidesFetched = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchSlides(course: widget.course, module: widget.module).then((value) {
        setState(() {
          if (widget.module.slides != null &&
              widget.module.slides!.isNotEmpty) {
            isSlidesFetched = true;
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("${widget.module.title}"),
            Text("${widget.module.contentDescription}"),
            if (isSlidesFetched)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SlidesPage(
                                slides: widget.module.slides!,
                              )));
                },
                child: Text("Study module"),
              )
            else
              Container(
                height: 100,
                child: Center(
                  child: Column(
                    children: [
                      Text("Loading slides"),
                      CircularProgressIndicator(),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
