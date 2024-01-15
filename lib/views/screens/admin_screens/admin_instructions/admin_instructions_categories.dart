// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
// // import 'package:isms/adminManagement/admin_state.dart';
// // import 'package:isms/screens/adminScreens/AdminInstructions/admin_instructions_slides.dart';
// // import 'package:isms/themes/common_theme.dart';
// // import 'package:isms/userManagement/logged_in_state.dart';
// // import 'package:isms/utilityFunctions/platform_check.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../controllers/admin_management/admin_state.dart';
// import '../../../../controllers/theme_management/common_theme.dart';
// import '../../../../controllers/user_management/logged_in_state.dart';
// // import '../../../controllers/adminManagement/admin_state.dart';
// // import '../../../controllers/themes/common_theme.dart';
// // import '../../../controllers/userManagement/logged_in_state.dart';
// import '../../../../utilities/platform_check.dart';
// import 'admin_instructions_slides.dart';
//
// class AdminInstructionCategories extends StatelessWidget {
//   const AdminInstructionCategories({
//     super.key,
//     required this.category,
//     this.subCategories,
//   });
//
//   final String category;
//   final List<String>? subCategories;
//
//   @override
//   Widget build(BuildContext context) {
//     LoggedInState? loggedInState = context.watch<LoggedInState>();
//     AdminProvider adminProvider = context.watch<AdminProvider>();
//
//     return Scaffold(
//       appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
//       bottomNavigationBar:
//           PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: subCategories != null
//               ? Center(
//                   child: Container(
//                     constraints: BoxConstraints(
//                       maxWidth: (MediaQuery.of(context).size.width > 1000
//                               ? MediaQuery.of(context).size.width * 0.4
//                               : MediaQuery.of(context).size.width) *
//                           0.60,
//                     ),
//                     child: Column(
//                       mainAxisAlignment:
//                           MainAxisAlignment.center, // Centers vertically
//                       children: [
//                         Flexible(
//                           // Makes ListView flexible in the column
//                           child: ListView.builder(
//                             shrinkWrap:
//                                 true, // Important to wrap content in ListView
//                             itemCount: subCategories!.length,
//                             itemBuilder: (context, index) {
//                               var subCategory = subCategories![index];
//                               return Card(
//                                 color: secondaryColor,
//                                 elevation: 4,
//                                 margin: const EdgeInsets.symmetric(
//                                     horizontal: 8, vertical: 4),
//                                 shape: customCardShape,
//                                 child: ListTile(
//                                   title: Text(
//                                     subCategory,
//                                     style: buttonText,
//                                     textAlign:
//                                         TextAlign.center, // Text alignment
//                                   ),
//                                   onTap: () async {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             AdminInstructionSlides(
//                                           adminProvider: adminProvider,
//                                           category: category,
//                                           subCategory: subCategory,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : const Center(child: Text('No sub-categories found')),
//         ),
//       ),
//     );
//   }
// }
