import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customCategory.dart';

Future<bool> createCategory({required CustomCategory category}) async {
  try {
    Map<String, dynamic> categoryMap = category.toMap();

    categoryMap['createdAt'] = DateTime.now();

    await FirebaseFirestore.instance
        .collection('categories')
        .doc(category.name)
        .set(categoryMap);

    print("Category creation successful");
    return true;
  } catch (e) {
    return false;
  }
}
