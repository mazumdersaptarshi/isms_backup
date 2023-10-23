import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';

import '../models/customUser.dart';

class AdminProvider extends ChangeNotifier {
  bool isCoursesStreamFetched = false;
  List<dynamic> allCoursesGlobal = [];
  List<dynamic> allUsersGlobal = [];

  Map<String, dynamic> snapshotData = {};
  AdminProvider() {
    print('provider invoked');
    fetchAllCoursesAdmin();
    fetchAllusersAdmin();
  }

  fetchAllCoursesAdmin({bool isNotifyListener = true}) async {
    isCoursesStreamFetched = true;
    print('This is listening');
    Stream<QuerySnapshot>? coursesDocumentStream = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems')
        .snapshots();
    coursesDocumentStream.listen((snapshot) async {
      List<dynamic> allCoursesLocal = [];
      snapshot.docs.forEach((element) {
        print('element.data ${element.data()}');
        Map<String, dynamic> elementMap =
            element.data() as Map<String, dynamic>;
        CoursesDetails courseItem = CoursesDetails.fromMap(elementMap);
        print('yyyyyyyyyyy');
        print(courseItem.course_started);
        print('courseItem: ${courseItem.course_completed}');
        allCoursesLocal.add(courseItem);
      });

      if (isNotifyListener) notifyListeners();
      ;
      allCoursesGlobal = allCoursesLocal;
    });
  }

  fetchAllusersAdmin({bool isNotifyListener = true}) async {
    List<Map<String, dynamic>> localUserDataList = [];
    List<dynamic> allUsersInfoLocal = [];
    Stream<QuerySnapshot>? usersDocumentsStream = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allusers')
        .collection('userRefs')
        .snapshots();
    usersDocumentsStream.listen((snapshot) async {
      List<dynamic> userRefs = [];
      userRefs.clear();
      snapshot.docs.forEach((element) {
        print('element.id(): ${element.id}');
        userRefs.add(element.id);
      });
      print('userRefs: $userRefs');

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      allUsersInfoLocal.clear();
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
          allUsersInfoLocal.add(userInfo);
          allUsersInfoLocal.forEach((element) {
            print(element.courses_completed);
          });
        } catch (e) {
          print(
              'There was an issue with user Data; Could not fetch user data. Reason for error: $e');
        }
      }
      if (isNotifyListener) notifyListeners();
      allUsersGlobal.clear();
      print('clearing allUsersGlobal');
      allUsersGlobal = allUsersInfoLocal;
      print('allUsersGlobal: $allUsersGlobal');
    });
  }

  Future<List> getAllCoursesList() async {
    print('entered futurebuilder');
    await Future.delayed(Duration(seconds: 2));
    return allCoursesGlobal;
  }

  Future<List> getAllUsersList() async {
    print('entered futurebuilder getAllUsersList');
    await Future.delayed(Duration(seconds: 2));
    print('function return value allUsersGlobal: $allUsersGlobal');
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
      print('Datasss: ${document.id}');

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
        print("Document ID: ${doc.id}, Data: ${data}");

        // Access individual fields
        print("Number of slides': ${data['slides']?.length}");
        print("Field 'name': ${data['slides']}");

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
