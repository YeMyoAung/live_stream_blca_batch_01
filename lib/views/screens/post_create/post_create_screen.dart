import 'package:flutter/material.dart';
import 'package:live_stream/views/screens/post_create/widgets/content_panel.dart';
import 'package:live_stream/views/screens/post_create/widgets/post_create_loading_indicator.dart';
import 'package:live_stream/views/screens/post_create/widgets/start_live_button.dart';

class PostCreateScreen extends StatelessWidget {
  const PostCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Live"),
        actions: const [
          StartLiveButton(),
        ],
      ),
      body: const Stack(
        children: [ContentPanel(), PostCreateLoadingIndicator()],
      ),
    );
  }
}
