import 'dart:io';

import 'package:dio/dio.dart';
import 'package:live_stream/core/errors/error.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/auth/auth.dart';
import 'package:live_stream/services/ui_live_stream/utils/socket_util_service.dart';
import 'package:live_stream/utils/const/string.dart';
import 'package:logger/logger.dart';

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
  final AuthService _authService;
  final Logger logger;

  int _latestPage;

  ApiBaseService({
    int page = 1,
    int limit = 20,
  })  : _latestPage = page,
        _limit = limit,
        _dio = locator<Dio>(),
        _authService = locator<AuthService>(),
        logger = Logger() {
    init();
  }

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

  void likeListener(void Function(int postID) callback) {
    listen("like", (p0) {
      if (p0['likeUserID'] == socketUserID) {
        callback(p0['post']['id']);
      }
    });
  }

  Future<Result<_PostResult<T>>> _fetchPost(int page) async {
    assert(url.startsWith("http"));

    final user = _authService.currentUser;
    if (user == null) {
      return const Result(error: GeneralError("Unauthorized"));
    }
    try {
      final String? token = await user.getIdToken();
      if (token == null) {
        return const Result(error: GeneralError("Unauthorized"));
      }

      final uri = Uri.parse(url);

      final newUri = uri.replace(queryParameters: {
        ...uri.queryParameters,
        "page": page.toString(),
        "limit": _limit.toString(),
      });

      final response = await _dio.get(
        newUri.toString(),
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      final body = response.data;
      logger.i(body);
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

  bool _hasNextPage = true;
  int tryCount = 0;

  Future<Result<List<T>>> getAllPosts() async {
    if (!_hasNextPage && tryCount < 2) {
      tryCount += 1;
      return const Result(
        error: GeneralError("No more posts"),
      );
    }
    tryCount = 0;
    final result = await _fetchPost(_latestPage);

    if (result.hasError) {
      return Result(error: result.error);
    }

    if (result.data.nextPage != null) {
      _latestPage = result.data.nextPage!;
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

    // latest page 3
    // page 1 =>  next page = refresh(),stop
    // page 2 =>
    // page 3 => next page

    while (page != null) {
      final result = await _fetchPost(page);
      if (result.error != null) {
        return Result(
          error: result.error,
          data: [],
        );
      }
      final nextPage = result.data.nextPage;
      if (nextPage != null && _latestPage > nextPage) {
        page = nextPage;
      } else {
        page = null;
      }
      posts.addAll(result.data.posts);
    }

    return Result(
      data: posts,
    );
  }

  Future<void> like(int id) async {
    final uri = Uri.parse(url);
    final likeUri = uri.replace(
      pathSegments: [
        ...uri.pathSegments,
        id.toString(),
        "like",
      ],
      query: "",
    );
    try {
      await _dio.post(
        likeUri.toString(),
        options: Options(
          headers: {
            "Authorization":
                "Bearer ${await _authService.currentUser?.getIdToken()}",
          },
        ),
      );
    } catch (e) {
      ///
    }
  }
}

class PostService extends ApiBaseService<Post> {
  @override
  String get usage => 'posts';

  @override
  String get url => postBaseUrl;

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
  String get url => myPostBaseUrl;

  @override
  parse(data) {
    return Post.fromJson(data);
  }

  @override
  bool postPredicate(int postOwnerID, int? currentUserID) {
    return postOwnerID == currentUserID;
  }
}

class SearchPostService extends ApiBaseService<Post> {
  @override
  String get usage => 'search_posts';

  String _search = "";

  set search(String value) {
    _search = value;
    _latestPage = 1;
    _hasNextPage = true;
    tryCount = 0;
  }

  @override
  String get url => "$postBaseUrl?search=$_search";

  @override
  parse(data) {
    return Post.fromJson(data);
  }

  @override
  bool postPredicate(int postOwnerID, int? currentUserID) {
    return postOwnerID == currentUserID;
  }
}
