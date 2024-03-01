import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id, userId, liveId, likeCount, commentCount, viewCount;
  final String content, channel, status, displayName, profilePhoto;
  final String? token;
  final bool isLike;
  final DateTime createdAt;

  const Post({
    required this.id,
    required this.userId,
    required this.liveId,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
    required this.content,
    required this.channel,
    required this.token,
    required this.status,
    required this.displayName,
    required this.profilePhoto,
    required this.createdAt,
    required this.isLike,
  });

  Post likeToggle() {
    return Post(
      id: id,
      userId: userId,
      liveId: liveId,
      likeCount: likeCount,
      commentCount: commentCount,
      viewCount: viewCount,
      content: content,
      channel: channel,
      token: token,
      status: status,
      displayName: displayName,
      profilePhoto: profilePhoto,
      createdAt: createdAt,
      isLike: !isLike,
    );
  }

  factory Post.fromJson(dynamic data) {
    final live = data['live'];
    final user = data['user'];
    return Post(
      id: int.parse(data['id'].toString()),
      userId: int.parse(data['UserID'].toString()),
      liveId: int.parse(live['id'].toString()),
      likeCount: int.parse(live['like_count'].toString()),
      commentCount: int.parse(live['comment_count'].toString()),
      viewCount: int.parse(live['viewer_count'].toString()),
      content: data['content'],
      channel: live['channel'],
      token: live['token'],
      status: live['Status'],
      displayName: user['DisplayName'],
      profilePhoto: user['ProfilePhoto'],
      createdAt: DateTime.parse(data['created_at']),
      isLike: data['is_liked'] == true,
    );
  }

  @override
  List<Object?> get props => [id];
}
