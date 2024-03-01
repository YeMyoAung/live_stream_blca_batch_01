import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_host_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_comment.dart';
import 'package:starlight_utils/starlight_utils.dart';

class LiveComments<T extends LiveStreamBaseBloc> extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    UiLiveStreamComment comment,
  ) builder;
  final double? width, height;

  const LiveComments({
    super.key,
    required this.builder,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final T liveStreamBloc = context.read<T>();

    return SizedBox(
      width: width,
      height: height,
      child: PageView(
        physics: const PageScrollPhysics(),
        onPageChanged: (index) {
          if (index == 0) {
            liveStreamBloc.liveComments;
          }
        },
        children: [
          StreamBuilder<List<UiLiveStreamComment>>(
            stream: liveStreamBloc.liveComments,
            builder: (_, snapshot) {
              final result = snapshot.data ?? [];
              return ListView.separated(
                reverse: true,
                controller: liveStreamBloc.commentScrollController,
                padding: EdgeInsets.only(
                  bottom: liveStreamBloc.service is LiveStreamHostService
                      ? 20
                      : 120,
                  top: 20,
                ),
                separatorBuilder: (_, i) => const SizedBox(
                  height: 15,
                ),
                itemCount: result.length,
                itemBuilder: (_, index) {
                  return builder(
                    context,
                    result[index],
                  );
                },
              );
            },
          ),
          Container(
            color: const Color.fromRGBO(255, 255, 255, 0.001),
            width: context.width,
            height: context.height,
          )
        ],
      ),
    );
  }
}
