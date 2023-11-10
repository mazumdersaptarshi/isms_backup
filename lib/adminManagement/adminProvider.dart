import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';
import 'package:isms/userManagement/loggedInState.dart';

import '../models/customUser.dart';

class AdminProvider extends ChangeNotifier {
  bool isCoursesStreamFetched = false;
  List<dynamic> allCourses = [];
  List<dynamic> allUsers = [];
  List<dynamic> userRefs = [];

  bool _hasNewCoursesData = false;
  bool _authStateChanged = false;
  bool _hasNewUsersData = false;
  // UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  Map<String, dynamic> snapshotData = {};
  LoggedInState loggedInState = LoggedInState();
  AdminProvider() {
    print('provider invoked');
    listenToCoursesChanges();
    listenToUsersChanges();
  }

  void listenToCoursesChanges() {
    FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _hasNewCoursesData = true;
        notifyListeners();
      }
    });
  }

  void listenToUsersChanges() {
    FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allusers')
        .collection('userRefs')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        print('User added or removed');
        _hasNewUsersData = true;
        notifyListeners();
      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _hasNewUsersData = true;
        print('There was a chnage in user data');
        notifyListeners();
      }
    });
  }

  Future<List> allCoursesDataFetcher() async {
    if (!_hasNewCoursesData && allCourses.isNotEmpty) {
      print('No changes, fetching saved data');
      return allCourses;
    }
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allcourses')
        .collection('allCourseItems')
        .get();
    print('AllCoursesAdmin:');
    allCourses.clear();
    querySnapshot.docs.forEach((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> elementMap =
            documentSnapshot.data() as Map<String, dynamic>;
        CoursesDetails courseItem = CoursesDetails.fromMap(elementMap);
        print('coursDetais: ${courseItem.course_name}');
        allCourses.add(courseItem);
      }
    });
    QuerySnapshot userRefsQuerySnapshot = await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allusers')
        .collection('userRefs')
        .get();
    userRefsQuerySnapshot.docs.forEach((documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (!userRefs.contains(documentSnapshot.id)) {
          userRefs.add(documentSnapshot.id);
        }
      }
    });

    _hasNewCoursesData = false;
    print('Changes detected, returning updated data');

    return allCourses;
  }

  Future<List> allUsersDataFetcher() async {
    if (_authStateChanged || _hasNewUsersData) {
      //Clearing old data if there is new data available
      allUsers.clear();
      userRefs.clear();
      print(
          'Fething new data from firestore as authStateChanged: ${_authStateChanged} and _hasNewUsersData: ${_hasNewUsersData}');

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('adminconsole')
          .doc('allusers')
          .collection('userRefs')
          .get();

      querySnapshot.docs.forEach((documentSnapshot) async {
        if (documentSnapshot.exists) {
          if (!userRefs.contains(documentSnapshot.id)) {
            userRefs.add(documentSnapshot.id);
          }
        }
      });
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
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

          allUsers.add(userInfo);
          allUsers.forEach((element) {
            print('adminUsersView: ${element.courses_completed}');
            print('adminUsersView: ${element.courses_started}');
          });
        } catch (e) {
          print(
              'There was an issue with user Data; Could not fetch user data. Reason for error: $e');
        }
      }
      _hasNewUsersData = false;
      _authStateChanged = false;
      return allUsers;
    } else {
      print(
          'Fetching cached data since no changes detected, authStateChanged: ${_authStateChanged} and _hasNewUsersData: ${_hasNewUsersData}');
      return allUsers;
    }
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
