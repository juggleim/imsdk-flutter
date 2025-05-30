class GroupInfo {
  String? groupId;
  String? groupName;
  String? portrait;
  Map<String, String>? extraMap;

  static GroupInfo fromMap(Map map) {
    GroupInfo info = GroupInfo();
    info.groupId = map['groupId'];
    info.groupName = map['groupName'];
    info.portrait = map['portrait'];
    info.extraMap = map['extraMap'];
    return info;
  }

  Map toMap() {
    Map map = {'groupId': groupId, 'groupName': groupName, 'portrait': portrait, 'extraMap': extraMap};
    return map;
  }
}