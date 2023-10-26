import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionSlides.dart';
import 'package:provider/provider.dart';
import 'package:isms/userManagement/loggedInState.dart';
import 'package:isms/screens/login/loginScreen.dart';

class AdminInstructionsCategories extends StatelessWidget {
  AdminInstructionsCategories(
      {required this.adminProvider,
      required this.category,
      required this.subCategories});
  AdminProvider? adminProvider;
  String? category;
  List<String> subCategories;

  Future<List?> fetchSlidesList(
      AdminProvider adminProvider, String category, String subCategory) async {
    var slides = await adminProvider?.fetchAdminInstructionsFromFirestore(
        category!, subCategory);
    print('slidessdcd: ${slides}');
    return slides ?? [];
  }

  @override
  Widget build(BuildContext context) {
    LoggedInState loggedInState = context.watch<LoggedInState>();

    if (loggedInState.user == null) {
      return LoginPage();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            for (var subCategory in subCategories)
              ElevatedButton(
                  onPressed: () async {
                    var slidesList = await fetchSlidesList(
                        adminProvider!, category!, subCategory);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminInstructionSlides(
                                slides: slidesList,
                              )),
                    );
                  },
                  child: Text('${subCategory}')),
          ],
        ),
      ),
    );
  }
}
