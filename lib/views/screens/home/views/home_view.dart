import 'package:cached_network_image/cached_network_image.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/home/home_page_bloc.dart';
import 'package:live_stream/controllers/home/home_page_event.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:starlight_utils/starlight_utils.dart';

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

class CreatePostFloatingActionButton extends StatelessWidget {
  const CreatePostFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        StarlightUtils.pushNamed(RouteNames.postCreate);
      },
      child: const Icon(Icons.edit),
    );
  }
}

class ShowPosts<T extends PostBaseBloc> extends StatelessWidget {
  const ShowPosts({super.key});

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
        return RefreshIndicator(
          onRefresh: () async {
            ///
          },
          child: ListView.separated(
            controller: postBloc.scrollController,
            padding: const EdgeInsets.only(bottom: 10),
            separatorBuilder: (_, i) => const SizedBox(
              height: 10,
            ),
            itemCount: posts.length,
            itemBuilder: (_, i) {
              final post = posts[i];

              return PostCard(
                post: post,
              );
            },
          ),
        );
      },
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  int get contentLength => post.content.length;

  bool get isActive => post.status == "on_going";

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final screenWidth = context.width;
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            child: Row(
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
                      DateTime.now().differenceTimeInString(post.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20,
              right: 20,
              left: 20,
              bottom: 20,
            ),
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
          Container(
            width: screenWidth,
            height: 150,
            alignment: Alignment.center,
            decoration:
                const BoxDecoration(color: Color.fromRGBO(82, 76, 76, 0.098)),
            child: GestureDetector(
              onTap: () {
                if (!isActive) {
                  Fluttertoast.showToast(
                    msg: "End",
                    // textColor: Colors.black,
                    // backgroundColor: const Color.fromRGBO(82, 76, 76, 0.098),
                  );
                  return;
                }
                StarlightUtils.pushNamed(
                  RouteNames.view,
                  arguments: LivePayload(
                    userID: post.userId,
                    liveID: post.liveId,
                    channel: post.channel,
                    token: "",
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(80),
                ),
                width: 60,
                height: 60,
                child: Icon(
                  Icons.play_arrow,
                  color: theme.cardTheme.color,
                  size: 40,
                ),
              ),
            ),
          ),
          Row(
            children: [
              const Expanded(
                child: CardActionButton(
                  icon: CommunityMaterialIcons.thumb_up_outline,
                ),
              ),
              const Expanded(
                child: CardActionButton(
                  icon: CommunityMaterialIcons.comment_outline,
                ),
              ),
              Expanded(
                child: CardActionButton(
                  label: post.viewCount.toString(),
                  icon: CommunityMaterialIcons.eye,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class CardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const CardActionButton({
    super.key,
    this.icon = Icons.thumb_up,
    this.label = "like",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}
