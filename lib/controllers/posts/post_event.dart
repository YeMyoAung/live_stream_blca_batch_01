import '../../models/post.dart';

abstract class PostBaseEvent {
  const PostBaseEvent();
}

class PostNextPageEvent extends PostBaseEvent {
  const PostNextPageEvent();
}

class NewPostEvent extends PostBaseEvent {
  final List<Post> newPosts;

  const NewPostEvent(this.newPosts);
}

class SearchNewPostEvent extends PostBaseEvent {
  const SearchNewPostEvent();
}

class LikePostEvent extends PostBaseEvent {
  final int id;

  const LikePostEvent(this.id);
}

class PostRefreshEvent extends PostBaseEvent {
  const PostRefreshEvent();
}

// class PostRefreshEvent extends PostBaseEvent {
//   const PostRefreshEvent();
// }
