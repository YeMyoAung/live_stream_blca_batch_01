import 'package:equatable/equatable.dart';
import 'package:live_stream/models/post.dart';

///GET
abstract class PostBaseState extends Equatable {
  final List<Post> posts;

  const PostBaseState(this.posts);

  @override
  List<Object?> get props => posts;
}

class PostInitialState extends PostBaseState {
  const PostInitialState() : super(const []);
}

class PostLoadingState extends PostBaseState {
  const PostLoadingState(super.posts);
}

class PostSoftLoadingState extends PostBaseState {
  const PostSoftLoadingState(super.posts);
}

class PostSuccessState extends PostBaseState {
  final DateTime _createdAt = DateTime.now();

  PostSuccessState(super.posts);

  @override
  // TODO: implement props
  List<Object?> get props => [super.props, _createdAt];
}

class PostErrorState extends PostBaseState {
  final String? message;

  const PostErrorState(super.posts, this.message);

  @override
  List<Object?> get props => [...super.props, message];
}
