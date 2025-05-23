import 'package:juggle_im/model/user_info.dart';

class MentionType {
  static const int unknown = 0;
  static const int all = 1;
  static const int someOne = 2;
  static const int allAndSomeOne = 3;
}

class MessageMentionInfo {
  int? type;
  List<UserInfo>? targetUsers;

  static MessageMentionInfo fromMap(Map map) {
    MessageMentionInfo info = MessageMentionInfo();
    info.type = map['type'];
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
}