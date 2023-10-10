import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customCategory.dart';
import 'package:isms/models/module.dart';

Future fetchModules({required CustomCategory category}) async {
  if (category.modules != null && category.modules!.isNotEmpty) {
    print("Modules for $category already fetched! See ${category.modules}");
    return;
  } else {
    QuerySnapshot modulesListSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.name)
        .collection('modules')
        .get();
    category.modules = [];
    modulesListSnapshot.docs.forEach((element) {
      // print(element.data());
      Module m = Module.fromMap(element.data() as Map<String, dynamic>);
      // print("${m.title}, ${m.contentDescription}");

      category.modules?.add(m);
      print("FCN Categories ${category.hashCode}, ${category.modules}");
    });
  }
}
