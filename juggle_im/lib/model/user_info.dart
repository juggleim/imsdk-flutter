class UserType {
  static const int normal = 0;
  static const int bot = 1;
}

class UserInfo {
  String? userId;
  String? userName;
  String? portrait;
  Map<String, String>? extraMap;
  int? type;

  static UserInfo fromMap(Map map) {
    UserInfo info = UserInfo();
    info.userId = map['userId'];
    info.userName = map['userName'];
    info.portrait = map['portrait'];
    info.extraMap = map['extraMap'];
    info.type = map['type'];
    return info;
  }

  Map toMap() {
    Map map = {'userId': userId, 'userName': userName, 'portrait': portrait, 'extraMap': extraMap, 'type': type};
    return map;
  }
}