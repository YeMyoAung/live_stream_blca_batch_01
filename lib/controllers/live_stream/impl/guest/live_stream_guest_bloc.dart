import 'package:fluttertoast/fluttertoast.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_bloc.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_event.dart';
import 'package:live_stream/controllers/live_stream/base/live_stream_base_state.dart';
import 'package:live_stream/controllers/live_stream/impl/guest/live_stream_guest_event.dart';
import 'package:live_stream/controllers/live_stream/impl/guest/live_stream_guest_state.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/services/agora/impl/agora_guest_service.dart';
import 'package:live_stream/services/ui_live_stream/impl/ui_live_stream_guest_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';

class LiveStreamGuestBloc
    extends LiveStreamBaseBloc<LiveStreamBaseEvent, LiveStreamBaseState> {
  @override
  final LiveStreamGuestService service;

  @override
  final AgoraGuestService agoraService;

  LiveStreamGuestBloc(
    ///Post Owner
    LivePayload payload,
    this.service,
    this.agoraService,
  ) : super(
          const LiveStreamGuestInitialState(),
          service,
          agoraService,
        ) {
    super.payload = payload;

    on<LiveStreamGuestJoinEvent>((_, emit) async {
      if (state is LiveStreamGuestJoiningState) return;
      emit(const LiveStreamGuestJoiningState());
      final token = await service.genereteToken(
        payload.liveID,
        payload.channel,
      );
      if (token.hasError) {
        emit(LiveStreamGuestFailedToJoinState(token.error!.message));
        return;
      }

      super.payload = payload.updateToken(
        token.data['uid'],
        token.data['token'],
      );

      service.join(super.payload!.liveID);
    });

    on<LiveStreamGuestSendCommentEvent>((_, emit) async {
      final comment = controller.text;
      if (comment.isEmpty) return;
      controller.clear();
      final result = await service.sendComment(super.payload!.liveID, comment);
      if (result.hasError) {
        Fluttertoast.showToast(msg: result.error!.message);
        return;
      }
    });

    add(const LiveStreamGuestJoinEvent());
  }

  @override
  void defaultSocketConnection() {
    on<LiveStreamSocketConnectEvent>((_, emit) {
      emit(const LiveStreamGuestInitialState());
      super.connect();
    });
  }

  @override
  void readyState(bool value) {
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
