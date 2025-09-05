import 'package:juggle_im/model/call/call_member.dart';
import 'package:juggle_im/model/user_info.dart';

class CallInfo {
  /// 通话 id
  String callId = '';
  /// 是否多人通话，false 表示一对一通话
  bool isMultiCall = true;
  /// 媒体类型（语音 0 / 视频 1）
  int mediaType = 0;
  /// 通话的发起人
  UserInfo? owner;
  /// 通话参与者
  List<CallMember> members = [];
  /// 扩展字段
  String extra = '';

  static CallInfo fromMap(Map map) {
    CallInfo callInfo = CallInfo();
    callInfo.callId = map['callId'] ?? '';
    callInfo.isMultiCall = map['isMultiCall'] ?? true;
    callInfo.mediaType = map['mediaType'] ?? 0;
    Map? ownerMap = map['owner'];
    if (ownerMap != null) {
      callInfo.owner = UserInfo.fromMap(ownerMap);
    }
    List<CallMember> members = [];
    List callMemberList = map['members'];
    for (Map memberMap in callMemberList) {
      CallMember member = CallMember.fromMap(memberMap);
      members.add(member);
    }
    callInfo.members = members;
    callInfo.extra = map['extra'] ?? '';
    return callInfo;
  }
}