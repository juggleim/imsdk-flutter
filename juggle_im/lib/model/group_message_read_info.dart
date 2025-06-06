class GroupMessageReadInfo {
  int readCount = 0;
  int memberCount = 0;

  static GroupMessageReadInfo fromMap(Map map) {
    GroupMessageReadInfo info = GroupMessageReadInfo();
    info.readCount = map['readCount'] ?? 0;
    info.memberCount = map['memberCount'] ?? 0;
    return info;
  }
}