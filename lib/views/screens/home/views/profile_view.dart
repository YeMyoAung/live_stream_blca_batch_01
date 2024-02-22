import 'package:flutter/material.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/views/screens/home/views/home_view.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CreatePostFloatingActionButton(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        actions: [
          IconButton(
            onPressed: () {
              StarlightUtils.pushNamed(RouteNames.setting);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const ShowPosts<MyPostBloc>(),
    );
  }
}
