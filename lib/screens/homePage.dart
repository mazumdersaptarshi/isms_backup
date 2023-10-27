import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:provider/provider.dart';

import '../userManagement/userDataGetterMaster.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserInfoFetched = false;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot? currentUserSnapshot;
  String? userRole;
  DateTime? _expiryDate;

  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  void initState() {
    super.initState();
    userRole = userDataGetterMaster.currentUserRole!;
    // _loadUserInformation().then((value) {
    //   setState(() {
    //     widget.isUserInfoFetched = value;
    //   });
    // });
  }

  void setExpiryDate() async {
    await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(FirebaseAuth.instance.currentUser!
            .displayName) // replace 'username' with the logged in user's name
        .set({
      'createdTime': Timestamp.now(),
      'expiredTime': Timestamp.fromDate(_expiryDate!),
      'reminderSent': false,
      'email': FirebaseAuth
          .instance.currentUser!.email, // replace with the user's email
    });
  }
  // Future<bool> _loadUserInformation() async {
  //   User? currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser != null) {
  //     DocumentSnapshot? userSnapshot = userInfoGetter.currentUserSnapshot;
  //     if (userSnapshot != null) {
  //       setState(() {
  //         currentUserSnapshot = userSnapshot;
  //       });
  //       Map<String, dynamic>? userData =
  //           userSnapshot.data() as Map<String, dynamic>?;
  //       userRole = userData?['role'];
  //       return true;
  //     } else {
  //       print('User not found');
  //       return false;
  //     }
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            children: [
              Text(userRole.toString()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (userRole == "admin")
                    ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminConsolePage()),
                        );
                      },
                      child: Container(
                        constraints: const BoxConstraints(minHeight: 50),
                        child: const Column(
                          children: [
                            Icon(Icons.lock_person_rounded),
                            Text("Admin console")
                          ],
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CoursesDisplayScreen()),
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),
                    child: Container(
                      width: 100,
                      constraints: const BoxConstraints(minHeight: 50),
                      child: const Column(
                        children: [
                          Icon(Icons.laptop_chromebook_outlined),
                          Text("All courses")
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                child: Container(
                  width: 100,
                  constraints: const BoxConstraints(minHeight: 50),
                  child: const Column(
                    children: [Icon(Icons.person_pin), Text("User profile")],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101));

                  if (pickedDate != null) {
                    final TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );

                    if (pickedTime != null) {
                      setState(() {
                        _expiryDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute);
                        setExpiryDate();
                      });
                    }
                  }
                },
                child: const Text('Set Expiry date'),
              ),
            ],
          ));
    });
  }
}
