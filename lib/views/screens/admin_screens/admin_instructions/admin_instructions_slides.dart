// // ignore_for_file: file_names
//
// import 'package:flutter/material.dart';
// // import 'package:isms/adminManagement/admin_provider.dart';
// // import 'package:isms/screens/learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
// // import 'package:isms/userManagement/logged_in_state.dart';
// // import 'package:isms/utilityFunctions/platform_check.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../controllers/admin_management/admin_provider.dart';
// import '../../../../controllers/user_management/logged_in_state.dart';
// // import '../../../controllers/adminManagement/admin_provider.dart';
// // import '../../../controllers/userManagement/logged_in_state.dart';
// import '../../../../utilities/platform_check.dart';
// // import '../../learningModuleScreens/courseScreens/moduleScreens/slides/sharedWidgets/slidesContentWidget.dart';
//
// class AdminInstructionSlides extends StatefulWidget {
//   const AdminInstructionSlides(
//       {super.key,
//       required this.adminProvider,
//       required this.category,
//       required this.subCategory});
//   final String category;
//   final String subCategory;
//   final AdminProvider adminProvider;
//
//   @override
//   State<AdminInstructionSlides> createState() => _AdminInstructionSlidesState();
// }
//
// class _AdminInstructionSlidesState extends State<AdminInstructionSlides> {
//   List<dynamic>? slides; // Declare the slides variable here
//   List<Map<String, dynamic>> cardItems = [];
//   int currentIndex = 0;
//   final PageController _pageController = PageController(initialPage: 0);
//
//   Future<List?> fetchSlidesList(
//       AdminProvider adminProvider, String category, String subCategory) async {
//     var fetchedSlides = await adminProvider.fetchAdminInstructionsFromFirestore(
//         category, subCategory);
//     return fetchedSlides;
//   }
//
//   List<Map<String, dynamic>> _initializeCardItems(List<dynamic>? slides) {
//     List<Map<String, dynamic>> slidesMap = [];
//     if (slides != null) {
//       for (var element in slides) {
//         slidesMap.add({'title': element['title'], 'text': element['content']});
//       }
//     }
//     return slidesMap;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchSlidesList(widget.adminProvider, widget.category, widget.subCategory)
//         .then((value) {
//       setState(() {
//         slides = value;
//         cardItems = _initializeCardItems(slides); // Initialize cardItems here
//       });
//       if (mounted) {
//         _pageController.addListener(() {
//           setState(() {
//             currentIndex = _pageController.page!.round();
//           });
//         });
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     LoggedInState loggedInState = context.watch<LoggedInState>();
//     return Scaffold(
//         appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
//         body: slides != null
//             ? Column(
//                 // children: [
//                 //   SlidesContentWidget(
//                 //     pageController: _pageController,
//                 //     cardItems: cardItems, // Use cardItems here
//                 //     currentIndex: currentIndex,
//                 //   ),
//                 //   // Add other UI elements if needed
//                 // ],
//                 )
//             : const CircularProgressIndicator(),
//         bottomNavigationBar:
//             PlatformCheck.bottomNavBarWidget(loggedInState, context: context));
//   }
// }
