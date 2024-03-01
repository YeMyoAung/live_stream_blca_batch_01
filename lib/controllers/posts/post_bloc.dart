import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:live_stream/utils/const/string.dart';
import 'package:logger/logger.dart';

import '../../locator.dart';

abstract class PostBaseBloc extends Bloc<PostBaseEvent, PostBaseState> {
  bool _isReady = true;
  final ApiBaseService<Post> service;

  static final Logger _logger = Logger();

  PostBaseBloc(this.service) : super(const PostInitialState()) {
    service.postListener(_postListener);

    service.likeListener(_likeListener);

    scrollController.addListener(_scrollListener);

    on<LikePostEvent>(_likeEventHandler);

    on<NewPostEvent>(_newPostEventHandler);

    on<PostRefreshEvent>(_refreshPostEventHandler);

    on<PostNextPageEvent>(_postNextPageHandler);

    add(const PostNextPageEvent());
  }

  void _postNextPageHandler(PostNextPageEvent _, Emitter emit) async {
    if (!_isReady) return;
    if (state is PostLoadingState || state is PostSoftLoadingState) return;
    final copied = state.posts.toList();
    if (copied.isEmpty) {
      emit(PostLoadingState(copied));
    } else {
      emit(PostSoftLoadingState(copied));
    }
    final Result<List<Post>> result = await service.getAllPosts();

    if (result.hasError) {
      _logger.w(result.error?.message);
      _logger.e(result.error?.stackTrace);
      emit(PostErrorState(copied, result.error?.message));
      return;
    }

    copied.addAll(result.data);
    emit(PostSuccessState(copied));
  }

  void _refreshPostEventHandler(PostRefreshEvent _, Emitter emit) async {
    if (state.posts.isEmpty) {
      emit(PostLoadingState(state.posts));
    }
    final Result<List<Post>> result = await service.refresh();
    emit(PostSuccessState(result.data));
  }

  void _newPostEventHandler(NewPostEvent event, Emitter emit) {
    emit(PostSuccessState(event.newPosts));
  }

  void _likeEventHandler(LikePostEvent event, _) async {
    await service.like(event.id);
  }

  void _postListener(Post post) {
    final copied = state.posts.toList();
    final index = copied.indexOf(post);
    if (index == -1) {
      ///new post
      copied.add(post);
    } else {
      copied[index] = post;
    }
    // copied.insert(0, post);
    add(NewPostEvent(copied));
    // emit(PostSuccessState(copied));
  }

  void _likeListener(int postID) {
    final copied = state.posts.toList();
    final index = copied.indexWhere((element) => element.id == postID);
    if (index != -1) {
      final updated = copied[index].likeToggle();
      copied[index] = updated;
      add(NewPostEvent(copied));
    }
  }

  void _scrollListener() {
    final max = scrollController.position.maxScrollExtent;
    final current = scrollController.position.pixels;
    if ((max / current) > 0.5) {
      add(const PostNextPageEvent());
    }
  }

  final ScrollController scrollController = ScrollController();

  @override
  Future<void> close() {
    scrollController.dispose();
    service.close();
    return super.close();
  }
}

class PostBloc extends PostBaseBloc {
  PostBloc() : super(locator<PostService>());
}

class MyPostBloc extends PostBaseBloc {
  MyPostBloc() : super(locator<MyPostService>());
}

class SearchBloc extends PostBaseBloc {
  final TextEditingController queryC = TextEditingController();
  final FocusNode queryF = FocusNode();

  String _recent = "";

  bool _isSearch = false;

  void search() {
    _isSearch = queryC.text.isNotEmpty;
    queryF.unfocus();
  }

  void clear() {
    _isSearch = false;
    queryF.unfocus();
  }

  void init() {
    _recent = "";
    _isSearch = false;
    _isReady = false;
    queryC.clear();
    queryF.requestFocus();
    add(const SearchNewPostEvent());
  }

  SearchBloc(SearchPostService service) : super(service) {
    _isReady = false;
    on<SearchNewPostEvent>((event, emit) {
      emit(PostSuccessState(const []));
      add(const PostNextPageEvent());
    });

    ///Key board
    queryF.onKey = (f, event) {
      _isSearch = queryC.text.isNotEmpty && entryKey == event.logicalKey.keyId;

      return KeyEventResult.ignored;
    };

    ///FocusNode Listen
    ///TextEditingController
    queryF.addListener(() {
      if (queryF.hasPrimaryFocus) {
        _isSearch = false;
        _recent = queryC.text;
        queryC.clear();
      } else {
        _isReady = _isSearch;
        if (!_isSearch) {
          queryC.text = _recent;
          return;
        }
        service.search = queryC.text;
        add(const SearchNewPostEvent());
      }
    });
  }

  @override
  Future<void> close() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    queryC.dispose();
    queryF.dispose();
    return super.close();
  }
}
