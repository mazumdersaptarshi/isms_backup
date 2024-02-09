import 'package:flutter/material.dart';
import '../../../widgets/shared_widgets/custom_app_bar.dart';

class UserProfileTestPage extends StatelessWidget {
  const UserProfileTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    const user = {
      "fullName": "Mona Lisa",
      "email": "mona.lisa@example.com",
      "profilePicturePath": "assets/images/Mona_Lisa.jpg",
      "role": "Admin",
      "lastSignedIn": "2024-02-01 15:35",
    };

    return Scaffold(
      appBar: IsmsAppBar(context: context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Colors.blue, width: 3),
                    )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Show profile image
                      CircleAvatar(
                        backgroundImage: AssetImage(user['profilePicturePath']!),
                        radius: 50.0,
                      ),
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Show full name
                          Text(
                            "Full name: ${user['fullName']!}",
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 8),
                          // Show email address
                          Text(
                            "Email address: ${user['email']!}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8),
                          // Show user role
                          Text(
                            "User role: ${user['role']!}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                          SizedBox(height: 8),
                          // Show last signed in date/time
                          Text(
                            "Last signed in: ${user['lastSignedIn']!}",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}