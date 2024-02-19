import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';

class AgoraGuestService extends AgoraBaseService {
  AgoraGuestService._() : super();

  @override
  String get appId => "e8c618eaf31d45728bc22f12d62c8c02";

  @override
  ClientRoleType get role => ClientRoleType.clientRoleAudience;

  @override
  ChannelProfileType get channelProfile =>
      ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  VideoViewController get videoViewController => throw UnimplementedError();

  @override
  Future<void> dispose() async {
    await onLive.close();
    AgoraGuestService._instance = null;
  }

  static AgoraGuestService? _instance;

  static Future<AgoraGuestService> instance() async {
    _instance ??= AgoraGuestService._();
    return _instance!;
  }
}
