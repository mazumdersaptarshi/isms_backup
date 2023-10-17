import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/courseManagement/coursesProvider.dart';
import 'package:isms/userManagement/createUser.dart';
import 'package:isms/models/customUser.dart';

import '../models/course.dart';

class CustomUserProvider with ChangeNotifier {
  final _dbUserOperations = CreateUserDataOperations();
  CustomUser? loggedInUser;
  List<CustomUser> users = []; // Main list should remain immutable

  CustomUser? get getCurrentUser => loggedInUser;

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
    String? uid = FirebaseAuth.instance.currentUser?.uid;
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

  setUserCourseCompleted(Map<String, dynamic> courseDetails) {
    loggedInUser?.courses_completed.add(courseDetails);
    notifyListeners();
  }

  setUserCourseModuleCompleted(
      {required Map<String, dynamic> courseDetails,
      required CoursesProvider coursesProvider,
      required int courseIndex,
      required int moduleIndex}) {
    Course course = coursesProvider.allCourses[courseIndex];
    loggedInUser?.courses_started.forEach((course_started) {
      if (course_started['courseID'] == course.id) {
        print("COMPLETED MODULEE ${course_started}");
        if (course_started['modules_completed'] != null) {
          course_started['modules_completed'].forEach((element) {
            if (element != course.modules![moduleIndex].title) {
              course_started['modules_completed']
                  .add(course.modules![moduleIndex].title);
            }
          });
        } else {
          course_started['modules_completed'] = [];
          course_started['modules_completed']
              .add(course.modules![moduleIndex].title);
        }
      }
    });
    notifyListeners();
  }
}
