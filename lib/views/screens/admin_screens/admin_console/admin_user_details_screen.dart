import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:isms/controllers/admin_management/admin_provider.dart';
import 'package:isms/controllers/user_management/logged_in_state.dart';
import 'package:isms/utilities/platform_check.dart';
import 'package:isms/views/widgets/shared_widgets/app_footer.dart';
import 'package:provider/provider.dart';

class AdminUserDetailsScreen extends StatelessWidget {
  const AdminUserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedInState = context.watch<LoggedInState>();
    final adminProvider = context.watch<AdminProvider>();
    final String uid = 'gZZg3iv6e2YsoMXlMrXIVgf6Ycl2';
    Map courses = AdminProvider.getCoursesForUser(uid);
    return Scaffold(
      bottomNavigationBar:
          PlatformCheck.bottomNavBarWidget(loggedInState, context: context),
      appBar: PlatformCheck.topNavBarWidget(loggedInState, context: context),
      body: FooterView(
        footer: kIsWeb
            ? Footer(
                backgroundColor: Colors.transparent, child: const AppFooter())
            : Footer(backgroundColor: Colors.transparent, child: Container()),
        children: <Widget>[
          Column(
            children: [
              Text('$uid'),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    String key = courses.keys.elementAt(index);
                    return ListTile(
                      title: Text(courses[key].courseId),
                      subtitle: Text(courses[key].completionStatus.toString()),
                    );
                  })
            ],
          ),
        ],
      ),
    );
  }
}
