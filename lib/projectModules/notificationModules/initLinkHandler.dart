import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isms/projectModules/adminConsoleModules/adminActionDropdown.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class InitLinkHandler {
  static StreamSubscription? _sub;

  static Future<void> initLinks({required BuildContext context}) async {
    try {
      String? initialLink = await getInitialLink();

      print("Received initial link is $initialLink");

      if (initialLink != null) {
        _handleLink(context, initialLink);
      }

      // Start listening for dynamic links if not already
      if (_sub == null) {
        startLinkListener(context);
      }
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  static void startLinkListener(BuildContext context) {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        print("Received dynamic link: $link");
        _handleLink(context, link);
      } else {
        print("Received null link");
      }
    }, onError: (err) {
      print('Error on link stream: $err');
    });
  }

  static void _handleLink(BuildContext context, String link) {
    Uri uri = Uri.parse(link);
    print("Parsed link is $uri");

    if (uri.pathSegments.isEmpty) return;
    String parameter = uri.pathSegments[0];
    if (parameter == "adminConsolePage") {
      _sendToInstructionsScreen(context: context, uri: uri);
    }
  }

  static void _sendToInstructionsScreen(
      {required Uri uri, required BuildContext context}) {
    LoggedInState loggedinstate =
        Provider.of<LoggedInState>(context, listen: false);
    String? category = uri.queryParameters['category'];
    print(uri);
    for (String key in categories.keys) {
      if (key == category && loggedinstate.currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminInstructionCategories(
                      category: category!,
                      subCategories: categories[key],
                    )));
      }
    }
  }

  static void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
