import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:live_stream/views/screens/home/widgets/card_action_button.dart';
import 'package:live_stream/views/widgets/network_profile.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostCard<T extends PostBaseBloc> extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  int get contentLength => post.content.length;

  bool get isActive => post.status == "on_going";

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final screenWidth = context.width;
    final textColor = theme.textTheme.bodyLarge?.color;
    final postBloc = context.read<T>();
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
                NetworkProfile(
                  profileUrl: post.profilePhoto,
                  radius: null,
                  onFail: const CircleAvatar(),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.displayName,
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                      ),
                    ),
                    Text(
                      DateTime.now().differenceTimeInString(post.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: textColor,
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
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor,
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
                  post.status == "on_going" ? Icons.play_arrow : Icons.close,
                  color: theme.floatingActionButtonTheme.foregroundColor,
                  size: 40,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    postBloc.add(LikePostEvent(post.id));
                  },
                  child: CardActionButton(
                    icon: CommunityMaterialIcons.thumb_up_outline,
                    color: post.isLike
                        ? theme.floatingActionButtonTheme.backgroundColor
                        : null,
                  ),
                ),
              ),
              Expanded(
                child: CardActionButton(
                  icon: CommunityMaterialIcons.comment_outline,
                  label: "${post.commentCount}",
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
