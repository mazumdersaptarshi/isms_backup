import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isms/models/customUser.dart';

import 'package:isms/databaseOperations/databaseManager.dart';

class CreateUserDataOperations extends DatabaseManager {
  Future<void> createUser(String uid, CustomUser user) async {
    Map<String, dynamic> userJson = user.toMap();
    await db.collection('users').doc(uid).set(userJson);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection('users').get();
  }
}
