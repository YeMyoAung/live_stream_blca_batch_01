import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

Future requestPermission() async {
  final List<Permission> requiredPermissions = [];

  if (!(await Permission.camera.isGranted)) {
    requiredPermissions.add(Permission.camera);
  }

  if (!(await Permission.microphone.isGranted)) {
    requiredPermissions.add(Permission.microphone);
  }

  if (requiredPermissions.isNotEmpty) {
    await requiredPermissions.request();
    return requestPermission();
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
  void Function(RtcConnection, int) onRejoinChannelSuccess;
  void Function(RtcConnection, RtcStats) onLeaveChannel;
  void Function(ErrorCodeType, String) onError;

  AgoraHandler({
    required this.onJoinChannelSuccess,
    required this.onUserJoined,
    required this.onUserOffline,
    required this.onTokenPrivilegeWillExpire,
    required this.onRejoinChannelSuccess,
    required this.onLeaveChannel,
    required this.onError,
  });

  factory AgoraHandler.fast() {
    return AgoraHandler(
      onJoinChannelSuccess: (_, __) {},
      onUserJoined: (_, __, ___) {},
      onUserOffline: (_, __, ___) {},
      onTokenPrivilegeWillExpire: (_, __) {},
      onRejoinChannelSuccess: (_, __) {},
      onLeaveChannel: (_, __) {},
      onError: (_, __) {},
    );
  }
}

const int _waiting = 0;

class AgoraLiveConnection {
  final RtcConnection connection;
  final int remoteId;

  const AgoraLiveConnection({required this.connection, required this.remoteId});
}

abstract class AgoraBaseService {
  final Logger _logger;

  late final RtcEngine engine;
  AgoraBaseService() : _logger = Logger() {
    engine = createAgoraRtcEngine();
  }

  String get appId;

  ClientRoleType get role;

  ChannelProfileType get channelProfile;

  VideoViewController get videoViewController;

  int _state = _waiting;

  int get status => _state;

  /// assert(0)
  Future<void> init() async {
    assert(status == 0);
    await requestPermission();
    await engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: channelProfile,
        logConfig: const LogConfig(
          level: LogLevel.logLevelFatal,
        ),
      ),
    );
    _state = 1;
  }

  late final RtcEngineEventHandler? _handler;

  ///  assert(1)
  Future<void> ready() async {
    assert(status == 1 && _handler != null);
    engine.registerEventHandler(_handler!);
    await engine.setClientRole(role: role);
    await engine.enableVideo();
    await engine.enableAudio();
    _state = 2;
  }

  /// assert(2)
  /// TODO api integrate
  Future<void> live(
    String token,
    String channel, [
    int? uid,
    ChannelMediaOptions? options,
  ]) async {
    assert(_state == 2);
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

  /// assert(1)
  Future<void> close() async {
    assert(status == 1);
    engine.unregisterEventHandler(_handler!);
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> dispose();

  AgoraLiveConnection? connection;

  StreamController<AgoraLiveConnection?> onLive =
      StreamController<AgoraLiveConnection?>.broadcast();

  /// TODO Api Integrate
  set handler(AgoraHandler h) {
    _handler = RtcEngineEventHandler(
      //Live Start
      onUserJoined: (conn, remoteUid, _) {
        _logger.i("[stream:onUserJoined] [conn] $conn\n[remoteUid] $remoteUid");
        connection = AgoraLiveConnection(connection: conn, remoteId: remoteUid);
        onLive.sink.add(connection);
        h.onUserJoined(conn, remoteUid, _);
      },
      //Live Stop
      //TODO: Sec 30
      onUserOffline: (conn, uid, reason) {
        _logger.d(
            "[stream:onUserOffline] [conn] $conn\n[uid] $uid\n[reason] $reason");
        h.onUserOffline(conn, uid, reason);
      },
      //Live Stop
      ///TODO: Sec 30
      onTokenPrivilegeWillExpire: (conn, token) {
        _logger.d(
            "[stream:onTokenPrivilegeWillExpire] [conn] $conn\n[token] $token");
        h.onTokenPrivilegeWillExpire(conn, token);
      },

      ///View Count ++
      onJoinChannelSuccess: (conn, uid) {
        _logger.i("[stream:onJoinChannelSuccess] [conn] $conn\n[uid] $uid");
        h.onJoinChannelSuccess(conn, uid);
      },

      ///View Count ++
      onRejoinChannelSuccess: (conn, _) {
        _logger.i("[stream:onRejoinChannelSuccess] [conn] $conn");
        h.onRejoinChannelSuccess(conn, _);
      },

      ///View Count --
      onLeaveChannel: (conn, stats) {
        _logger.i("[stream:onLeaveChannel] [conn] $conn\n[stats] $status");
        h.onLeaveChannel(conn, stats);
      },

      ///Ui
      onError: (code, str) {
        _logger.e("[stream:onError] [code] $code\n[str] $str");
        h.onError(code, str);
      },
    );
  }
}

///
///  Backend (Go)
///
///  Module (Gin) > AA
///
///  Server Logic
///  Handler
///

///
///  Frontend (Flutter)
///
///  StateManagement (Bloc)
///
///  App Logic
///  View
///
