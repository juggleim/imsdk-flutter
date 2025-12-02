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
    comment.commentId = map['commentId'] ?? '';
    comment.momentId = map['momentId'] ?? '';
    comment.parentCommentId = map['parentCommentId'] ?? '';
    comment.content = map['content'] ?? '';
    comment.createTime = map['createTime'] ?? 0;

    Map? userInfoMap = map['userInfo'];
    if (userInfoMap != null) {
      comment.userInfo = UserInfo.fromMap(userInfoMap);
    }

    Map? parentUserInfoMap = map['parentUserInfo'];
    if (parentUserInfoMap != null) {
      comment.parentUserInfo = UserInfo.fromMap(parentUserInfoMap);
    }

    return comment;
  }
}