import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/ui_live_stream/utils/socket_util_service.dart';
import 'package:live_stream/utils/const/string.dart';

class _PostResult<T> {
  final List<T> posts;
  final int? nextPage;

  const _PostResult(this.posts, [this.nextPage]);
}

abstract class ApiBaseService<T> extends SocketUtilsService {
  String get url;

  T parse(dynamic data);

  @override
  String get usage => throw UnimplementedError("Must be implemented");

  final Dio _dio;
  final int _limit;
  final AuthService _authService = Locator<AuthService>();

  bool postPredicate(int postOwnerID, int? currentUserID);

  void postListener(void Function(Post post) callback) {
    listen("post", (p0) {
      try {
        final post = Post.fromJson(p0);
        if (postPredicate(post.userId, socketUserID)) callback(post);
      } catch (e) {
        ///pass
      }
    });
  }

  ApiBaseService({
    int page = 1,
    int limit = 20,
  })  : _page = page,
        _limit = limit,
        _dio = Locator<Dio>() {
    init();
  }

  int _page;
  bool _hasNextPage = true;

  Future<Result<_PostResult<T>>> _fetchPost(int page) async {
    final user = _authService.currentUser;
    if (user == null) {
      return const Result(error: GeneralError("Unauthorized"));
    }
    try {
      final String? token = await user.getIdToken();
      if (token == null) {
        return const Result(error: GeneralError("Unauthorized"));
      }
      final response = await _dio.get("$url?page=$page&limit=$_limit",
          options: Options(headers: {
            "Authorization": "Bearer $token",
          }));
      final body = response.data;
      final posts = (body['data'] as List).map(parse).toList();
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

  int tryCount = 0;

  Future<Result<List<T>>> getAllPosts() async {
    if (!_hasNextPage && tryCount < 2) {
      tryCount += 1;
      return const Result(
        error: GeneralError("No more posts"),
      );
    }
    tryCount = 0;
    final result = await _fetchPost(_page);

    if (result.hasError) {
      return Result(error: result.error);
    }

    if (result.data.nextPage != null) {
      _page = result.data.nextPage!;
    } else {
      _hasNextPage = false;
    }

    return Result(
      data: result.data.posts,
    );
  }

  Future<Result<List<T>>> refresh() async {
    final List<T> posts = [];

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

    return Result(
      data: posts,
    );
  }
}

class PostService extends ApiBaseService<Post> {
  @override
  String get usage => 'posts';

  @override
  String get url => POST_BASE_URL;

  @override
  parse(data) {
    return Post.fromJson(data);
  }

  @override
  bool postPredicate(int postOwnerID, int? currentUserID) {
    return postOwnerID != currentUserID;
  }
}

class MyPostService extends ApiBaseService<Post> {
  @override
  String get usage => 'my_posts';

  @override
  String get url => MY_POST_BASE_URL;

  @override
  parse(data) {
    return Post.fromJson(data);
  }

  @override
  bool postPredicate(int postOwnerID, int? currentUserID) {
    return postOwnerID == currentUserID;
  }
}
