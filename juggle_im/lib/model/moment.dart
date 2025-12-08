import 'package:juggle_im/model/moment_comment.dart';
import 'package:juggle_im/model/moment_media.dart';
import 'package:juggle_im/model/moment_reaction.dart';
import 'package:juggle_im/model/user_info.dart';

class Moment {
  String momentId = '';
  String content = '';
  List<MomentMedia> mediaList = [];
  UserInfo? userInfo;
  List<MomentReaction> reactionList = [];
  List<MomentComment> commentList = [];
  int createTime = 0;

  static Moment fromMap(Map map) {
    Moment moment = Moment();
    moment.momentId = map['moment_id'] ?? '';
    Map contentMap = map['content'];
    moment.content = contentMap['text'] ?? '';
    moment.createTime = map['moment_time'] ?? 0;

    Map? userInfoMap = map['user_info'];
    if (userInfoMap != null) {
      moment.userInfo = UserInfo.fromMap(userInfoMap);
    }

    List<dynamic>? mediaListMap = map['medias'];
    if (mediaListMap != null) {
      moment.mediaList = mediaListMap.map((item) {
        return item is Map ? MomentMedia.fromMap(item) : MomentMedia();
      }).toList();
    }

    List<dynamic>? reactionListMap = map['reactions'];
    if (reactionListMap != null) {
      moment.reactionList = reactionListMap.map((item) {
        return item is Map ? MomentReaction.fromMap(item) : MomentReaction();
      }).toList();
    }

    List<dynamic>? commentListMap = map['top_comments'];
    if (commentListMap != null) {
      moment.commentList = commentListMap.map((item) {
        return item is Map ? MomentComment.fromMap(item) : MomentComment();
      }).toList();
    }

    return moment;
  }
}