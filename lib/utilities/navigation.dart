import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:isms/views/screens/admin_screens/admin_console/all_users_screen.dart';
import 'package:provider/provider.dart';

import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/screens/admin_screens/admin_console/admin_user_details_screen.dart';
import 'package:isms/views/screens/authentication/login_screen.dart';
import 'package:isms/views/screens/course_list.dart';
import 'package:isms/views/screens/course_page.dart';
import 'package:isms/views/screens/home_screen.dart';

/// All named routes defined in the [GoRouter] configuration below
enum NamedRoutes {
  home,
  login,
  adminConsole,
  assignments,
  course,
  exam,
  allUsers
}

/// All parameter names used in child named routes defined in the [GoRouter] configuration below
enum NamedRoutePathParameters { courseId, examId }

/// Named [RouterConfig] object used to enable direct linking to and access of pages within the app by URL.
/// This is returned as [GoRouter] from package `go_router`, which allows more fine-tuned control than base Flutter classes.
final GoRouter ismsRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) =>
      Provider.of<LoggedInState>(context, listen: false).currentUser == null
          ? '/login'
          : null,
  routes: [
    GoRoute(
        name: NamedRoutes.home.name,
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage()),
    GoRoute(
      name: NamedRoutes.login.name,
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
      redirect: (BuildContext context, GoRouterState state) =>
          Provider.of<LoggedInState>(context, listen: false).currentUser != null
              ? '/'
              : null,
    ),
    GoRoute(
      name: NamedRoutes.adminConsole.name,
      path: '/admin_console',
      builder: (BuildContext context, GoRouterState state) =>
          const AdminUserDetailsScreen(),
      redirect: (BuildContext context, GoRouterState state) =>
          Provider.of<LoggedInState>(context, listen: false).currentUserRole !=
                  'admin'
              ? '/'
              : null,
    ),
    GoRoute(
      name: NamedRoutes.allUsers.name,
      path: '/all_users',
      builder: (BuildContext context, GoRouterState state) => const AllUsers(),
      redirect: (BuildContext context, GoRouterState state) =>
          Provider.of<LoggedInState>(context, listen: false).currentUserRole !=
                  'admin'
              ? '/'
              : null,
    ),
    GoRoute(
      name: NamedRoutes.assignments.name,
      path: '/assignments',
      builder: (BuildContext context, GoRouterState state) =>
          const CourseList(),
      routes: [
        GoRoute(
          name: NamedRoutes.course.name,
          path: 'course/:courseId',
          builder: (context, state) => CoursePage(
              courseId:
                  state.pathParameters[NamedRoutePathParameters.courseId.name]),
          onExit: (BuildContext context) => _getNavigationConfirmationDialog(
              context,
              AppLocalizations.of(context)!.dialogLeavePageContentCourse),
        ),
        GoRoute(
          name: NamedRoutes.exam.name,
          path: 'exam/:examId',
          builder: (context, state) => CoursePage(
              courseId:
                  state.pathParameters[NamedRoutePathParameters.examId.name]),
          onExit: (BuildContext context) => _getNavigationConfirmationDialog(
              context,
              AppLocalizations.of(context)!.dialogLeavePageContentExam),
        ),
      ],
    ),
  ],
);

/// Displays an [AlertDialog] prompting the user to confirm whether they really want to leave the current page.
///
/// Used in the `onExit` parameter of certain [GoRoute]s
/// (those for pages which track user progress/input, such as course and exam pages).
FutureOr<bool> _getNavigationConfirmationDialog(
    BuildContext context, String dialogContent) async {
  final bool? confirmed = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black26,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.dialogLeavePageTitle),
        content: Text(dialogContent),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.dialogStayHere),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.dialogLeavePage),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );

  /// Since we allow the dialog to be dismissible, only return true if user confirms they wish to leave the page.
  /// Otherwise, return false whether user explicitly cancels the navigation action or dismisses the dialog.
  return confirmed ?? false;
}
