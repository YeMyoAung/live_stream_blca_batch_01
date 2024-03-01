import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/controllers/home/home_page_event.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/views/screens/home/widgets/post_create_floating_action_button.dart';
import 'package:live_stream/views/screens/home/widgets/show_posts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("BLCA Live Stream"),
        actions: [
          IconButton(
            onPressed: () {
              homePageBloc.add(const GoToSearchPageEvent());
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      floatingActionButton: const CreatePostFloatingActionButton(),
      body: const ShowPosts<PostBloc>(),
    );
  }
}
