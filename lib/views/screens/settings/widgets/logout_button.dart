import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:starlight_utils/starlight_utils.dart';

Future<void> _logout() async {
  await locator<AuthService>().logout();
  StarlightUtils.pushReplacementNamed(RouteNames.home);
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return TextButton(
      onPressed: _logout,
      child: Text(
        "Logout",
        style: TextStyle(
          fontSize: 18,
          color: theme.floatingActionButtonTheme.backgroundColor,
        ),
      ),
    );
  }
}
