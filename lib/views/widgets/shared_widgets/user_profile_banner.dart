import 'package:flutter/material.dart';
import 'package:isms/controllers/admin_management/admin_state.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';
import 'package:isms/controllers/theme_management/theme_config.dart';

class UserProfileBanner extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;

  AdminState adminState;
  Map userAllData = {};
  String uid = '';
  String? note;

  UserProfileBanner({
    required this.userName,
    required this.userEmail,
    required this.userRole,
    required this.adminState,
    required String uid,
    this.note,
  });

  String get profileImageUrl => '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 40, // Adjust the size of the avatar
              ),
              SizedBox(width: 16),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.blue,
                child: SizedBox(
                  height: 90,
                  width: 1,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: TextStyle(
                          color: ThemeConfig.primaryTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        userEmail,
                        style: TextStyle(
                          color: ThemeConfig.primaryTextColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        userRole,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      if (note != null) Text('${note}'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
