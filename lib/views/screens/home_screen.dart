import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:isms/controllers/auth_token_management/csrf_token_provider.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';
import 'package:isms/views/widgets/course_widgets/carousel.dart';
import 'package:provider/provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:isms/views/widgets/shared_widgets/custom_app_bar.dart';
import 'package:isms/views/widgets/shared_widgets/custom_drawer.dart';

// import '../widgets/course_widgets/carousel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;
import 'dart:html' as html;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // _fetchNewCSRFToken();
    // _fetchJWTandCSRFToken();
  }

  String _csrfToken = '';
  String _jwt = '';

  // String? getCookie(String name) {
  //   // Access all cookies from the document
  //   String cookies = html.document.cookie!;
  //   List<String> listValues = cookies.isNotEmpty ? cookies.split(";") : [];
  //   for (String cookie in listValues) {
  //     // Trim leading space.
  //     final String cookieTrimmed = cookie.trim();
  //     // Check if the current cookie string contains the cookie name we're looking for.
  //     if (cookieTrimmed.startsWith("$name=")) {
  //       print('cookieTrimmed: $cookieTrimmed');
  //
  //       return cookieTrimmed.substring(name.length + 1);
  //     }
  //   }
  //   return null;
  // }

  // Future<dynamic> _fetchNewCSRFToken() async {
  //   String url = 'http://127.0.0.1:5000/api/init';
  //   var response = await http.get(Uri.parse(url));
  //
  //   _csrfToken = response.body;
  //   Provider.of<CsrfTokenProvider>(context, listen: false).setCsrfToken(_csrfToken);
  //
  //   // if (response.statusCode == 200) {
  //   //   setState(() {
  //   //     _newToken = response.body;
  //   //     Provider.of<CsrfTokenProvider>(context, listen: false).setCsrfToken(_newToken);
  //   //   });
  //   // }
  // }
  //
  // Future<dynamic> _fetchJWTandCSRFToken() async {
  //   // String url =
  //   //     'http://127.0.0.1:5000/api/auth?uid=${Provider.of<LoggedInState>(context, listen: false).currentUser!.uid}';
  //   String remoteURL =
  //       'https://asia-northeast1-isms-billing-resources-dev.cloudfunctions.net/cf_isms_db_endpoint_noauth/api/auth?uid=${Provider.of<LoggedInState>(context, listen: false).currentUser!.uid}';
  //   var response = await http.get(Uri.parse(remoteURL));
  //   var jsonResponse = jsonDecode(response.body);
  //   Provider.of<CsrfTokenProvider>(context, listen: false).setTokens(jsonResponse['jwt'], jsonResponse['csrf_token']);
  // }

  // Utility function to check and potentially create the admin document
  Future<void> checkAndCreateUserDocument(
    String uid,
    String currentUserEmail,
    String currentUserName,
  ) async {
    DocumentReference adminDocRef =
        FirebaseFirestore.instance.collection('adminconsole').doc('allAdmins').collection('admins').doc(uid);

    bool docExists = await adminDocRef.get().then((doc) => doc.exists);

    if (!docExists) {
      await adminDocRef.set({
        'email': currentUserEmail,
        'name': currentUserName,
        'certifications': [],
      });
    }
  }

  // Define the courseTitle list
  final List<String> courseTitle = [
    "Advanced Javascript Concepts",
    "Data Science Fundamentals",
  ];

  @override
  Widget build(BuildContext context) {
    final LoggedInState loggedInState = context.watch<LoggedInState>();

    return Scaffold(
      backgroundColor: ThemeConfig.scaffoldBackgroundColor,
      bottomNavigationBar: PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: IsmsAppBar(context: context),
      drawer: IsmsDrawer(context: context),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            elevation: 10,
            backgroundColor: ThemeConfig.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            expandedHeight: 280,
            pinned: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.homeWelcomeBack} \n${loggedInState.currentUserName}",
                    style: TextStyle(
                      fontSize: 30,
                      color: ThemeConfig.secondaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    // The flex factor. You can adjust this number to take more or less space in the Row or Column.
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Image.asset(
                        "assets/images/security.png",
                        fit: BoxFit
                            .contain, // This will cover the available space, you can change it to BoxFit.contain to prevent the image from being cropped.
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Carousel
          SliverToBoxAdapter(
            child: Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.05,
                  10.0,
                  MediaQuery.of(context).size.width * 0.05,
                  10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(AppLocalizations.of(context)!.remainingCourses,
                            style: TextStyle(
                              fontSize: 30,
                              color: ThemeConfig.primaryTextColor,
                            )),
                      ],
                    ),
                    if (courseTitle.isNotEmpty) // Check if courseTitle is not empty
                      Carousel(
                        courseTitle: courseTitle,
                      ),
                    if (courseTitle.isEmpty) // Check if courseTitle is empty
                      Row(
                        children: [
                          SizedBox(width: 20),
                          Text(AppLocalizations.of(context)!.noRemainingCourses,
                              style: TextStyle(fontSize: 18, color: ThemeConfig.primaryTextColor)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          /// Carousel

          SliverPadding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
            // Adds padding around the content
            sliver: SliverToBoxAdapter(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4.0,
                    child: Container(
                      color: ThemeConfig.primaryCardColor,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3, // Adjust width as necessary
                        height: 200, // Adjust height as necessary
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.security,
                                size: 50,
                                color: ThemeConfig.primaryColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Suspendisse commodo tristique turpis.",
                                style: TextStyle(
                                  color: ThemeConfig.primaryTextColor!,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      // Adds spacing between the card and the paragraph
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vel porttitor nisl. Fusce in lorem maximus, eleifend magna eget, euismod tortor. Sed eget vehicula augue, nec dignissim felis. Vestibulum ac nisl pretium, commodo magna et, placerat diam. Nunc pharetra vel lacus id lobortis. ',
                            style: TextStyle(fontSize: 16, color: ThemeConfig.primaryTextColor),
                          ),
                          SizedBox(height: 20),
                          // Adds some space between the paragraphs
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vel porttitor nisl. Fusce in lorem maximus, eleifend magna eget, euismod tortor. Sed eget vehicula augue, nec dignissim felis. Vestibulum ac nisl pretium, commodo magna et, placerat diam. Nunc pharetra vel lacus id lobortis. ',
                            style: TextStyle(fontSize: 16, color: ThemeConfig.primaryTextColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Donec pretium a arcu eu condimentum. Phasellus rhoncus nibh quis cursus blandit. Nulla mattis ex eu sagittis hendrerit. Nullam efficitur sit amet nulla quis ultricies. Morbi vehicula urna et enim sollicitudin vestibulum. Pellentesque sit amet congue leo, at sollicitudin massa.',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeConfig.primaryTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Card(
                    elevation: 4.0,
                    child: Container(
                      color: ThemeConfig.primaryCardColor,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 200,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.lock_outline,
                                size: 50,
                                color: ThemeConfig.primaryColor,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Quisque eu scelerisque lectus",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: ThemeConfig.primaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              color: Colors.grey[200],
              // Sets the background color of the container to grey
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "01",
                        style: TextStyle(
                          fontSize: 64, // Adjust the size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Orange color for the number
                        ),
                      ),
                      SizedBox(height: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Text(
                            'Maecenas non tincidunt velit. Duis elementum eros sit amet metus mollis, et aliquet lectus accumsan. Phasellus dictum, nisi in auctor gravida, diam purus convallis justo, non pharetra nisl velit non augue. ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.blue),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "02",
                        style: TextStyle(
                          fontSize: 64, // Adjust the size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Orange color for the number
                        ),
                      ),
                      SizedBox(height: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Text(
                            'Sed libero lectus, tincidunt at ipsum at, aliquam accumsan velit. Nulla porta tortor magna, quis luctus mauris ultricies non. Nunc finibus maximus volutpat. Donec gravida porta tortor, vel volutpat nulla varius non. Quisque iaculis dolor at eros laoreet, ac malesuada dui dictum.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(color: Colors.blue),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "03",
                        style: TextStyle(
                          fontSize: 64, // Adjust the size as needed
                          fontWeight: FontWeight.bold,
                          color: Colors.orange, // Orange color for the number
                        ),
                      ),
                      SizedBox(height: 40),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: Text(
                            'Sed non quam ut purus mollis iaculis et eget ipsum. Sed quis tempus diam, id dapibus ante. Nullam placerat dui ac enim posuere malesuada. Praesent posuere tellus quis lobortis vehicula. ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ThemeConfig.primaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              // Provides padding around the cards
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Distributes space evenly around the cards
                children: [
                  // Card 1
                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 250,
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryCardColor,
                        // Set the background color here inside BoxDecoration
                        border: Border(left: BorderSide(color: Colors.blue, width: 4)), // Blue left border
                      ),
                      // Adjust width as necessary
                      padding: EdgeInsets.all(16),
                      // Provides padding inside the card
                      child: Column(
                        children: [
                          Icon(Icons.security, color: ThemeConfig.primaryColor, size: 54),
                          // Colored icon
                          Text(
                              "Vestibulum vitae lacus lobortis, tempus nunc a, vehicula enim. Nam vehicula ut ipsum sit amet vulputate. Mauris at pretium nisi, posuere tristique ex,",
                              style: TextStyle(
                                fontSize: 16,
                                color: ThemeConfig.primaryTextColor,
                              )),
                          // Text
                        ],
                      ),
                    ),
                  ),
                  // Card 2
                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 250,
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryCardColor,
                        // Set the background color here inside BoxDecoration
                        border: Border(left: BorderSide(color: Colors.blue, width: 4)), // Blue left border
                      ),

                      // Adjust width as necessary
                      padding: EdgeInsets.all(16),
                      // Provides padding inside the card
                      child: Column(
                        children: [
                          Icon(Icons.update, color: ThemeConfig.primaryColor, size: 54),
                          // Colored icon
                          Text(
                            "In euismod, dui id tristique consectetur, quam nisi tincidunt nunc, ut semper magna velit fermentum libero. Suspendisse in diam at quam venenatis mattis. Pellentesque sodales lacinia tempor. Pellentesque vehicula tincidunt lobortis. Fusce molestie justo eget convallis tempor. Donec aliquet erat a enim pretium, vitae imperdiet nulla ornare. ",
                            style: TextStyle(
                              fontSize: 16,
                              color: ThemeConfig.primaryTextColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Card 3
                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 250,
                      decoration: BoxDecoration(
                        color: ThemeConfig.primaryCardColor,
                        // Set the background color here inside BoxDecoration
                        border: Border(left: BorderSide(color: Colors.blue, width: 4)), // Blue left border
                      ),
                      // Adjust width as necessary
                      padding: EdgeInsets.all(16),
                      // Provides padding inside the card
                      child: Column(
                        children: [
                          Icon(Icons.group, color: ThemeConfig.primaryColor, size: 54),
                          // Colored icon
                          Text(
                            'Curabitur sed quam non diam maximus dapibus. Nullam sed est eget purus vestibulum commodo. In sodales tristique sagittis. Nam in vulputate tortor, ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                              color: ThemeConfig.primaryTextColor,
                            ),
                          )
                          // Text3
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
