import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:isms/databaseOperations/databaseManager.dart';
import 'package:isms/models/customUser.dart';

import '../adminManagement/createUserReferenceForAdmin.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:isms/databaseOperations/databaseManager.dart';
import 'package:isms/models/customUser.dart';


class CreateUserDataOperations extends DatabaseManager {
  Future<void> createUser(String uid, CustomUser user) async {
    Map<String, dynamic> userJson = user.toMap();
    await db.collection('users').doc(uid).set(userJson);
    CreateUserReferenceForAdmin userRefForAdmin = CreateUserReferenceForAdmin();
    print(userJson);
    print(uid);
    userRefForAdmin.createUserRef(
        uid); //Also creating a reference to the user on Admin side
  }

  Future<void> checkAndCreateUserIfNotExists(User? user) async {
    if (user == null) return;

    final userDoc = await db.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      await createUser(
          user.uid,
          CustomUser(
            username: user.displayName!,
            email: user.email!,
            role: 'user',
            courses_started: [],
            courses_completed: [],
          ));
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection('users').get();
  }
}
