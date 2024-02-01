import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/utils/const/string.dart';

class _PostResult {
  final List<Post> posts;
  final int? nextPage;

  const _PostResult(this.posts, [this.nextPage]);
}

class PostService {
  final Dio _dio;
  final int _limit;
  final AuthService _authService = Locator<AuthService>();

  PostService({
    int page = 1,
    int limit = 20,
  })  : _page = page,
        _limit = limit,
        _dio = Locator<Dio>();

  int _page;
  bool _hasNextPage = true;

  Future<Result<_PostResult>> _fetchPost(int page) async {
    final user = _authService.currentUser;
    if (user == null) {
      return Result(error: GeneralError("Unauthorized"));
    }
    try {
      final String? token = await user.getIdToken();
      if (token == null) {
        return Result(error: GeneralError("Unauthorized"));
      }
      final response = await _dio.get("$POST_BASE_URL?page=$page&limit=$_limit",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      final body = response.data;
      final posts = (body['data'] as List).map(Post.fromJson).toList();
      if (body['next_page'] != null) {
        return Result(data: _PostResult(posts, page + 1));
      }
      return Result(
        data: _PostResult(posts),
      );
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
      return Result(
        error: GeneralError(e.toString()),
      );
    }
  }

  Future<Result<List<Post>>> getAllPosts() async {
    if (!_hasNextPage) {
      return Result(
        data: [],
      );
    }
    final result = await _fetchPost(_page);

    if (result.error != null) {
      return Result(error: result.error);
    }

    if (result.data.nextPage != null) {
      _page = result.data.nextPage!;
    } else {
      _hasNextPage = false;
    }

    return Result(data: result.data.posts);
  }

  Future<Result<List<Post>>> refresh() async {
    final List<Post> posts = [];

    int? page = 1;

    while (page != null) {
      final result = await _fetchPost(page);
      if (result.error != null) {
        return Result(error: result.error);
      }
      final i = result.data.nextPage;
      if (i != null && _page > i) {
        page = i;
      } else {
        page = null;
      }
      posts.addAll(result.data.posts);
    }

    return Result(data: posts);
  }
}
