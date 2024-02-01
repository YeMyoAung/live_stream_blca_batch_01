import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:live_stream/views/screens/home/widgets/home_bottom_nav.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    final PostService postService = Locator<PostService>();
    final theme = context.theme;

    return Scaffold(
      body: PageView.builder(
        controller: homePageBloc.controller,
        itemCount: 3,
        itemBuilder: (_, i) {
          return BlocBuilder<PostBloc, PostBaseState>(
            builder: (_, state) {
              final posts = state.posts;
              if (state is PostLoadingState) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              return RefreshIndicator(
                onRefresh: postService.refresh,
                child: ListView.separated(
                  separatorBuilder: (_, i) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (_, i) {
                    final post = posts[i];
                    final contentLength = post.content.length;
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                    post.profilePhoto,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.displayName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      DateTime.now().differenceTimeInString(
                                          post.createdAt),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                post.content.substring(
                                  0,
                                  contentLength > 200 ? 200 : contentLength,
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Align(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                width: 180,
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Watch Now",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: theme.cardTheme.color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.play_arrow,
                                      color: theme.cardTheme.color,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const HomeBottomNav(),
    );
  }
}
