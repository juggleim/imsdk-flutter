import 'package:juggle_im/model/user_info.dart';

class MomentReaction {
  String key = '';
  List<UserInfo> userList = [];

  static MomentReaction fromMap(Map map) {
    MomentReaction reaction = MomentReaction();
    reaction.key = map['key'] ?? '';

    List<dynamic>? userListMap = map['userList'];
    if (userListMap != null) {
      reaction.userList = userListMap.map((item) {
        return item is Map ? UserInfo.fromMap(item) : UserInfo();
      }).toList();
    }

    return reaction;
  }
}