import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_event.dart';
import 'package:live_stream/controllers/auth_bloc/auth_state.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    final screenWidth = context.width;
    final screenHeight = context.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 110,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                )),
                onPressed: () async {
                  authBloc.add(const LoginWithGoogleEvent());
                },
                icon: const Icon(CommunityMaterialIcons.google),
                label: const Text(
                  "Login With Google",
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: () {
                  authBloc.add(const LoginWithFacebookEvent());
                },
                icon: const Icon(CommunityMaterialIcons.facebook),
                label: const Text(
                  "Login With Facebook",
                ),
              ),
            ),
          ),
          BlocBuilder<AuthBloc, LoginState>(
            builder: (_, state) {
              if (state is LoginLoadingState) {
                return Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: const Color.fromARGB(20, 29, 27, 27),
                  child: const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                );
              }
              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
