import 'package:flutter/material.dart';
import '../../../widgets/shared_widgets/custom_app_bar.dart';
import 'user_profile_data.dart';


class UserProfileTestPage extends StatelessWidget {
  const UserProfileTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IsmsAppBar(context: context),
      body: ListView(
        children: [

          /// Profile image on the left, then information on the right
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Container(
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
          ),
          SizedBox(height: 30),

          /// On card, profile image on the left, information on the right
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Card(
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
          ),
          SizedBox(height: 30),

          /// Image on the top center, and information underneath
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Show profile image
                  CircleAvatar(
                    backgroundImage: AssetImage(user['profilePicturePath']!),
                    radius: 50.0,
                  ),
                  SizedBox(height: 10),
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
          SizedBox(height: 30),

          /// On card, image on the top center, information underneath
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Show profile image
                    CircleAvatar(
                      backgroundImage: AssetImage(user['profilePicturePath']!),
                      radius: 50.0,
                    ),
                    SizedBox(height: 10),
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
          ),
          SizedBox(height: 30),

          /// Image on the top center, information underneath with a row
          Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Show profile image
                  CircleAvatar(
                    backgroundImage: AssetImage(user['profilePicturePath']!),
                    radius: 50.0,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                        ],
                      ),
                      // Show user role
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                ],
              ),
            ),
          ),
          SizedBox(height: 30),

          /// on card, image on the top, information underneath with a row
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Show profile image
                    CircleAvatar(
                      backgroundImage: AssetImage(user['profilePicturePath']!),
                      radius: 50.0,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                          ],
                        ),
                        // Show user role
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          /// Card with background image, image on the top, information underneath with a row
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Stack( // Use Stack to overlay widgets
              children: [
                // Background image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    "assets/images/sky.jpeg",
                    fit: BoxFit.cover, // Stretch image to fill space
                    width: double.infinity,
                    height: 300,
                  ),
                ),
                Card( // Add padding inside the card
                  margin: EdgeInsets.all(10.0), // Add white space around card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Show profile image with white background
                        CircleAvatar(
                          backgroundColor: Colors.white, // Set white background
                          backgroundImage: AssetImage(user['profilePicturePath']!),
                          radius: 50.0,
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                              ],
                            ),
                            // Show user role
                            SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),

          /// On card, profile image with background image, information underneath with a row
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Card(
              elevation: 1,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Show profile image with white background
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/sky.jpeg",
                            fit: BoxFit.cover, // Stretch image to fill space
                            width: double.infinity,
                            height: 150,
                          ),
                        ),

                        Container( // Wrap CircleAvatar with Container
                          decoration: BoxDecoration( // Add box decoration for border
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all( // Add border with desired thickness
                              color: Colors.white,
                              width: 5.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent, // Remove background color
                            backgroundImage: AssetImage(user['profilePicturePath']!),
                            radius: 50.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                          ],
                        ),
                        // Show user role
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

          /// On card with elevation 0, profile image with background image, information underneath with a row
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 30, right: 120, left: 120),
            child: Card(
              elevation: 0, // Add some shadow for depth
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Show profile image with white background
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/sky.jpeg",
                            fit: BoxFit.cover, // Stretch image to fill space
                            width: double.infinity,
                            height: 150,
                          ),
                        ),

                        Container( // Wrap CircleAvatar with Container
                          decoration: BoxDecoration( // Add box decoration for border
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all( // Add border with desired thickness
                              color: Colors.white,
                              width: 5.0,
                            ),
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent, // Remove background color
                            backgroundImage: AssetImage(user['profilePicturePath']!),
                            radius: 50.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                          ],
                        ),
                        // Show user role
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
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
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 30),

        ],
      ),
    );
  }
}