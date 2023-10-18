import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/models/customUser.dart';
import 'package:isms/userManagement/createUser.dart';

import '../models/userCoursesDetails.dart';

class CustomUserProvider with ChangeNotifier {
  final _dbUserOperations = CreateUserDataOperations();
  late String userUID = '';
  CustomUser? loggedInUser;
  List<CustomUser> users = []; // Main list should remain immutable
  List<dynamic> allEnrolledCoursesGlobal = [];

  List<dynamic> allCompletedCoursesGlobal = [];
  CustomUser? get getCurrentUser => loggedInUser;

  CustomUserProvider() {
    fetchUserDetails();
    fetchAllCoursesUser();
  }

  void setLoggedInUser(CustomUser user) {
    loggedInUser = user;
    notifyListeners();
  }

  Future<void> createUser(CustomUser user) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await _dbUserOperations.createUser(uid, user);
    } else {
      print('No authenticated user.');
    }
  }

  Future<String?> fetchCurrentUsername() async {
    String? email = FirebaseAuth.instance.currentUser?.email;

    if (email == null) {
      print('No authenticated user.');
      return null;
    }

    // Query the 'users' collection where 'email' field matches the authenticated user's email.
    QuerySnapshot userDocs = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Check if a document was found.
    if (userDocs.docs.isNotEmpty) {
      Map<String, dynamic> data =
          userDocs.docs.first.data() as Map<String, dynamic>;
      return data['username'] as String?;
    } else {
      print('No matching user document found for email $email.');
      return null;
    }
  }

  Future<String?> fetchCurrentUserEmail() async {
    return FirebaseAuth.instance.currentUser?.email;
  }

  Future<List<CustomUser>> fetchUsers() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _dbUserOperations.fetchAllUsers();

      users = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data();
        return CustomUser.fromMap(data);
      }).toList();
      notifyListeners();
      return users;
    } catch (e) {
      // Handle any errors that might occur during the fetching process
      debugPrint('Error fetching users: $e');
      return [];
    }
  }

  bool findUserByEmail(String userEmail) {
    return users.any((user) => user.email == userEmail);
  }

  CustomUser getUserByEmail(String userEmail) {
    CustomUser userFound;
    userFound = users.firstWhere((user) => user.email == userEmail);
    return userFound;
  }

  Future<CustomUser?> fetchUserDetails() async {
    print('fetchingUserDetails');
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    userUID = uid!;
    print(userUID);
    if (uid == null) {
      print('No authenticated user.');
      return null;
    }

    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      return CustomUser.fromMap(userDoc.data()!);
    } else {
      print('No matching user document found for UID $uid.');
      return null;
    }
  }

  setUserCourseStarted(Map<String, dynamic> courseDetails) {
    loggedInUser?.courses_started.add(courseDetails);
    notifyListeners();
  }

  fetchAllCoursesUser({bool isNotifyListener = true}) async {
    List<dynamic> allEnrolledCoursesLocal = [];
    List<dynamic>? allCompletedCoursesLocal = [];
    print('Inside fetch courses user provider');
    if (userUID != '') {
      Stream<DocumentSnapshot>? userStream = FirebaseFirestore.instance
          .collection('users')
          .doc(userUID)
          .snapshots();
      userStream.listen((snapshot) async {
        List<dynamic>? allEnrolledCoursesLocal = [];

        print('snapshotData: ${snapshot.data()}');
        UserCoursesDetails data =
            UserCoursesDetails.fromMap(snapshot.data() as Map<String, dynamic>);

        allEnrolledCoursesLocal = data.courses_started;

        allCompletedCoursesLocal = data.courses_completed;

        if (isNotifyListener) notifyListeners();
        allEnrolledCoursesGlobal.clear();

        allEnrolledCoursesGlobal = allEnrolledCoursesLocal!;
        allCompletedCoursesGlobal = allCompletedCoursesLocal!;
        print('allEnrolledCoursesGlobal: $allEnrolledCoursesGlobal');
      });
    }
  }

  Future<List> getAllEnrolledCoursesList() async {
    print('entered futurebuilder allEnrolledCoursesGlobal');
    await Future.delayed(Duration(seconds: 2));

    print('function return value allUsersGlobal: $allEnrolledCoursesGlobal');
    return allEnrolledCoursesGlobal;
  }

  Future<List> getAllCompletedCoursesList() async {
    print('entered futurebuilder allCompletedCoursesGlobal');
    await Future.delayed(Duration(seconds: 2));

    print('function return value allUsersGlobal: $allCompletedCoursesGlobal');
    return allCompletedCoursesGlobal;
  }
}
