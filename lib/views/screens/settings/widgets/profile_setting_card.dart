import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/views/screens/settings/widgets/network_user_info.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileSettingCard extends StatelessWidget {
  final void Function()? onTap;
  final String title;
  final String Function(User) value;

  const ProfileSettingCard({
    super.key,
    this.onTap,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final textColor = theme.textTheme.bodyLarge?.color;
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor,
        ),
      ),
      trailing: NetworkUserInfo(
        builder: (user) {
          return Text(
            value(user),
            style: TextStyle(
              color: textColor,
              fontSize: 14,
            ),
          );
        },
      ),
    );
  }
}
