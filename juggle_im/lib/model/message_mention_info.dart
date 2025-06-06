import 'package:juggle_im/model/user_info.dart';

class MentionType {
  static const int unknown = 0;
  static const int all = 1;
  static const int someOne = 2;
  static const int allAndSomeOne = 3;
}

class MessageMentionInfo {
  int type = 0;
  List<UserInfo> targetUsers = [];

  static MessageMentionInfo fromMap(Map map) {
    MessageMentionInfo info = MessageMentionInfo();
    info.type = map['type'] ?? 0;
    List<UserInfo> list = [];
    List? targetUsersMap = map['targetUsers'];
    if (targetUsersMap != null) {
      for (Map userMap in targetUsersMap) {
        UserInfo userInfo = UserInfo.fromMap(userMap);
        list.add(userInfo);
      }
    }
    info.targetUsers = list;
    return info;
  }

  Map toMap() {
    Map map = {'type': type};
    var list = [];
    for (UserInfo userInfo in targetUsers) {
      Map userInfoMap = userInfo.toMap();
      list.add(userInfoMap);
    }
    map['targetUsers'] = list;
    return map;
  }
}