import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_bloc.dart';
import 'package:live_stream/controllers/auth_bloc/auth_event.dart';

class LoginWithFacebook extends StatelessWidget {
  const LoginWithFacebook({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthBloc authBloc = context.read<AuthBloc>();
    return SizedBox(
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
    );
  }
}
