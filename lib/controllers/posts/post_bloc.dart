import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:logger/logger.dart';

import '../../locator.dart';

abstract class PostBaseBloc extends Bloc<PostBaseEvent, PostBaseState> {
  final ApiBaseService<Post> service;

  static final Logger _logger = Logger();

  PostBaseBloc(this.service) : super(const PostInitialState()) {
    service.postListener((post) {
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
    });

    scrollController.addListener(() {
      final max = scrollController.position.maxScrollExtent;
      final current = scrollController.position.pixels;
      if ((max / current) > 0.5) {
        add(const PostNextPageEvent());
      }
    });

    on<NewPostEvent>((event, emit) {
      emit(PostSuccessState(event.newPosts));
    });

    on<PostNextPageEvent>((_, emit) async {
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
    });

    add(const PostNextPageEvent());
  }

  final ScrollController scrollController = ScrollController();

  @override
  Future<void> close() {
    scrollController.dispose();
    service.destory();
    return super.close();
  }
}

class PostBloc extends PostBaseBloc {
  PostBloc() : super(Locator<PostService>());
}

class MyPostBloc extends PostBaseBloc {
  MyPostBloc() : super(Locator<MyPostService>());
}
