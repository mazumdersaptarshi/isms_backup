import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class DatabaseManager {
  var db = FirebaseFirestore.instance;
  static var auth = FirebaseAuth.instance;
}
