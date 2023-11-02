import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isms/projectModules/courseManagement/coursesProvider.dart';
import 'package:isms/projectModules/notificationModules/initLinkHandler.dart';
import 'package:isms/screens/adminScreens/AdminConsole/adminConsolePage.dart';
import 'package:isms/screens/learningModuleScreens/courseScreens/coursesListScreen.dart';
import 'package:isms/screens/userInfo/userProfilePage.dart';
import 'package:isms/sharedWidgets/customAppBar.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import '../projectModules/adminConsoleModules/adminActionDropdown.dart';
import 'adminScreens/AdminInstructions/adminInstructionsCategories.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  bool isUserInfoFetched = false;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot? currentUserSnapshot;
  late String userRole = 'user';
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
    userRole = loggedInState.currentUserRole != null
        ? loggedInState.currentUserRole!
        : 'user';
    return Consumer<CoursesProvider>(
        builder: (BuildContext context, CoursesProvider value, Widget? child) {
      return Scaffold(
          appBar: CustomAppBar(),
          body: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Logged in user: ',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Email: ${loggedInState.currentUserEmail.toString()}',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text('Name: ${loggedInState.currentUserName.toString()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      Text('Role: ${userRole.toString()}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

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
                      children: [Icon(Icons.person_pin), Text("User profile")],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                if (userRole == "admin")
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
              Column(
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
              Column(
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
