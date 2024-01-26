import 'package:flutter/material.dart';
import 'package:live_stream/models/comment_model.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/views/screens/live_stream/live_stream_screen.dart';
import 'package:live_stream/views/screens/live_stream/view/live_stream_view.dart';
import 'package:live_stream/views/widgets/live_comments.dart';
import 'package:live_stream/views/widgets/live_count.dart';
import 'package:live_stream/views/widgets/live_remark.dart';
import 'package:starlight_utils/starlight_utils.dart';

Widget _builder(BuildContext context, Comments comment) {
  return CommentBox(
    borderRadius: BorderRadius.circular(8),
    comment: comment,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(10),
    backgroundColor: Colors.white.withOpacity(0.8),
    foregroundColor: Colors.black,
  );
}

class LiveStreamFullScreenView extends StatelessWidget {
  final AgoraBaseService service;
  const LiveStreamFullScreenView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final commentHeight = context.height * 0.5;
    final screenWidth = context.width;

    return Stack(
      children: [
        LiveStreamVideo(
          service: service,
        ),
        Positioned(
          left: 20,
          right: 20,
          top: 30,
          child: SizedBox(
            width: screenWidth,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    LiveRemark(),
                    SizedBox(
                      width: 30,
                    ),
                    LiveCount(
                      count: "2.6k",
                    ),
                  ],
                ),
                LiveViewToggle(),
              ],
            ),
          ),
        ),
        if (service is AgoraHostService)
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: screenWidth,
              height: commentHeight,
              child: const LiveComments(
                builder: _builder,
              ),
            ),
          )
        else
          Positioned(
            bottom: 0,
            child: CommentSection(
              builder: _builder,
              borderRadius: BorderRadius.zero,
              backgroundColor: const Color.fromRGBO(70, 70, 70, 0.1),
              commentSectionWidth: screenWidth,
              commentSectionHeight: commentHeight,
            ),
          ),
      ],
    );
  }
}
