import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/services/ui_live_stream/base/ui_live_stream_base_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_comment.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';

import 'live_stream_base_event.dart';

abstract class LiveStreamBaseBloc<S> extends Bloc<LiveStreamBaseEvent, S> {
  bool get isHost => agoraService is AgoraHostService;

  AgoraLiveConnection? get guestLiveStreamLastConnection =>
      agoraService.connection;

  Stream<AgoraLiveConnection?> get guestLiveStreamConnection =>
      agoraService.onLive.stream;

  VideoViewController get hostVideoView => agoraService.videoViewController;

  RtcEngine get rtcEngine => agoraService.engine;

  LivePayload? payload;

  late final AgoraHandler handler;

  final LiveStreamBaseService service;
  final AgoraBaseService agoraService;

  StreamSubscription? _streamStatusSubscription;

  LiveStreamBaseBloc(super.initialState, this.service, this.agoraService) {
    on<LiveStreamInitEvent>((_, emit) async {
      ///Socket Status (Connect, Disconnect)
      connect(emit);

      ///LiveStreamSocketConnectEvent
      defaultSocketConnection();

      handler = AgoraHandler.dummy();

      _streamStatusSubscription = service.streamStatus.listen((value) {
        _streamStatusListener(value, emit);
      });
      await _streamStatusSubscription?.asFuture();
    });

    add(const LiveStreamInitEvent());
  }

  Future<void> connect(Emitter emit) async {
    return service.isSocketReady
        .then((v) => readyState(v, emit))
        .timeout(const Duration(seconds: 5), onTimeout: () {
      readyState(false, emit);
    });
  }

  void defaultSocketConnection();

  void readyState(bool value, Emitter emit);

  StreamSubscription? _commentStreamSubscription;

  Future<void> _streamStatusTrigger() async {
    assert(payload != null);

    await agoraService.init();

    agoraService.handler = handler;

    await agoraService.ready();

    await agoraService.live(
      payload!.token,
      payload!.channel,
      payload!.userID,
    );

    _commentStreamSubscription = service.comments.listen(_loadComments);
  }

  Stream<List<UiLiveStreamComment>> get liveComments => service.comments;

  void _loadComments(event) {
    commentScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.linear,
    );
  }

  void _streamStatusListener(bool? value, Emitter<S> emit) {
    final newState = streamStatusListener(value);
    if (newState == null) return;
    emit(newState);
    if (value == true) {
      _streamStatusTrigger();
    }
  }

  S? streamStatusListener(bool? value);

  ///Comment
  final TextEditingController controller = TextEditingController();

  final ScrollController commentScrollController = ScrollController();

  @override
  Future<void> close() async {
    await agoraService.close();
    commentScrollController.dispose();
    controller.dispose();
    await _streamStatusSubscription?.cancel();
    await _commentStreamSubscription?.cancel();

    // service.dispose();
    return super.close();
  }
}
