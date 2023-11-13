// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isms/projectModules/adminConsoleModules/adminActionDropdown.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class InitLinkHandler {
  static StreamSubscription? _sub;
  static const _platformChannel = MethodChannel('app/isms/deeplink');

  static Future<void> initLinks({required BuildContext context}) async {
    try {
      _listenForIncomingLinksIOS(context);
      String? initialLink = await getInitialLink();
      debugPrint("Received initial link is $initialLink");

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
      debugPrint('PlatformException: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected error: $e');
    }
  }

  static void _listenForIncomingLinksIOS(BuildContext context) {
    _platformChannel.setMethodCallHandler((call) async {
      if (call.method == 'handleIncomingLink') {
        String link = call.arguments;
        debugPrint('Received link via method channel: $link');
        _handleLink(context, link);
      }
    });
  }

  static void startLinkListener(BuildContext context) {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        debugPrint("Received dynamic link: $link");
        _handleLink(context, link);
      } else {
        debugPrint("Received null link");
      }
    }, onError: (err) {
      debugPrint('Error on link stream: $err');
    });
  }

  static void _handleLink(BuildContext context, String link) {
    Uri uri = Uri.parse(link);
    debugPrint("Parsed link is $uri");

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
    if (kDebugMode) {
      debugPrint(uri.toString());
    }
    for (String key in categories.keys) {
      if (key == category && loggedinstate.currentUser != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminInstructionsCategories(
                      category: key,
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
