import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/routes/route_name.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_comment.dart';
import 'package:live_stream/services/ui_live_stream/utils/socket_util_service.dart';
import 'package:live_stream/utils/const/string.dart';
import 'package:live_stream/utils/dialog/error_dialog.dart';
import 'package:starlight_utils/starlight_utils.dart';

abstract class LiveStreamBaseService extends SocketUtilsService {
  final Dio dio = locator<Dio>();

  // User Join / Host Status
  final StreamController<bool?> _stream = StreamController.broadcast();

  final StreamController _userJoin = StreamController.broadcast();

  final StreamController<List<UiLiveStreamComment>> _comments =
      StreamController.broadcast();

  final StreamController<int> _viewCount = StreamController.broadcast();

  Stream<bool?> get streamStatus {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setLiveStreamStatus(_streamStatus),
    );
    return _stream.stream;
  }

  Stream<int> get viewCount {
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setViewerCount(_lastCount),
    );
    return _viewCount.stream;
  }

  Stream<List<UiLiveStreamComment>> get comments {
    Future.delayed(
      const Duration(milliseconds: 200),
      () => setComments(_userComments),
    );

    return _comments.stream;
  }

  Stream get userJoin => _userJoin.stream;
  bool? _streamStatus;

  void setLiveStreamStatus(bool? status) {
    _streamStatus = status;
    _stream.sink.add(_streamStatus);
  }

  int _lastCount = 0;

  void setViewerCount(int count) {
    _lastCount = count;
    _viewCount.sink.add(_lastCount);
  }

  final List<UiLiveStreamComment> _userComments = [];

  void setComments(dynamic comment) {
    if (comment is List<UiLiveStreamComment>) {
      _comments.sink.add(_userComments);
      return;
    }
    _userComments.add(UiLiveStreamComment.fromJson(comment));
    _userComments.sort((p, c) => c.createdAt.compareTo(p.createdAt));
    _comments.sink.add(_userComments);
  }

  void consumeLiveEvent() {
    listen("viewCount", (p0) {
      setViewerCount(int.parse(p0.toString()));
    });
    listen("liveComment", setComments);
    listen("end", (p0) async {
      await showErrorDialog("End", "Live is over");
      StarlightUtils.pushReplacementNamed(RouteNames.home);
    });
  }

  Future<Result> sendComment(int liveID, String comment) async {
    try {
      final String? token = await authService.currentUser?.getIdToken();
      if (token == null) {
        return const Result(error: GeneralError("Unauthorized"));
      }
      await dio.post(
        "$postBaseUrl/$liveID/comment",
        data: FormData.fromMap({
          'comment': comment,
        }),
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      return const Result(data: null);
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(
          e.response?.data?['error']?.toString() ??
              e.message ??
              e.error?.toString() ??
              "Unknown Error",
          e.stackTrace,
        ),
      );
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  void dispose() {
    _stream.close();
    _viewCount.close();
    _comments.close();
    _userJoin.close();
    close();
  }
}
