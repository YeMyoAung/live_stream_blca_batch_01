import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';

///Stateless
class LiveStreamVideo extends StatefulWidget {
  //BLOC
  final AgoraBaseService service;
  const LiveStreamVideo({
    super.key,
    required this.service,
  });

  @override
  State<LiveStreamVideo> createState() => _LiveStreamVideoState();
}

class _LiveStreamVideoState extends State<LiveStreamVideo> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await widget.service.init();

    widget.service.handler = AgoraHandler.fast();

    await widget.service.ready();

    await widget.service.live(
      "007eJxTYPg7g6Nw+3rNwO+PtVfLCj/d8D2xbAJP6d3+ta49S4I/3p6mwJBqkWxmaJGamGZsmGJiam5kkZRsZJRmaJRiZpRskWxgFLFmc2pDICPDzwl+zIwMEAjiszCUpBaXMDAAAPJAIeM=",
      "test",
    );
  }

  @override
  void dispose() {
    widget.service.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.service.onLive.stream,
      builder: (_, snp) {
        if (widget.service is AgoraHostService) {
          return AgoraVideoView(
            controller: widget.service.videoViewController,
          );
        }
        final conn = widget.service.connection;
        if (conn == null) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return AgoraVideoView(
          controller: widget.service is AgoraHostService
              ? widget.service.videoViewController
              : VideoViewController.remote(
                  rtcEngine: widget.service.engine,
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
