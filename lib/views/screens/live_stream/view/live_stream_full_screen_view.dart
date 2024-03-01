import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_comment.dart';
import 'package:live_stream/views/screens/live_stream/live_stream_screen.dart';
import 'package:live_stream/views/screens/live_stream/view/live_stream_view.dart';
import 'package:live_stream/views/screens/live_stream/widgets/live_stream_header.dart';
import 'package:live_stream/views/widgets/live_comments.dart';
import 'package:starlight_utils/starlight_utils.dart';

Widget _builder(BuildContext context, UiLiveStreamComment comment) {
  return CommentBox(
    borderRadius: BorderRadius.circular(8),
    comment: comment,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    padding: const EdgeInsets.all(10),
    backgroundColor: Colors.white.withOpacity(0.8),
    foregroundColor: Colors.black,
  );
}

class LiveStreamView<T extends LiveStreamBaseBloc> extends StatelessWidget {
  const LiveStreamView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<T>();

    final commentHeight = context.height * 0.5;
    final screenWidth = context.width;
    return Stack(
      children: [
        LiveStreamVideo<T>(),
        Positioned(
          left: 20,
          right: 20,
          top: 30,
          child: LiveStreamHeader<T>(),
        ),
        if (bloc.isHost)
          Positioned(
            bottom: 0,
            child: LiveComments<T>(
              width: screenWidth,
              height: commentHeight,
              builder: _builder,
            ),
          )
        else
          Positioned(
            bottom: 0,
            child: CommentSection<T>(
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
