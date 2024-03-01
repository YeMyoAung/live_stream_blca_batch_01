import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/services/ui_live_stream/base/ui_live_stream_base_service.dart';
import 'package:live_stream/utils/const/string.dart';

class LiveStreamGuestService extends LiveStreamBaseService {
  LiveStreamGuestService() {
    init();
    listen("joinEvent", (p0) {
      final isJoined = int.parse(p0.toString()) == 200;
      setLiveStreamStatus(isJoined);
      if (isJoined) {
        consumeLiveEvent();
      }
    });
  }

  Future<Result<dynamic>> generateToken(int liveID, String channel) async {
    try {
      final token = await authService.currentUser?.getIdToken();
      if (token == null) {
        return const Result(error: GeneralError("Unauthorized"));
      }
      final response = await dio.post(
        '$postBaseUrl/$liveID/join',
        options: Options(headers: {
          "Authorization": 'Bearer $token',
        }),
        data: FormData.fromMap({
          'channel': channel,
        }),
      );
      // if ((response.statusCode ?? 500) > 300) {
      //   return Result(
      //     error: GeneralError(
      //       response.data?.toString() ??
      //           response.statusMessage ??
      //           "Unknown Error Occour",
      //     ),
      //   );
      // }
      return Result(data: response.data);
    } on SocketException catch (e) {
      return Result(error: GeneralError(e.message));
    } on DioException catch (e) {
      return Result(
        error: GeneralError(
          e.response?.data['error']?.toString() ??
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

  void join(int liveID) {
    emit("join", "$liveID");
  }
}
