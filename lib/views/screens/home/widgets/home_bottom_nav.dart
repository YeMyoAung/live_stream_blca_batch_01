import 'dart:developer';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/views/widgets/network_profile.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final bottomNavTheme = theme.bottomNavigationBarTheme;
    final authService = locator<AuthService>();
    final homePageBloc = context.read<HomePageBloc>();
    authService.currentUser?.getIdToken().then((v) => log(v ?? ""));

    return GNav(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      activeColor: bottomNavTheme.selectedItemColor,
      color: bottomNavTheme.unselectedItemColor,
      backgroundColor: bottomNavTheme.backgroundColor!,
      onTabChange: (value) {
        homePageBloc.add(homePageBloc.active(value));
      },
      selectedIndex: homePageBloc.state,
      tabs: [
        const GButton(
          icon: CommunityMaterialIcons.fire,
          gap: 10,
          iconSize: 33,
          text: "Home",
        ),
        const GButton(
          icon: Icons.search,
          gap: 10,
          iconSize: 34,
          text: "Search",
        ),
        GButton(
          icon: Icons.person,
          // textColor: bottomNavTheme.unselectedItemColor,
          leading: StreamBuilder(
            stream: authService.userChanges(),
            builder: (_, snap) {
              final String? url = snap.data?.photoURL;
              if (url == null) {
                return const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                );
              }
              return NetworkProfile(
                profileUrl: url,
                radius: null,
                onFail: const CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.person),
                ),
              );
            },
          ),
          gap: 10,
          text: authService.currentUser?.displayName ??
              authService.currentUser?.email ??
              "Account",
        ),
      ],
    );
  }
}
