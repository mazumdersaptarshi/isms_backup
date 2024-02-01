import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/views/screens/admin_screens/admin_console/admin_user_details_screen.dart';
import 'package:isms/views/screens/authentication/login_screen.dart';
import 'package:isms/views/screens/course_list.dart';
import 'package:isms/views/screens/home_screen.dart';

/// All named routes defined in the [GoRouter] configuration below
enum NamedRoutes { home, login, adminConsole, courses }

/// Named [RouterConfig] object used to enable direct linking to and access of pages within the app by URL.
/// This is returned as [GoRouter] from package `go_router`, which allows more fine-tuned control than base Flutter classes.
final GoRouter ismsRouter = GoRouter(
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) =>
      Provider.of<LoggedInState>(context, listen: false).currentUser == null ? '/login' : null,
  routes: [
    GoRoute(
        name: NamedRoutes.home.name,
        path: '/',
        builder: (BuildContext context, GoRouterState state) => const HomePage()),
    GoRoute(
      name: NamedRoutes.login.name,
      path: '/login',
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
      redirect: (BuildContext context, GoRouterState state) =>
          Provider.of<LoggedInState>(context, listen: false).currentUser != null ? '/' : null,
    ),
    GoRoute(
      name: NamedRoutes.adminConsole.name,
      path: '/admin_console',
      builder: (BuildContext context, GoRouterState state) => const AdminUserDetailsScreen(),
      redirect: (BuildContext context, GoRouterState state) =>
          Provider.of<LoggedInState>(context, listen: false).currentUserRole != 'admin' ? '/' : null,
    ),
    GoRoute(
      name: NamedRoutes.courses.name,
      path: '/courses',
      builder: (BuildContext context, GoRouterState state) => const CourseList(),
    ),
  ],
);
