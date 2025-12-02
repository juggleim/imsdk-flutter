import 'package:juggle_im/model/user_info.dart';

class MomentComment {
  String commentId = '';
  String momentId = '';
  String parentCommentId = '';
  String content = '';
  UserInfo? userInfo;
  UserInfo? parentUserInfo;
  int createTime = 0;

  static MomentComment fromMap(Map map) {
    MomentComment comment = MomentComment();
    comment.commentId = map['comment_id'] ?? '';
    comment.momentId = map['moment_id'] ?? '';
    comment.parentCommentId = map['parent_comment_id'] ?? '';
    comment.content = map['content'] ?? '';
    comment.createTime = map['comment_time'] ?? 0;

    Map? userInfoMap = map['user_info'];
    if (userInfoMap != null) {
      comment.userInfo = UserInfo.fromMap(userInfoMap);
    }

    Map? parentUserInfoMap = map['parent_user_info'];
    if (comment.parentCommentId.isNotEmpty && parentUserInfoMap != null) {
      comment.parentUserInfo = UserInfo.fromMap(parentUserInfoMap);
    }

    return comment;
  }
}