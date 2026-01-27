import 'package:juggle_im/juggle_const.dart';

class GroupMember {
  String groupId = '';
  String userId = '';
  String groupDisplayName = '';
  Map<String, String>? extraMap;

  static GroupMember fromMap(Map map) {
    GroupMember info = GroupMember();
    info.groupId = map['groupId'] ?? '';
    info.userId = map['userId'] ?? '';
    info.groupDisplayName = map['groupDisplayName'] ?? '';
    info.extraMap = Utility.objectMapToStringMap(map['extraMap']);
    return info;
  }

  Map toMap() {
    Map map = {'groupId': groupId, 'userId': userId, 'groupDisplayName': groupDisplayName, 'extraMap': extraMap};
    return map;
  }
}