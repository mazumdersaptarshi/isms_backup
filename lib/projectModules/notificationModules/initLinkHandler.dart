import 'package:uni_links/uni_links.dart';

Future<void> initUniLinks() async {
  String initialLink = "";
  try {
    initialLink = await getInitialLink() ?? "";
    // setState(() {
    //   initialLink = "http://localhost:49430/adminConsolePage?category=people";
    // });

    print("Received link is ${initialLink}");

    Uri uri = Uri.parse(initialLink!);
    String parameter = uri.pathSegments[0];
    if (parameter == "adminConsolePage") {
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
  } on PlatformException {}
  onOpen:
  (String link) {
    // Handle the link when it's received
    initialLink = "${link}_onOpen";
  };
}
