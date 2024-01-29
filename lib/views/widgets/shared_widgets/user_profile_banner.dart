import 'package:flutter/material.dart';
import 'package:isms/controllers/theme_management/app_colors.dart';
import 'package:isms/controllers/theme_management/app_theme.dart';

class UserProfileBanner extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userRole;
  final String profileImageUrl;

  UserProfileBanner({
    required this.userName,
    required this.userEmail,
    required this.userRole,
    this.profileImageUrl = 'default_profile_image_url', // Replace with actual URL or path
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Assuming you have a theme set up in your app

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
                radius: 50, // Adjust the size of the avatar
              ),
              Column(
                children: [
                  Text(
                    userName,
                    style: TextStyle(color: AppColors.primary), // Use your AppTheme's text theme
                  ),
                  SizedBox(height: 8),
                  Text(
                    userEmail,
                    style: theme.textTheme.subtitle2,
                  ),
                  SizedBox(height: 8),
                  Text(
                    userRole,
                    style: theme.textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
