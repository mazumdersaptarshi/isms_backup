// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class CreateUserReferenceForAdmin {
  Future<void> createUserRef(String uid) async {
    // Create a reference to the 'users' collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Create or get a reference to the new user document
    DocumentReference newUserRef = users.doc(uid);

    // Now, add this new user reference to the 'allusers' document in 'adminconsole'
    CollectionReference adminConsole =
        FirebaseFirestore.instance.collection('adminconsole');
    DocumentReference allUsersDoc = adminConsole.doc('allusers');

    // Get a reference to the 'userRefs' sub-collection inside 'allusers'
    CollectionReference userRefsCollection = allUsersDoc.collection('userRefs');

    // Add a new document in the 'userRefs' collection with the ID being the same as the new user's uid
    await userRefsCollection.doc(uid).set({
      'reference': newUserRef,
    });
  }
}
