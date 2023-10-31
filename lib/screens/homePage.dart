import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../projectModules/adminConsoleModules/adminActionDropdown.dart';
import '../userManagement/userDataGetterMaster.dart';
import 'adminScreens/AdminInstructions/adminInstructionsCategories.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserInfoFetched = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot? currentUserSnapshot;
  late String userRole;
  DateTime? _expiryDate;

  UserDataGetterMaster userDataGetterMaster = UserDataGetterMaster();
  String? initialLink;

  Future<void> initUniLinks() async {
    try {
      initialLink = await getInitialLink();
      // setState(() {
      //   initialLink = "http://localhost:49430/adminConsolePage?category=people";
      // });

      print("Received link is ${initialLink}");

      Uri uri = Uri.parse(initialLink!);
      String parameter = uri.pathSegments[0];
      if (parameter == "adminConsolePage") {
        String? category = uri.queryParameters['category'];

        for (String key in categories!.keys) {
          if (key == category) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminInstructionsCategories(
                          category: category!,
                          subCategories: categories?[key],
                        )));
          }
        }
      }
    } on PlatformException {}
    onOpen:
    (String link) {
      // Handle the link when it's received
      initialLink = "${link}_onOpen";
    };
  }

  @override
  void initState() {
    super.initState();

    // userRole = 'admin';
    initUniLinks();
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

  @override
  Widget build(BuildContext context) {
    userRole = userDataGetterMaster.currentUserRole!;
    final loggedInState = context.watch<LoggedInState>();

    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
          appBar: CustomAppBar(),
          body: Column(
            children: [
              Text('Logged in user: '),
              Text(loggedInState.currentUserEmail.toString()),
              Text(loggedInState.currentUserName.toString()),
              Text(userRole.toString()),
              Text(initialLink.toString()),
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
                                builder: (context) => AdminConsolePage()));
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
                              builder: (context) => CoursesDisplayScreen()));
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
