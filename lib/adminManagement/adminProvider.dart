import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';

import '../models/customUser.dart';

class AdminProvider extends ChangeNotifier {
  bool isCoursesStreamFetched = false;
  List<dynamic> allCoursesGlobal = [];
  List<dynamic> allUsersGlobal = [];
  bool _hasnewData = false;

  Map<String, dynamic> snapshotData = {};
  AdminProvider() {
    print('provider invoked');
    listenToChanges();
  }

  void listenToChanges() {
    FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _hasnewData = true;
        notifyListeners();
      }
    });
  }

  Future<List> allCoursesDataFetcher() async {
    if (!_hasnewData && allCoursesGlobal.isNotEmpty) {
      print('No changes, fetching saved data');
      return allCoursesGlobal;
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems')
        .get();
    print('AllCoursesAdmin:');
    allCoursesGlobal.clear();
    querySnapshot.docs.forEach((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> elementMap =
            documentSnapshot.data() as Map<String, dynamic>;
        CoursesDetails courseItem = CoursesDetails.fromMap(elementMap);
        print('coursDetais: ${courseItem.course_name}');
        allCoursesGlobal.add(courseItem);
      }
    });
    _hasnewData = false;
    print('Changes detected, returning updated data');

    return allCoursesGlobal;
  }

  Future<List> allUsersDataFetcher() async {
    allUsersGlobal.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allusers')
        .collection('userRefs')
        .get();
    List<dynamic> userRefs = [];

    querySnapshot.docs.forEach((documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (!userRefs.contains(documentSnapshot.id)) {
          userRefs.add(documentSnapshot.id);
        }
      }
    });
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for (String userRef in userRefs) {
      DocumentSnapshot userSnapshot = await users!.doc(userRef).get();
      try {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        print('raw user data: $userData');
        userData["uid"] = userSnapshot.id;

        // localUserDataList.add({
        //   'username': userData['username'],
        //   'email': userData['email'],
        //   'role': userData['role'],
        // });
        CustomUser userInfo = CustomUser.fromMap(userData);

        allUsersGlobal.add(userInfo);
        allUsersGlobal.forEach((element) {
          print(element.courses_completed);
        });
      } catch (e) {
        print(
            'There was an issue with user Data; Could not fetch user data. Reason for error: $e');
      }
    }
    return allUsersGlobal;
  }

  Future<Map<String, dynamic>?> fetchAdminInstructions(
      String category, String subCategory) async {
    print(category);

    //getting a reference of the collection, returns Future<QuerySnapshot<Map<String, dynamic>>>
    var collectionRef = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('instructions')
        .collection('${category}');
    final ref1 = await collectionRef
        .get(); //this makes it QuerySnapshot<Map<String, dynamic>>

    for (var document in ref1.docs) {
      final ref = collectionRef
          .doc('${document.id}')
          .collection('${subCategory}')
          .get();
      print('ref: ${ref}');

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await ref;
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in querySnapshot.docs) {
        // Access data via .data() or []
        Map<String, dynamic> data = doc.data();
        return data;
      }
    }
    return null;
  }

  Future<List> fetchAdminInstructionsFromFirestore(
      String category, String subCategory) async {
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('instructions')
        .collection('${category}')
        .doc('${subCategory}');
    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

      var slides = data['slides'];
      return slides;
    } else {
      print('Document does not exist');
      return [];
    }
  }
}
