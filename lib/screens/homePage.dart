// ignore_for_file: file_names

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
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';

import 'login/loginScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String userRole;
  //DateTime? _expiryDate;
  String? initialLink;
  bool isUserInfoFetched = false;

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
      return const LoginPage();
    }

    userRole = loggedInState.currentUserRole;

    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
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
          appBar: const CustomAppBar(),
          body: Row(
            children: [
              NavigationRail(destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bookmark_border),
                  selectedIcon: Icon(Icons.book),
                  label: Text('Bookmarks'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.star_border),
                  selectedIcon: Icon(Icons.star),
                  label: Text('Stars'),
                ),
              ], selectedIndex: 0),
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Logged in user: ',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email: ${loggedInState.currentUserEmail.toString()}',
                      style: const TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold),
                    ),
                    Text('Name: ${loggedInState.currentUserName.toString()}',
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold)),
                    Text('Role: ${userRole.toString()}',
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent,
                            fontWeight: FontWeight.bold)),

                    // Text(initialLink.toString()),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        if (userRole == "admin")
                          const HomePageTile(
                            tileId: 'adminConsole',
                          ),
                        const HomePageTile(tileId: 'courses'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserProfilePage()),
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
                            Icon(Icons.person_pin),
                            Text("User profile")
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (userRole == "admin")
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: () async {
                          if (userRole == "admin") {
                            await checkAndCreateUserDocument(
                              loggedInState.currentUserUid!,
                              loggedInState.currentUserEmail!,
                              loggedInState.currentUserName!,
                            );
                             if (!context.mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ReminderScreen()),
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: "You are not admin",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: const Text('Set Reminders'),
                      ),
                  ],
                ),
              ),
            ],
          ));
    });
  }
}

class HomePageTile extends StatelessWidget {
  const HomePageTile({super.key, required this.tileId});
  final String tileId;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            if (tileId == 'adminConsole') {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminConsolePage()));
            } else if (tileId == 'courses'){
              if (!context.mounted) return;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CoursesDisplayScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TileContent(
              tileId: tileId,
            ),
          ),
        ));
  }
}

class TileContent extends StatelessWidget {
  const TileContent({super.key, required this.tileId});
  final String tileId;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        child: Column(
          children: [
            if (tileId == 'adminConsole')
              const Column(
                children: [
                  Icon(Icons.lock, color: Colors.deepPurpleAccent),
                  SizedBox(height: 8),
                  Text(
                    "Admin Console",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent),
                  )
                ],
              ),
            if (tileId == 'courses')
              const Column(
                children: [
                  Icon(Icons.book, color: Colors.deepPurpleAccent),
                  SizedBox(height: 8),
                  Text(
                    "Courses",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent),
                  )
                ],
              ),
          ],
        ));
  }
}
