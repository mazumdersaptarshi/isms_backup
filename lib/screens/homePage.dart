import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:provider/provider.dart';

import 'package:isms/userManagement/userDataGetterMaster.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'learningModuleScreens/courseScreens/createCourseScreen.dart';
import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userRole;

  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user == null) {
      return LoginPage();
    }

    userRole = "admin";
    //userRole = userDataGetterMaster.currentUserRole!;

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
                            builder: (context) => CoursesDisplayScreen()),
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
