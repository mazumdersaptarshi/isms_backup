// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:isms/models/module.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/moduleDetailsScreen.dart';
import 'package:isms/models/course.dart';
import 'package:isms/themes/common_theme.dart';

class ModuleTile extends StatelessWidget {
  final Course course;
  final Module module;
  final bool isModuleStarted;
  final bool isModuleCompleted;

  const ModuleTile(
      {super.key,
      required this.course,
      required this.module,
      this.isModuleStarted = false,
      this.isModuleCompleted = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,

      child: GestureDetector(
        child: Card(
          surfaceTintColor: Colors.white,
          elevation: 4,
          shape: customCardShape,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Stack(
              children: [
                Positioned( // will be positioned in the top right of the container
                  top: 0,
                  left: 0,
                  child: Icon(
                    isModuleCompleted
                    ? Icons.check_circle
                    : (isModuleStarted ? Icons.circle : Icons.unpublished),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        "https://www.shutterstock.com/image-vector/coding-vector-illustration-600w-687456625.jpg",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                              Expanded(
                                child: Text(module.title,
                                style: commonTextStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                                ),
                              ),
                        ],
                      ),
                    )
                  ],
                ),
              ]
            )
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ModuleDetails(
                course: course,
                module: module,
                isModuleStarted: isModuleStarted,
              ),
            ),
          );
        },
      ),
    );
  }
}
