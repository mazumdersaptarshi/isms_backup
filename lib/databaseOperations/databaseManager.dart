import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DatabaseManager {
  var db = FirebaseFirestore.instance;
}
