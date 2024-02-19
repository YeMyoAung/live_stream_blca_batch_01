// {id: 7, comment: asdfa, live_id: 81, user_id: 3631493044, created_at: 2024-02-14T12:24:57.537665189Z, updated_at: 2024-02-14T12:24:57.537665269Z, user: {Uid: 2428590973, Identifier: bwkQX9nVKMYfu7aduGTsCFde5qY2, DisplayName: Nunuaung Nu, ProfilePhoto: https://lh3.googleusercontent.com/a/ACg8ocLwxCkwmaPGmanvLXcgEs95kP_QIvD8E3wGSwm83bIP=s96-c, Gender: , CreatedAt: 2024-02-05T13:50:01.899235Z, UpdatedAt: 2024-02-05T13:50:01.899235Z, DeletedAt: null}}

class UiLiveStreamComment {
  final int id, liveId, userId;
  final String comment, identity, displayName, profilePhoto;
  final DateTime createdAt;

  const UiLiveStreamComment({
    required this.id,
    required this.liveId,
    required this.userId,
    required this.comment,
    required this.identity,
    required this.displayName,
    required this.profilePhoto,
    required this.createdAt,
  });

  factory UiLiveStreamComment.fromJson(dynamic data) {
    return UiLiveStreamComment(
      id: int.parse(data['id'].toString()), //data['id'] as int
      liveId: int.parse(data['live_id'].toString()),
      userId: int.parse(data['user']['Uid'].toString()),
      comment: data['comment'],
      identity: data['user']['Identifier'],
      displayName: data['user']['DisplayName'],
      profilePhoto: data['user']['ProfilePhoto'],
      createdAt: DateTime.parse(data['created_at']),
    );
  }
}
