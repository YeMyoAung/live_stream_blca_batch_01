import 'package:flutter/material.dart';
import 'package:live_stream/views/screens/auth/widgets/login_loading_indicator.dart';
import 'package:live_stream/views/screens/auth/widgets/login_lotatie.dart';
import 'package:live_stream/views/screens/auth/widgets/login_with_facebook.dart';
import 'package:live_stream/views/screens/auth/widgets/login_with_google.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          LoginLottie(),
          Positioned(
            left: 20,
            right: 20,
            bottom: 110,
            child: LoginWithGoogle(),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: LoginWithFacebook(),
          ),
          LoginLoadingIndicator()
        ],
      ),
    );
  }
}
