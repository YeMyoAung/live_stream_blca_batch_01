import 'dart:developer';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_stream/locator.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final google = GoogleSignIn.standard();
    final screenWidth = context.width;
    final screenHeight = context.height;
    // Locator<FirebaseAuth>().currentUser?.getIdToken().then(print);
    return Scaffold(
      // body: Center(
      // child: ElevatedButton(
      //   onPressed: () async {
      // final GoogleSignInAccount? account = await google.signIn();
      // final GoogleSignInAuthentication? authentication =
      //     await account?.authentication;
      // authentication?.idToken;
      // // // google.signOut();
      // // Locator<FirebaseAuth>().signInWithCredential(
      // //   GoogleAuthProvider.credential(
      // //       idToken: authentication?.idToken,
      // //       accessToken: authentication?.accessToken),
      // // );
      // Locator<FirebaseAuth>().currentUser?.getIdToken().then(print);
      //   },
      //   child: const Text("Login With Google"),
      // ),
      // ),
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
                  await google.signOut();
                  final GoogleSignInAccount? account = await google.signIn();
                  final GoogleSignInAuthentication? authentication =
                      await account?.authentication;

                  Locator<FirebaseAuth>().signInWithCredential(
                    GoogleAuthProvider.credential(
                      accessToken: authentication?.accessToken,
                    ),
                  );
                  Locator<FirebaseAuth>()
                      .currentUser
                      ?.getIdToken()
                      .then((v) => log(v ?? ""));
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
                onPressed: () async {
                  await Locator<FirebaseAuth>().signOut();
                  final LoginResult result =
                      await FacebookAuth.instance.login();
                  if (result.status == LoginStatus.success) {
                    final OAuthCredential credential = OAuthCredential(
                      providerId: "facebook.com",
                      signInMethod: "facebook.com",
                      accessToken: result.accessToken!.token,
                    );
                    // Once signed in, return the UserCredential
                    await Locator<FirebaseAuth>()
                        .signInWithCredential(credential);
                    Locator<FirebaseAuth>()
                        .currentUser
                        ?.getIdToken()
                        .then((v) => log(v ?? ""));
                  }
                },
                icon: const Icon(CommunityMaterialIcons.facebook),
                label: const Text(
                  "Login With Facebook",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
