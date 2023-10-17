import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<QuerySnapshot<Map<String, dynamic>>> fetchAllUsers() {
    return db.collection('users').get();
  }
}
