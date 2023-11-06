import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
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

    InitLinkHandler.initUniLinks(context: context);
  }

  void setExpiryDate(String currentUserEmail, String currentUserName) async {
    await FirebaseFirestore.instance
        .collection('adminconsole')
        .doc('allAdmins')
        .collection('admins')
        .doc(
            currentUserName) // replace 'username' with the logged in user's name
        .set({
      'createdTime': Timestamp.now(),
      'expiredTime': Timestamp.fromDate(_expiryDate!),
      'reminderSent': false,
      'email': currentUserEmail, // replace with the user's email
    });
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
          appBar: CustomAppBar(),
          body: Row(
            children: [
              NavigationRail(destinations: [
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
              Container(
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
                          HomePageTile(
                            tileId: 'adminConsole',
                          ),
                        HomePageTile(tileId: 'courses'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserProfilePage()),
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
                                setExpiryDate(loggedInState.currentUserEmail!,
                                    loggedInState.currentUserName!);
                              });
                            }
                          }
                        },
                        child: const Text('Set Expiry date'),
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
  HomePageTile({required this.tileId});
  String tileId;
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          onTap: () {
            if (tileId == 'adminConsole')
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminConsolePage()));
            else if (tileId == 'courses')
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoursesDisplayScreen()));
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
  TileContent({required this.tileId});
  String tileId;
  @override
  Widget build(BuildContext context) {
    return Container(
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
