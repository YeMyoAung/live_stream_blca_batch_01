import 'package:flutter/material.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/views/screens/home/widgets/post_create_floating_action_button.dart';
import 'package:live_stream/views/screens/home/widgets/show_posts.dart';
import 'package:starlight_utils/starlight_utils.dart';

void _goToSettingPage() {
  StarlightUtils.pushNamed(RouteNames.setting);
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CreatePostFloatingActionButton(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile"),
        actions: const [
          IconButton(
            onPressed: _goToSettingPage,
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: const ShowPosts<MyPostBloc>(),
    );
  }
}
