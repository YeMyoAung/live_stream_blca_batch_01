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

// class PostRefreshEvent extends PostBaseEvent {
//   const PostRefreshEvent();
// }
