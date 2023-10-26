import 'package:cloud_firestore/cloud_firestore.dart';
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
              SizedBox(height: 20),
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
                        constraints: BoxConstraints(minHeight: 50),
                        child: Column(
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

                            builder: (context) => UserProfilePage()),

                      );
                    },
                    child: Container(
                      width: 100,
                      constraints: BoxConstraints(minHeight: 50),
                      child: Column(
                        children: [

                          Icon(Icons.laptop_chromebook_outlined),
                          Text("All courses")


                        ],
                      ),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                    ),

                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()),
                  );
                },
                child: Container(
                  width: 100,
                  constraints: BoxConstraints(minHeight: 50),
                  child: Column(
                    children: [Icon(Icons.person_pin), Text("User profile")],
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                ),
              )
            ],
          ));

    });
  }
}
