import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customCategory.dart';

enum CategoryFetchStatus { idle, initiated, fetched }

class CategoriesProvider with ChangeNotifier {
  List<CustomCategory> allCategories = [];

  bool isCategoriesStreamFetched = false;

  CategoryFetchStatus categoryFetchStatus = CategoryFetchStatus.idle;

  CategoriesProvider() {
    if (categoryFetchStatus != CategoryFetchStatus.initiated)
      getAllCategories();
  }

  @override
  notifyListeners() {
    if (kDebugMode) {
      print("Notifying listeners");
    }
    super.notifyListeners();
  }

  getAllCategories({bool isNotifyListener = true}) async {
    isCategoriesStreamFetched = true;
    categoryFetchStatus = CategoryFetchStatus.initiated;
    print("FETCHING CATEGORIES STREAMMMM");

    Stream<QuerySnapshot>? categoriesStream =
        FirebaseFirestore.instance.collection('categories').snapshots();
    categoriesStream!.listen((snapshot) async {
      final List<CustomCategory> categories = [];

      snapshot.docs.forEach((element) {
        Map<String, dynamic> elementMap =
            element.data() as Map<String, dynamic>;
        if (elementMap['name'] != "exam") {
          CustomCategory categoryItem = CustomCategory.fromMap(elementMap);
          categories.add(categoryItem);
        }
      });
      allCategories.clear();
      allCategories.addAll(categories);

      if (isNotifyListener) notifyListeners();

      categoryFetchStatus = CategoryFetchStatus.initiated;
    });
  }
}
