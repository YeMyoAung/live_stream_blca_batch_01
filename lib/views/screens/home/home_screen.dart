import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/views/screens/home/views/home_view.dart';
import 'package:live_stream/views/screens/home/views/profile_view.dart';
import 'package:live_stream/views/screens/home/views/search_view.dart';
import 'package:live_stream/views/screens/home/widgets/home_bottom_nav.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        // onPageChanged: (page) {
        //   homePageBloc.add(OnScrollEvent(page));
        // },
        controller: homePageBloc.controller,
        itemCount: 3,
        itemBuilder: (_, i) {
          return const [
            HomeView(),
            SearchView(), //Search View
            ProfileView(), // Profile View
          ][i];
        },
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
