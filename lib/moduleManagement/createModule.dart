import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customCategory.dart';
import 'package:isms/models/module.dart';

Future<bool> createModule(
    {required Module module, required CustomCategory category}) async {
  try {
    Map<String, dynamic> moduleMap = module.toMap();

    moduleMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.name)
        .collection("modules")
        .doc(module.title)
        .set(moduleMap);

    if (category.modules == null) category.modules = [];

    category.modules?.add(module);
    print("Module creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
