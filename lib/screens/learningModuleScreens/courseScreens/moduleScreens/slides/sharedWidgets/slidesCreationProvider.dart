import 'package:flutter/material.dart';
import 'package:isms/models/slide.dart';

class SlidesCreationProvider with ChangeNotifier {
  List<Slide> slidesList = [];
  int noOfForms = 1;

  addSlideToList(Slide slide) {
    slidesList.add(slide);
    notifyListeners();
  }

  incrementFormNo() {
    noOfForms += 1;
    notifyListeners();
  }

  clearSlidesList() {
    slidesList.clear();
    noOfForms = 1;
    notifyListeners();
  }
}
