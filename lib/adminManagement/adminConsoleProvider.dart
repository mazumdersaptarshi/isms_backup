import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:isms/models/adminConsoleModels/coursesDetails.dart';

class AdminConsoleProvider extends ChangeNotifier {
  bool isCoursesStreamFetched = false;
  List<dynamic> allCoursesGlobal = [];
  List<dynamic> allUsersGlobal = [];

  Map<String, dynamic> snapshotData = {};
  AdminConsoleProvider() {
    print('provider invoked');
    fetchAllCoursesAdmin();
    fetchAllusersAdmin();
    // linkUsersToAdminConsole();
    // createNewUser();
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
        allCoursesLocal.add(courseItem);
      });

      if (isNotifyListener) notifyListeners();
      allCoursesGlobal = allCoursesLocal;
    });
  }

  fetchAllusersAdmin({bool isNotifyListener = true}) async {
    List<Map<String, dynamic>> localUserDataList = [];
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

      for (String userRef in userRefs) {
        DocumentSnapshot userSnapshot = await users!.doc(userRef).get();
        try {
          Map<String, dynamic> userData =
              userSnapshot.data() as Map<String, dynamic>;

          localUserDataList.add({
            'username': userData['username'],
            'email': userData['email'],
            'role': userData['role'],
          });
        } catch (e) {
          print(
              'There was an issue with user Data; Could not fetch user data. Reason for error: $e');
        }
      }
      allUsersGlobal = localUserDataList;
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
    return allUsersGlobal;
  }
}
