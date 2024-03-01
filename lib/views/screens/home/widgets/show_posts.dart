import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/views/screens/home/widgets/post_card.dart';
import 'package:live_stream/views/screens/home/widgets/post_not_found.dart';

class ShowPosts<T extends PostBaseBloc> extends StatelessWidget {
  final EdgeInsetsGeometry? padding;

  const ShowPosts({super.key, this.padding});

  @override
  Widget build(BuildContext context) {
    final postBloc = context.read<T>();
    return BlocBuilder<T, PostBaseState>(
      builder: (_, state) {
        final posts = state.posts;
        if (state is PostLoadingState) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (posts.isEmpty) {
          return PostNotFound<T>();
        }

        return RefreshIndicator(
          onRefresh: () async {
            postBloc.add(const PostRefreshEvent());
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: postBloc.scrollController,
            padding: padding ?? const EdgeInsets.only(bottom: 10),
            separatorBuilder: (_, i) => const SizedBox(
              height: 10,
            ),
            itemCount: posts.length,
            itemBuilder: (_, i) {
              final post = posts[i];

              return PostCard<T>(
                post: post,
              );
            },
          ),
        );
      },
    );
  }
}
