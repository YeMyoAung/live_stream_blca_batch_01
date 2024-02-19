import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_event.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_event.dart';
import 'package:live_stream/controllers/live_stream/impl/host/live_stream_host_state.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_host_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:logger/logger.dart';

import '../../../../services/agora/impl/agora_host_service.dart';

class LiveStreamHostBloc
    extends LiveStreamBaseBloc<LiveStreamBaseEvent, LiveStreamBaseState> {
  static final Logger _logger = Logger();
  @override
  final LiveStreamHostService service;

  @override
  final AgoraHostService agoraService;

  LiveStreamHostBloc(this.service, this.agoraService)
      : super(
          const LiveStreamContentCreateInitalState(),
          service,
          agoraService,
        ) {
    on<LiveStreamContentCreateEvent>((_, emit) async {
      if (state is LiveStreamContentCreateLoadingState) return;
      emit(const LiveStreamContentCreateLoadingState());
      final Result<LivePayload> result =
          await service.postCreate(controller.text);
      if (result.hasError) {
        _logger.e(result.error?.message);
        _logger.e(result.error?.stackTrace);
        emit(LiveStreamContentCreateErrorState(
          result.error?.message ?? "Unknown Error",
        ));
        return;
      }
      payload = result.data;
      service.startLiveStream(payload!.liveID);
    });

    on<LiveStreamEndEvent>((_, emit) async {
      assert(payload != null);
      final result = await service.stopLiveStream(payload!.liveID);
      if (result.hasError) {
        Fluttertoast.showToast(msg: result.error!.message);
        return;
      }

      ///TODO::  HOME
    });
  }

  @override
  void defaultSocketConnection() {
    on<LiveStreamSocketConnectEvent>((_, emit) {
      emit(const LiveStreamContentCreateInitalState());
      super.connect();
    });
  }

  @override
  void readyState(bool value) {
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
    print("LiveStreamHostBloc Event: Close");
    focusNode.dispose();
    formKey = null;

    return super.close();
  }
}
