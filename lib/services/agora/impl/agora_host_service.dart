import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:live_stream/services/agora/base/agora_base_service.dart';

class AgoraHostService extends AgoraBaseService {
  AgoraHostService._() : super();

  @override
  String get appId => "e8c618eaf31d45728bc22f12d62c8c02";

  @override
  ClientRoleType get role => ClientRoleType.clientRoleBroadcaster;

  @override
  ChannelProfileType get channelProfile =>
      ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  VideoViewController get videoViewController => VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(
          ///NOTE Local View UID = 0
          uid: 0,
        ),
      );

  @override
  Future<void> ready() async {
    await super.ready();
    // Camera Mode
    await engine.startPreview(
      sourceType: VideoSourceType.videoSourceCameraSecondary,
    );
  }

  @override
  Future<void> dispose() async {
    await onLive.close();
    AgoraHostService._instance = null;
  }

  static AgoraHostService? _instance;

  ///1. requestPermission > init
  ///2. Generic
  static Future<AgoraHostService> instance() async {
    _instance ??= AgoraHostService._();
    return _instance!;
  }
}
