class FriendInfo {
  String userId = '';
  bool isFriend = true;
  String alias = '';

  static FriendInfo fromMap(Map map) {
    FriendInfo info = FriendInfo();
    info.userId = map['userId'] ?? '';
    info.isFriend = map['isFriend'] ?? true;
    info.alias = map['alias'] ?? '';
    return info;
  }
} 