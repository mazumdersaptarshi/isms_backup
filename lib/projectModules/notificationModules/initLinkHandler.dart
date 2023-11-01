import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';

import '../../screens/adminScreens/AdminInstructions/adminInstructionsCategories.dart';
import '../adminConsoleModules/adminActionDropdown.dart';

class InitLinkHandler {
  static Future<void> initUniLinks({required BuildContext context}) async {
    String initialLink = "";
    //   initialLink = "http://localhost:49430/adminConsolePage?category=people";
    try {
      initialLink = await getInitialLink() ?? "";

      print("Received link is ${initialLink}");

      Uri uri = Uri.parse(initialLink!);
      if (uri.pathSegments.length == 0) return;
      String parameter = uri.pathSegments[0];
      if (parameter == "adminConsolePage") {
        sendToInstructionsScreen(context: context, uri: uri);
      }
    } on PlatformException {}
    onOpen:
    (String link) {
      // Handle the link when it's received
      initialLink = "${link}_onOpen";
    };
  }

  static sendToInstructionsScreen(
      {required Uri uri, required BuildContext context}) {
    String? category = uri.queryParameters['category'];

    for (String key in categories!.keys) {
      if (key == category) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminInstructionsCategories(
                      category: category!,
                      subCategories: categories?[key],
                    )));
      }
    }
  }
}
