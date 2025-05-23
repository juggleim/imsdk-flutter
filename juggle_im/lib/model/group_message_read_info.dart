class GroupMessageReadInfo {
  int? readCount;
  int? memberCount;

  static GroupMessageReadInfo fromMap(Map map) {
    GroupMessageReadInfo info = GroupMessageReadInfo();
    info.readCount = map['readCount'];
    info.memberCount = map['memberCount'];
    return info;
  }
}