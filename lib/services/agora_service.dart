import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

Future _requestPermission() async {
  final List<Permission> requiredPermissions = [];

  if (!(await Permission.camera.isGranted)) {
    requiredPermissions.add(Permission.camera);
  }

  if (!(await Permission.microphone.isGranted)) {
    requiredPermissions.add(Permission.microphone);
  }

  if (requiredPermissions.isNotEmpty) {
    await requiredPermissions.request();
    return _requestPermission();
  }
}

class AgoraHandler {
  void Function(RtcConnection connection, int elapsed) onJoinChannelSuccess;
  void Function(RtcConnection connection, int remoteUid, int elapsed)
      onUserJoined;
  void Function(
          RtcConnection connection, int remoteUid, UserOfflineReasonType reason)
      onUserOffline;
  void Function(RtcConnection connection, String token)
      onTokenPrivilegeWillExpire;

  AgoraHandler({
    required this.onJoinChannelSuccess,
    required this.onUserJoined,
    required this.onUserOffline,
    required this.onTokenPrivilegeWillExpire,
  });
}

class LiveUser {
  int localUserId = 0, remoteUserId = 0;
}

abstract class AgoraBaseService {
  late final RtcEngine engine;
  AgoraBaseService._() {
    engine = createAgoraRtcEngine();
  }

  VideoViewController get controller;
// e8c618eaf31d45728bc22f12d62c8c02
  String get appId => "e8c618eaf31d45728bc22f12d62c8c02";

  ChannelProfileType get channelProfile =>
      ChannelProfileType.channelProfileLiveBroadcasting;

  Future<void> init() {
    return engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: channelProfile,
        logConfig: const LogConfig(level: LogLevel.logLevelError),
      ),
    );
  }

  Future<void> ready() async {
    if (_handler == null) throw "Please setup handler";
    engine.registerEventHandler(_handler);
    await engine
        .setChannelProfile(ChannelProfileType.channelProfileLiveBroadcasting);
  }

  Future<void> live(
    String token,
    String channel, [
    // String userAccount = 'host',
    int? uid,
    ChannelMediaOptions? options,
  ]) async {
    await engine.joinChannel(
      token: token,
      channelId: channel,
      uid: uid ?? 0,
      options: options ??
          ChannelMediaOptions(
            token: token,
          ),
    );
  }

  late final RtcEngineEventHandler? _handler;

  int remoteID = 0;

  StreamController<int> isReady = StreamController<int>.broadcast();

  set handler(AgoraHandler h) {
    _handler = RtcEngineEventHandler(
      onError: (code, str) {
        debugPrint("[stream] onError $code [str] $str");
      },
      onJoinChannelSuccess: (conn, uid) {
        print("[stream] onJoinChannelSuccess $uid");

        h.onJoinChannelSuccess(conn, uid);
      },
      onUserJoined: (conn, remoteUid, localId) {
        print("[stream] onUserJoined $remoteUid $localId");
        remoteID = remoteUid;
        isReady.sink.add(remoteUid);
        //TODO
        h.onUserJoined(conn, remoteUid, localId);
      },
      onUserOffline: (conn, uid, reason) {
        print("[stream] onUserOffline $uid $reason");

        //TODO
        h.onUserOffline(conn, uid, reason);
      },
      onTokenPrivilegeWillExpire: (conn, token) {
        print("[stream] onTokenPrivilegeWillExpire $token");

        //TODO
        h.onTokenPrivilegeWillExpire(conn, token);
      },
    );
  }

  Future<void> dispose() async {
    engine.unregisterEventHandler(_handler!);
    await engine.leaveChannel();
    await engine.release();
  }

  void addListner() {
    engine.registerEventHandler(_handler!);
  }
}

class AgoraHostService extends AgoraBaseService {
  AgoraHostService._() : super._();

  static AgoraHostService? _instance;

  static Future<AgoraHostService> instance() async {
    await _requestPermission();
    _instance ??= AgoraHostService._();
    return _instance!;
  }

  @override
  Future<void> ready() async {
    await super.ready();
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.enableAudio();
    await engine.startPreview(
      sourceType: VideoSourceType.videoSourceCameraSecondary,
    );
  }

  @override
  VideoViewController get controller => VideoViewController(
        rtcEngine: engine,
        canvas: const VideoCanvas(
          ///NOTE Local View UID = 0
          uid: 0,
        ),
      );
}

class AgoraGuestService extends AgoraBaseService {
  AgoraGuestService._() : super._();

  @override
  Future<void> ready() async {
    await super.ready();
    await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    await engine.enableVideo();
    await engine.enableAudio();
  }

  // @override
  // set handler(AgoraHandler h) {
  //   _handler = RtcEngineEventHandler(
  //     onError: (code, str) {
  //       debugPrint("[stream] onError $code [str] $str");
  //     },
  //     onJoinChannelSuccess: (conn, uid) {
  //       print("[stream] onJoinChannelSuccess $uid");
  //       liveUser.localUserId = uid;
  //       isReady.sink.add(liveUser);
  //       h.onJoinChannelSuccess(conn, liveUser.localUserId);
  //     },
  //     onUserJoined: (conn, remoteUid, localId) async {
  //       print("[stream] onUserJoined $remoteUid $localId");
  //       liveUser.remoteUserId = localId;
  //       // await engine.setupRemoteVideo(VideoCanvas(uid: remoteUid));
  //       //TODO
  //       h.onUserJoined(conn, remoteUid, localId);
  //     },
  //     onUserOffline: (conn, uid, reason) {
  //       print("[stream] onUserOffline $uid $reason");

  //       //TODO
  //       h.onUserOffline(conn, uid, reason);
  //     },
  //     onTokenPrivilegeWillExpire: (conn, token) {
  //       print("[stream] onTokenPrivilegeWillExpire $token");

  //       //TODO
  //       h.onTokenPrivilegeWillExpire(conn, token);
  //     },
  //   );
  // }

  static AgoraGuestService? _instance;

  static Future<AgoraGuestService> instance() async {
    await _requestPermission();
    _instance ??= AgoraGuestService._();
    return _instance!;
  }

  @override
  VideoViewController get controller => VideoViewController.remote(
        rtcEngine: engine,
        canvas: const VideoCanvas(
          uid: 1860804223,
        ),
        connection: const RtcConnection(
          channelId: "test",
        ),
      );
}
