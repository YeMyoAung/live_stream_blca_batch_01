import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';

///Stateless
class LiveStreamVideo<T extends LiveStreamBaseBloc> extends StatelessWidget {
  const LiveStreamVideo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final T liveStreamBloc = context.read<T>();
    if (liveStreamBloc.isHost) {
      return AgoraVideoView(
        controller: liveStreamBloc.hostVideoView,
      );
    }
    return StreamBuilder(
      stream: liveStreamBloc.guestLiveStreamConnection,
      builder: (_, snp) {
        final conn = liveStreamBloc.guestLiveStreamLastConnection;
        if (conn == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }
        return AgoraVideoView(
          key: UniqueKey(),
          controller: VideoViewController.remote(
            rtcEngine: liveStreamBloc.rtcEngine,
            canvas: VideoCanvas(
              uid: conn.remoteId,
            ),
            connection: conn.connection,
          ),
        );
      },
    );
  }
}
