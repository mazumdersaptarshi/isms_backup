import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/reminderScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/themes/common_theme.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserInfoFetched = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userRole;
  DateTime? _expiryDate;
  String? initialLink;

  @override
  void initState() {
    super.initState();

    InitLinkHandler.initLinks(context: context);
  }

  // Utility function to check and potentially create the admin document
  Future<void> checkAndCreateUserDocument(
    String uid,
    String currentUserEmail,
    String currentUserName,
  ) async {
    DocumentReference adminDocRef = FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(uid);

    bool docExists = await adminDocRef.get().then((doc) => doc.exists);

    if (!docExists) {
      await adminDocRef.set({
        'email': currentUserEmail,
        'name': currentUserName,
        'certifications': [],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();

    if (loggedInState.currentUser == null) {
      return LoginPage();
    }

    userRole = loggedInState.currentUserRole;

    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
          backgroundColor: Colors.deepPurpleAccent.shade100,
          bottomNavigationBar: kIsWeb
              ? null
              : Container(
                  decoration: const BoxDecoration(
                    //Here goes the same radius, u can put into a var or function
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x14000000),
                        spreadRadius: 0,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: BottomAppBar(
                      shape: const CircularNotchedRectangle(),
                      notchMargin: 6.0,
                      child: BottomNavigationBar(
                        items: const <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home_outlined),
                            label: 'Home',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons
                                .account_circle_outlined), // Fallback icon if no image is available
                            label: 'Account',
                          ),
                        ],
                        currentIndex: 0,
                        selectedItemColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.white,
                        type: BottomNavigationBarType.fixed,
                        elevation: 5,
                        onTap: (int index) {},
                        selectedLabelStyle: const TextStyle(
                          fontSize:
                              12, // Adjust the font size here for selected label
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize:
                              12, // Adjust the font size here for unselected label
                        ),

// This will be set when a new tab is tapped
                      ),
                    ),
                  ),
                ),
          appBar: CustomAppBar(
            loggedInState: loggedInState,
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Welcome back, \n${loggedInState.currentUserName}",
                        style: customTheme.textTheme?.bodyMedium
                            ?.copyWith(fontSize: 30, color: Colors.white),
                      ),
                      Flexible(
                        flex:
                            1, // The flex factor. You can adjust this number to take more or less space in the Row or Column.
                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.13, // 50% of screen width

                          child: Image.asset(
                            "assets/images/security.png",
                            fit: BoxFit
                                .cover, // This will cover the available space, you can change it to BoxFit.contain to prevent the image from being cropped.
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      Text("uu"),
                    ],
                  ),
                ),
              )
            ],
          ));
    });
  }
}
