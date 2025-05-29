import 'package:juggle_im/model/user_info.dart';

class MessageReactionItem {
  String? reactionId;
  List<UserInfo>? userInfoList;

  static MessageReactionItem fromMap(Map map) {
    MessageReactionItem item = MessageReactionItem();
    item.reactionId = map['reactionId'];
    List<UserInfo> uList = [];
    List userMapList = map['userInfoList'];
    for (Map userMap in userMapList) {
      UserInfo userInfo = UserInfo.fromMap(userMap);
      uList.add(userInfo);
    }
    item.userInfoList = uList;
    return item;
  }
}