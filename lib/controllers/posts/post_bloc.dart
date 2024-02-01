import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_stream/controllers/posts/post_event.dart';
import 'package:live_stream/controllers/posts/post_state.dart';
import 'package:live_stream/core/models/result.dart';
import 'package:live_stream/locator.dart';
import 'package:live_stream/models/post.dart';
import 'package:live_stream/services/post/post_service.dart';
import 'package:logger/logger.dart';

class PostBloc extends Bloc<PostBaseEvent, PostBaseState> {
  final PostService _postService = Locator<PostService>();

  static final Logger _logger = Logger();

  PostBloc() : super(const PostInitialState()) {
    on<PostNextPageEvent>((_, emit) async {
      if (state is PostLoadingState) return;
      final copied = state.posts.toList();
      if (copied.isEmpty) {
        emit(PostLoadingState(copied));
      } else {
        emit(PostSoftLoadingState(copied));
      }
      final Result<List<Post>> result = await _postService.getAllPosts();
      if (result.hasError) {
        _logger.w(result.error?.message);
        _logger.e(result.error?.stackTrace);
        emit(PostErrorState(copied, result.error?.message));
        return;
      }
      copied.addAll(result.data);
      emit(PostSuccesState(copied));
    });

    add(const PostNextPageEvent());
  }
}
