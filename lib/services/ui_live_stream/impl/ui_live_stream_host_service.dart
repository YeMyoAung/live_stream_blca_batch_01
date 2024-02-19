import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/services/ui_live_stream/base/ui_live_stream_base_service.dart';
import 'package:live_stream/services/ui_live_stream/model/ui_live_payload.dart';
import 'package:live_stream/utils/const/string.dart';

class LiveStreamHostService extends LiveStreamBaseService {
  LiveStreamHostService() {
    init();
    listen("hostEvent", (p0) {
      final isStarted = int.parse(p0.toString()) == 200;
      setLiveStreamStatus(isStarted);
      if (isStarted) {
        comsumeLiveEvent();
      }
    });
  }

  Future<Result<LivePayload>> postCreate(String content) async {
    try {
      final String? token = await authService.currentUser?.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      final response = await dio.post(
        POST_BASE_URL,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
        data: FormData.fromMap({
          "content": content,
        }),
      );
      return Result(data: LivePayload.fromJson(response.data));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(
          e.response?.data.toString() ?? e.message ?? e.toString(),
          e.stackTrace,
        ),
      );
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }

  void startLiveStream(int liveID) {
    emit("host", "$liveID");
  }

  Future<Result<void>> stopLiveStream(int liveID) async {
    try {
      final String? token = await authService.currentUser?.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      await dio.post('$POST_BASE_URL/$liveID/end',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));
      return const Result<void>();
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(
          e.response?.data?['error']?.toString() ??
              e.message ??
              e.error?.toString() ??
              "Unknown Error",
        ),
      );
    } catch (e) {
      return Result(error: GeneralError(e.toString()));
    }
  }
}
