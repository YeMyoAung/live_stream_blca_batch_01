import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_state.dart';
import 'package:live_stream/models/comment_model.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/views/screens/live_stream/view/live_stream_full_screen_view.dart';
import 'package:live_stream/views/screens/live_stream/view/live_stream_minized_screen_view.dart';
import 'package:live_stream/views/widgets/live_comments.dart';

const kVideoRadius = 20.0;
const kBgColor = Color.fromRGBO(45, 40, 42, 1);
final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(kVideoRadius),
);

class LiveStreamScreen extends StatelessWidget {
  final AgoraBaseService service;

  const LiveStreamScreen({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    if (service is AgoraHostService) {
      return Scaffold(
        body: LiveStreamFullScreenView(
          service: service,
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBgColor,
      body: ViewPortBuilder(
        fullScreen: (context) {
          return LiveStreamFullScreenView(
            service: service,
          );
        },
        minimized: (context) {
          return LiveStreamMinizedScreenView(service: service);
        },
      ),
    );
  }
}

//3850026755
class CommentSection extends StatelessWidget {
  final Widget Function(BuildContext, Comments)? builder;
  final double commentSectionWidth, commentSectionHeight;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  const CommentSection({
    super.key,
    required this.commentSectionWidth,
    required this.commentSectionHeight,
    this.borderRadius,
    this.backgroundColor,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: commentSectionWidth,
      height: commentSectionHeight,
      decoration: BoxDecoration(
        borderRadius: borderRadius ??
            const BorderRadius.only(
              topLeft: Radius.circular(kVideoRadius),
              topRight: Radius.circular(kVideoRadius),
            ),
        color: backgroundColor ?? Colors.black.withOpacity(0.7),
      ),
      child: Stack(
        children: [
          LiveComments(
            builder: builder != null
                ? builder!
                : (_, comment) {
                    return CommentBox(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      comment: comment,
                    );
                  },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,

            ///Home Work
            child: TextField(
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              style: const TextStyle(
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: "Type here...",
                hintStyle: const TextStyle(
                  color: Colors.white60,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
                contentPadding: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                fillColor: kBgColor.withOpacity(0.8),
                filled: true,
                border: border,
                focusedBorder: border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ViewPortBuilder extends StatelessWidget {
  final Widget Function(BuildContext context) fullScreen;
  final Widget Function(BuildContext context) minimized;
  const ViewPortBuilder({
    super.key,
    required this.fullScreen,
    required this.minimized,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LiveViewCubit, LiveViewState>(
      builder: (_, state) {
        if (state is MinimizedLiveViewState) {
          return minimized(context);
        }
        return fullScreen(context);
      },
    );
  }
}

class CommentBox extends StatelessWidget {
  final Comments comment;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor, foregroundColor;
  final BorderRadiusGeometry? borderRadius;
  const CommentBox({
    super.key,
    required this.comment,
    this.backgroundColor,
    this.foregroundColor,
    this.margin,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = foregroundColor ?? Colors.white;
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: color,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                "Person ${comment.createdAt}",
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              comment.message,
              style: TextStyle(
                color: color,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LiveViewToggle extends StatelessWidget {
  const LiveViewToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<LiveViewCubit>();
    return IconButton(
      onPressed: bloc.toggle,
      icon: BlocBuilder<LiveViewCubit, LiveViewState>(
        builder: (_, state) {
          return Icon(
            state is MinimizedLiveViewState
                ? Icons.view_in_ar_outlined
                : Icons.compare_arrows,
            color: Colors.white,
          );
        },
      ),
    );
  }
}
