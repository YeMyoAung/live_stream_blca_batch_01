import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_event.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/guest/live_stream_guest_event.dart';
import 'package:live_stream/controllers/live_stream/impl/guest/live_stream_guest_state.dart';
import 'package:live_stream/services/agora/impl/agora_guest_service.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_guest_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';

class LiveStreamGuestBloc extends LiveStreamBaseBloc<LiveStreamBaseState> {
  LiveStreamGuestService get liveStreamGuestService =>
      service as LiveStreamGuestService;

  LiveStreamGuestBloc(
    ///Post Owner
    LivePayload payload,
    LiveStreamGuestService service,
    AgoraGuestService agoraService,
  ) : super(
          const LiveStreamGuestInitialState(),
          service,
          agoraService,
        ) {
    super.payload = payload;

    on<LiveStreamGuestJoinEvent>(_joinEventHandler);

    on<LiveStreamGuestSendCommentEvent>(_commentHandler);

    add(const LiveStreamGuestJoinEvent());
  }

  Future<void> _commentHandler(
    LiveStreamGuestSendCommentEvent _,
    Emitter emit,
  ) async {
    final comment = controller.text;
    if (comment.isEmpty) return;
    controller.clear();
    final result = await service.sendComment(super.payload!.liveID, comment);
    if (result.hasError) {
      Fluttertoast.showToast(msg: result.error!.message);
      return;
    }
  }

  Future<void> _joinEventHandler(
    LiveStreamGuestJoinEvent _,
    Emitter emit,
  ) async {
    assert(payload != null);
    if (state is LiveStreamGuestJoiningState) return;

    emit(const LiveStreamGuestJoiningState());
    final token = await liveStreamGuestService.generateToken(
      payload!.liveID,
      payload!.channel,
    );
    if (token.hasError) {
      emit(LiveStreamGuestFailedToJoinState(token.error!.message));
      return;
    }

    payload = payload!.updateToken(
      token.data['uid'],
      token.data['token'],
    );

    liveStreamGuestService.join(payload!.liveID);
  }

  @override
  void defaultSocketConnection() {
    on<LiveStreamSocketConnectEvent>((_, emit) {
      emit(const LiveStreamGuestInitialState());
      super.connect(emit);
    });
  }

  @override
  void readyState(bool value, Emitter emit) {
    if (value) {
      emit(const LiveStreamReadyState());
    } else {
      emit(const LiveStreamGuestFailedToJoinState("Connection Time Out"));
    }
  }

  @override
  LiveStreamBaseState? streamStatusListener(bool? value) {
    if (value == null) return null;
    if (value) {
      return const LiveStreamGuestJoinedState();
    }
    return const LiveStreamGuestFailedToJoinState("Unknown Error");
  }
}
