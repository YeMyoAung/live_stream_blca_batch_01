import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LoginLottie extends StatelessWidget {
  const LoginLottie({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.width;
    final screenHeight = context.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromRGBO(255, 81, 81, 1),
            Color.fromRGBO(227, 125, 144, 1),
            Color.fromRGBO(249, 165, 155, 1),
          ],
        ),
      ),
      width: screenWidth,
      height: screenHeight,
      child: Lottie.asset(
        "assets/lotties/login.json",
        fit: BoxFit.contain,
      ),
    );
  }
}
