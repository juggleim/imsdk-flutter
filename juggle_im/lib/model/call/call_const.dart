class CallStatus {
  static const int idle = 0;
  static const int incoming = 1;
  static const int outgoing = 2;
  static const int connecting = 3;
  static const int connected = 4;
}

class CallMediaType {
  static const int voice = 0;
  static const int video = 1;
}

class CallFinishReason {
  /// 未知原因
  static const int unknown = 0;
  /// 当前用户挂断已接通的来电
  static const int hangup = 1;
  /// 当前用户拒接来电
  static const int decline = 2;
  /// 当前用户忙线
  static const int busy = 3;
  /// 当前用户未接听
  static const int noResponse = 4;
  /// 当前用户取消呼叫
  static const int cancel = 5;
  /// 对端用户挂断已接通的来电
  static const int otherSideHangup = 6;
  /// 对端用户拒接来电
  static const int otherSideDecline = 7;
  /// 对端用户忙线
  static const int otherSideBusy = 8;
  /// 对端用户未接听
  static const int otherSideNoResponse = 9;
  /// 对端用户取消呼叫
  static const int otherSideCancel = 10;
  /// 房间被销毁
  static const int roomDestroy = 11;
  /// 网络出错
  static const int networkError = 12;
  /// 当前用户在其它端接听来电
  static const int acceptOnOtherClient = 13;
  /// 当前用户在其它端挂断来电
  static const int hangupOnOtherClient = 14;
}

class CallErrorCode {
  /// 成功
  static const int success = 0;
  /// 已在通话中
  static const int callExist = 1;
  /// 没被邀请时不能接听通话
  static const int cantAcceptWhileNotInvited = 2;
  /// 接听失败
  static const int acceptFail = 3;
  /// 加入 Media 房间失败
  static const int joinMediaRoomFail = 4;
  /// 参数错误
  static const int invalidParaMeter = 5;
  /// 邀请失败
  static const int inviteFail = 6;
}