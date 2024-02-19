import 'package:flutter/material.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/views/screens/live_stream/live_stream_screen.dart';
import 'package:live_stream/views/screens/live_stream/view/live_stream_view.dart';
import 'package:live_stream/views/widgets/live_button.dart';
import 'package:live_stream/views/widgets/live_count.dart';
import 'package:live_stream/views/widgets/live_remark.dart';
import 'package:live_stream/views/widgets/live_title.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LiveStreamMinizedScreenView extends StatelessWidget {
  final AgoraBaseService service;

  const LiveStreamMinizedScreenView({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;
    final screenWidth = context.width;
    final isUsedKeyboard = context.viewInsets.bottom > 0;
    final commentSectionHeight =
        isUsedKeyboard ? screenHeight * 0.7 : screenHeight + 0.45;
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
                SizedBox(
                  height: screenHeight * 0.3,
                  child: const LiveStreamVideo(),
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
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
  }
}
