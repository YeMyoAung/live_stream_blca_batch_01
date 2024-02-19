import 'dart:async';

import 'package:live_stream/locator.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/utils/const/string.dart';
import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketUtilsService {
  static IO.Socket? _socket;

  set socket(IO.Socket? socket) {
    _socket ??= socket;
  }

  static final Logger _logger = Logger();

  final AuthService authService = Locator<AuthService>();

  final List<String> _listeners = [];

  int get listenerCount => _listeners.length;

  int _interval = 500;

  Future<T> _runner<T>(Future<T> Function() callback) {
    _logger.w("SocketRetry: $_failCount");
    return Future.delayed(Duration(milliseconds: _interval), callback);
  }

  int _failCount = 0;

  Future<T> _validate<T>(
    Future<T> Function() run,
    Future<T> Function() fail,
  ) {
    if (_failCount > 3) {
      _interval += _interval;
      _failCount = 0;
      return _runner(fail);
    }
    if (_socket == null) {
      _failCount++;
      return _runner(fail);
    }
    if (_socket?.connected != true) {
      _failCount++;
      return _runner(fail);
    }
    _failCount = 0;
    _interval = 500;
    return run();
  }

  ///Listen
  void listen(String event, Function(dynamic) callback) {
    // if (_failCount > 3) {
    //   _interval += _interval;
    //   _failCount = 0;
    //   return _runner(() => listen(event, callback));
    // }
    // if (_socket == null) {
    //   _failCount++;
    //   return _runner(() => listen(event, callback));
    // }
    // if (_socket?.connected != true) {
    //   _failCount++;
    //   return _runner(() => listen(event, callback));
    // }
    // if (_listeners.contains(event)) return;
    // _failCount = 0;
    // _interval = 1000;
    // _listeners.add(event);
    // _socket?.on(event, (v) {
    //   _logger.i("SocketEvent $event: $v");
    //   callback(v);
    // });

    _validate(() async {
      ///Success
      _listeners.add(event);
      _socket?.on(event, (v) {
        _logger.i("SocketEvent $event: $v");
        callback(v);
      });
    }, () async => listen(event, callback));
  }

  ///emit
  void emit(String event, dynamic data) {
    // if (_failCount > 3) {
    //   _failCount = 0;
    //   return;
    // }
    // if (_socket == null) {
    //   _failCount++;
    //   return _runner(() => emit(event, data));
    // }
    // if (_socket?.connected != true) {
    //   _failCount++;
    //   return _runner(() => emit(event, data));
    // }
    // _failCount = 0;
    // Future.delayed(
    //   const Duration(seconds: 2),
    //   () {
    //     _logger.i("SocketEmit $event: $data");
    //     _socket?.emit(event, data);
    //   },
    // );
    _validate(() async {
      Future.delayed(
        const Duration(seconds: 2),
        () {
          _logger.i("SocketEmit $event: $data");
          _socket?.emit(event, data);
        },
      );
    }, () async => emit(event, data));
  }

  Future<void> init() async {
    if (_socket != null) {
      destory();
    }
    final token = await authService.currentUser?.getIdToken();

    socket = IO.io(
      BASE_URL,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );
    _defaultEvents();
  }

  Future<bool> isSocketReadyFn() async {
    while (_socket?.connected != true) {
      await Future.delayed(const Duration(seconds: 1));
      if (_socket?.connected == true) {
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
        if (_socket?.connected != true) {
          _socket?.disconnect();
          _socket?.connect();
        }
        return isSocketReady;
      },
    );
  }

  void _defaultEvents() {
    _socket?.onConnectTimeout((data) {
      _logger.e("ConnectTimeout $data");
    });
    _socket?.onError((data) {
      _logger.e("onErrr $data");
    });
    _socket?.onConnectError((data) {
      _logger.e("onConnectError $data");
    });
    _socket?.onConnect((data) {
      _logger.i("Connected");
    });
    _socket?.onConnecting((data) {
      _logger.i("Connecting");
    });
    _socket?.on("connection", (data) {
      _logger.i("Connect Msg : $data");
    });
  }

  void destory() {
    _socket?.dispose();
    socket = null;
  }
}
