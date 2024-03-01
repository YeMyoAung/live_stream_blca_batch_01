import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';

class NetworkUserInfo extends StatelessWidget {
  final Widget Function(User) builder;

  const NetworkUserInfo({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: locator<AuthService>().userChanges(),
      builder: (_, snap) {
        final data = snap.data;
        if (data == null) return const SizedBox();
        return builder(data);
      },
    );
  }
}
