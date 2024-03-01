import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:lottie/lottie.dart';
import 'package:starlight_utils/starlight_utils.dart';

class PostNotFound<T extends PostBaseBloc> extends StatelessWidget {
  const PostNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final refreshTextColor =
        context.theme.floatingActionButtonTheme.backgroundColor;
    final postBloc = context.read<T>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            postBloc.add(const PostRefreshEvent());
          },
          child: LottieBuilder.asset(
            "assets/lotties/notfound.json",
          ),
        ),
        TextButton(
          onPressed: () {
            postBloc.add(const PostRefreshEvent());
          },
          child: Text(
            "Try again",
            style: TextStyle(
              color: refreshTextColor,
            ),
          ),
        )
      ],
    );
  }
}
