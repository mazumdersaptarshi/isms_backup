// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

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

      if (initialLink != null) {
        if (!context.mounted) return;
        _handleLink(context, initialLink);
      }

      // Start listening for dynamic links if not already
      if (_sub == null) {
        if (!context.mounted) return;
        startLinkListener(context);
      }
    } on PlatformException catch (e) {
      log('PlatformException: ${e.message}');
    } catch (e) {
      log('Unexpected error: $e');
    }
  }

  static void startLinkListener(BuildContext context) {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        log("Received dynamic link: $link");
        _handleLink(context, link);
      } else {
        log("Received null link");
      }
    }, onError: (err) {
      log('Error on link stream: $err');
    });
  }

  static void _handleLink(BuildContext context, String link) {
    Uri uri = Uri.parse(link);
    log("Parsed link is $uri");

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
