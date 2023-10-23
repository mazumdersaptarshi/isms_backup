import 'package:flutter/material.dart';
import 'package:isms/adminManagement/adminConsoleProvider.dart';
import 'package:isms/screens/adminScreens/AdminInstructions/adminInstructionSlides.dart';

class AdminInstructionsCategories extends StatelessWidget {
  AdminInstructionsCategories(
      {required this.adminProvider,
      required this.category,
      required this.subCategories});
  AdminProvider? adminProvider;
  String? category;
  List<String> subCategories;

  Future<List?> fetchSlides2(
      AdminProvider adminProvider, String category, String subCategory) async {
    var slides = await adminProvider?.fetchAdminInstructionsFromFirestore(
        category!, subCategory);
    print('slidessdcd: ${slides}');
    return slides ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            for (var subCategory in subCategories)
              ElevatedButton(
                  onPressed: () async {
                    var res2 = await fetchSlides2(
                        adminProvider!, category!, subCategory);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AdminInstructionSlides(
                                slides: res2,
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
