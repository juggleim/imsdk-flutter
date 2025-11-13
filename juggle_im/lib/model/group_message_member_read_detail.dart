import 'package:juggle_im/model/user_info.dart';

class GroupMessageMemberReadDetail {
  int readTime = 0;
  UserInfo userInfo;

  GroupMessageMemberReadDetail(this.userInfo, this.readTime);

  static GroupMessageMemberReadDetail fromMap(Map map) {
    int readTime = map['readTime'];
    UserInfo info = UserInfo.fromMap(map['userInfo']);
    return GroupMessageMemberReadDetail(info, readTime);
  }
}