import 'package:juggle_im/model/user_info.dart';

class CallMember {
  UserInfo userInfo;
  int callStatus = 0;
  int startTime = 0;
  int connectTime = 0;
  int finishTime = 0;
  UserInfo? inviter;

  CallMember(this.userInfo);

  static CallMember fromMap(Map map) {
    UserInfo userInfo = UserInfo.fromMap(map['userInfo']);
    var result = CallMember(userInfo);
    Map? inviterMap = map['inviter'];
    if (inviterMap != null) {
      result.inviter = UserInfo.fromMap(inviterMap);
    }
    result.callStatus = map['callStatus'] ?? 0;
    result.startTime = map['startTime'] ?? 0;
    result.connectTime = map['connectTime'] ?? 0;
    result.finishTime = map['finishTime'] ?? 0;
    return result;
  }
}