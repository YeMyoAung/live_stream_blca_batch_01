import 'dart:async';

import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/utils/const/string.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

const Duration _interval = Duration(milliseconds: 500);

class SocketUtilsService {
  String get usage => "live";

  int? socketUserID;

  // static
  static final Map<String, socket_io.Socket?> _socket = {};

  set socket(socket_io.Socket? socket) {
    _socket[usage] ??= socket;
  }

  socket_io.Socket? get socket {
    final s = _socket[usage];
    return s;
  }

  static final Logger logger = Logger();

  final AuthService authService = locator<AuthService>();

  final List<String> _listeners = [];

  int get listenerCount => _listeners.length;

  Future<T> _runner<T>(Future<T> Function() callback) {
    logger.w("SocketRetry: $_failCount");
    return Future.delayed(_interval, callback);
  }

  int _failCount = 0;

  Future<T> _validate<T>(
    Future<T> Function() run,
    Future<T> Function() fail,
  ) {
    if (_failCount > 3) {
      // _interval += _interval;
      _failCount = 0;
      return _runner(fail);
    }
    if (socket == null) {
      _failCount++;
      return _runner(fail);
    }
    if (socket?.connected != true) {
      _failCount++;
      return _runner(fail);
    }
    _failCount = 0;
    // _interval = 500;
    return run();
  }

  ///Listen
  void listen(String event, Function(dynamic) callback) {
    _validate(
      () async {
        ///Success
        _listeners.add("${usage}_$event");
        socket?.on(event, (v) {
          logger.i("SocketEvent $event: $v");
          callback(v);
        });
      },
      () async => listen(event, callback),
    );
  }

  ///emit
  void emit(String event, dynamic data) {
    _validate(
      () async {
        Future.delayed(
          const Duration(seconds: 2),
          () {
            logger.i("SocketEmit $event: $data");
            socket?.emit(event, data);
          },
        );
      },
      () async => emit(event, data),
    );
  }

  Future<void> init() async {
    if (socket != null) {
      close();
    }
    final token = await authService.currentUser?.getIdToken();

    socket = socket_io.io(
      baseUrl,
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );
    _defaultEvents();
  }

  Future<bool> isSocketReadyFn() async {
    while (socket?.connected != true) {
      await Future.delayed(const Duration(seconds: 1));
      if (socket?.connected == true) {
        break;
      }
    }
    return Future.value(true);
  }

  Future<bool> get isSocketReady {
    return _validate(
      () async {
        return true;
      },
      () {
        if (socket?.connected != true) {
          socket?.disconnect();
          socket?.connect();
        }
        return isSocketReady;
      },
    );
  }

  void _defaultEvents() {
    socket?.onConnectTimeout((data) {
      logger.e("ConnectTimeout $data");
    });
    socket?.onError((data) {
      logger.e("onError $data");
    });
    socket?.onConnectError((data) {
      logger.e("onConnectError $data");
    });
    socket?.onConnect((data) {
      logger.i("Connected");
    });
    socket?.onConnecting((data) {
      logger.i("Connecting");
    });
    socket?.on("connection", (data) {
      ///User Account Info
      socketUserID = int.tryParse(data['id'].toString());
      logger.i("Connect Msg : $data");
    });
  }

  void close() {
    socket?.dispose();
    socket = null;
  }
}
