import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_cubit.dart';
import 'package:live_stream/controllers/live_view_bloc/live_view_state.dart';
import 'package:live_stream/models/comment_model.dart';
import 'package:live_stream/views/widgets/live_button.dart';
import 'package:live_stream/views/widgets/live_comments.dart';
import 'package:live_stream/views/widgets/live_count.dart';
import 'package:live_stream/views/widgets/live_remark.dart';
import 'package:live_stream/views/widgets/live_title.dart';
import 'package:starlight_utils/starlight_utils.dart';

const kVideoRadius = 20.0;
const kBgColor = Color.fromRGBO(45, 40, 42, 1);
final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(kVideoRadius),
);

class LiveStreamScreen extends StatelessWidget {
  const LiveStreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;
    final screenWidth = context.width;
    final isUsedKeyboard = context.viewInsets.bottom > 0;
    final commentSectionHeight =
        isUsedKeyboard ? screenHeight * 0.7 : screenHeight + 0.45;
    return Scaffold(
      backgroundColor: kBgColor,
      body: ViewPortBuilder(
        fullScreen: (context) {
          return Stack(
            children: [
              Container(
                width: screenWidth,
                height: screenHeight,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "https://img.freepik.com/premium-photo/closeup-drop-water-leaf-flower-reflecting-surrounding-colors-textures_674594-4382.jpg?size=626&ext=jpg&ga=GA1.1.632798143.1705881600&semt=ais"),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(kVideoRadius),
                    bottomRight: Radius.circular(kVideoRadius),
                  ),
                ),
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
              Positioned(
                bottom: 0,
                child: CommentSection(
                  builder: (_, comment) {
                    return CommentBox(
                      borderRadius: BorderRadius.circular(8),
                      comment: comment,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white.withOpacity(0.8),
                      foregroundColor: Colors.black,
                    );
                  },
                  borderRadius: BorderRadius.zero,
                  backgroundColor: const Color.fromRGBO(70, 70, 70, 0.1),
                  commentSectionWidth: screenWidth,
                  commentSectionHeight: screenHeight * 0.5,
                ),
              ),
            ],
          );
        },
        minimized: (context) {
          return SizedBox(
            width: screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Video View s3
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: screenWidth,
                  height: screenHeight * 0.3,
                  child: Stack(
                    children: [
                      ///TODO Live View
                      Container(
                        height: screenHeight * 0.3,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                "https://img.freepik.com/premium-photo/closeup-drop-water-leaf-flower-reflecting-surrounding-colors-textures_674594-4382.jpg?size=626&ext=jpg&ga=GA1.1.632798143.1705881600&semt=ais"),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(kVideoRadius),
                            bottomRight: Radius.circular(kVideoRadius),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 0,
                        child: Container(
                          height: 60,
                          width: screenWidth,
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(0, 0, 0, 0.2011),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(kVideoRadius),
                              bottomRight: Radius.circular(kVideoRadius),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 5,
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
                      )
                    ],
                  ),
                ),
                //Content View s2
                if (!isUsedKeyboard)
                  Container(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    height: screenHeight * 0.23,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: LiveTitle(
                            title:
                                "Music stream blah blah fjasdjfkasjfkasjd fjasdklfjakl fjadskfjfajskdfj fdaskfj fasdujo dfasjk",
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                LiveButton(
                                  width: 55,
                                  height: 55,
                                  color: Colors.black,
                                  iconColor: Colors.white,
                                  icon: Icons.star,
                                ),
                                LiveButton(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  width: 55,
                                  height: 55,
                                  color: Colors.black,
                                  iconColor: Colors.white,
                                  icon: Icons.thumb_up,
                                ),
                                LiveButton(
                                  width: 55,
                                  height: 55,
                                  color: Colors.black,
                                  iconColor: Colors.white,
                                  icon: Icons.notifications_active,
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 110,
                              height: 50,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text("Donate"),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                //Chat View s5
                Expanded(
                  child: CommentSection(
                    commentSectionWidth: screenWidth,
                    commentSectionHeight: commentSectionHeight,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

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
                ? builder!.call
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
              maxLines: null,
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
