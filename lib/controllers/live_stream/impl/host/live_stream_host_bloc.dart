import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_event.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_event.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_state.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/services/agora/impl/agora_host_service.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_host_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:logger/logger.dart';

class LiveStreamHostBloc extends LiveStreamBaseBloc<LiveStreamBaseState> {
  static final Logger _logger = Logger();

  LiveStreamHostService get liveStreamHostService =>
      service as LiveStreamHostService;

  LiveStreamHostBloc(
    LiveStreamHostService service,
    AgoraHostService agoraService,
  ) : super(
          const LiveStreamContentCreateInitialState(),
          service,
          agoraService,
        ) {
    on<LiveStreamContentCreateEvent>(_contentCreateEventHandler);

    on<LiveStreamEndEvent>(_liveStreamEndEventHandler);
  }

  Future<void> _contentCreateEventHandler(
    LiveStreamContentCreateEvent _,
    Emitter emit,
  ) async {
    if (state is LiveStreamContentCreateLoadingState) return;
    emit(const LiveStreamContentCreateLoadingState());
    final Result<LivePayload> result =
        await liveStreamHostService.postCreate(controller.text);
    if (result.hasError) {
      _logger.e(result.error?.message);
      _logger.e(result.error?.stackTrace);
      emit(LiveStreamContentCreateErrorState(
        result.error?.message ?? "Unknown Error",
      ));
      return;
    }

    payload = result.data;
    liveStreamHostService.startLiveStream(payload!.liveID);
  }

  Future<void> _liveStreamEndEventHandler(
    LiveStreamEndEvent _,
    Emitter emit,
  ) async {
    assert(payload != null);
    final result = await liveStreamHostService.stopLiveStream(payload!.liveID);
    if (result.hasError) {
      Fluttertoast.showToast(msg: result.error!.message);
      return;
    }
  }

  @override
  void defaultSocketConnection() {
    on<LiveStreamSocketConnectEvent>((_, emit) {
      emit(const LiveStreamContentCreateInitialState());
      super.connect(emit);
    });
  }

  @override
  void readyState(bool value, Emitter emit) {
    if (value) {
      emit(const LiveStreamReadyState());
    } else {
      emit(const LiveStreamContentCreateErrorState("Connection Time Out"));
    }
  }

  @override
  LiveStreamBaseState? streamStatusListener(bool? value) {
    if (value == null) return null;
    if (value) {
      return const LiveStreamContentCreateSuccessState();
    }
    // Failed
    return const LiveStreamContentCreateErrorState("Failed to live!");
  }

  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  final FocusNode focusNode = FocusNode();

  @override
  Future<void> close() {
    focusNode.dispose();
    formKey = null;

    return super.close();
  }
}
