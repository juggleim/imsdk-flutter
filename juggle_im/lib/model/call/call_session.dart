

import 'package:flutter/services.dart';
import 'package:juggle_im/model/call/call_member.dart';
import 'package:juggle_im/model/call/video_view.dart';



class CallSession {
  /// 通话 id
  String callId = '';
  /// 是否多人通话，false 表示一对一通话
  bool isMultiCall = false;
  /// 媒体类型（语音 0 / 视频 1）
  int mediaType = 0;
  /// 通话状态（参考 CallStatus）
  int callStatus = 0;
  /// 呼叫开始时间（多人会话中当前用户被呼叫的时间，不一定等于整个通话开始的时间）
  int startTime = 0;
  /// 当前用户加入通话的时间
  int connectTime = 0;
  /// 当前用户结束通话的时间
  int finishTime = 0;
  /// 通话的发起人 id
  String owner = '';
  /// 邀请当前用户加入通话的用户 id
  String inviterId = '';
  /// 通话结束原因（参考 CallFinishReason）
  int finishReason = 0;
  /// 通话参与者（除当前用户外的其他参与者）
  List<CallMember> members = [];
  /// 扩展字段
  String extra = '';

  final _methodChannel = const MethodChannel('juggle_im');

  static CallSession fromMap(Map map) {
    var result = CallSession();
    if (map.isEmpty) {
      return result;
    }
    result.callId = map['callId'] ?? '';
    result.isMultiCall = map['isMultiCall'] ?? false;
    result.mediaType = map['mediaType'] ?? 0;
    result.callStatus = map['callStatus'] ?? 0;
    result.startTime = map['startTime'] ?? 0;
    result.connectTime = map['connectTime'] ?? 0;
    result.finishTime = map['finishTime'] ?? 0;
    result.owner = map['owner'] ?? '';
    result.inviterId = map['inviterId'] ?? '';
    result.finishReason = map['finishReason'] ?? 0;
    result.extra = map['extra'] ?? '';
    List<CallMember> members = [];
    List callMemberList = map['members'];
    for (Map memberMap in callMemberList) {
      CallMember member = CallMember.fromMap(memberMap);
      members.add(member);
    }
    result.members = members;
    return result;
  }

  /// 接听来电
  Future<void> accept() async {
    await _methodChannel.invokeMethod('callAccept', callId);
  }

  /// 挂断电话
  Future<void> hangup() async {
    await _methodChannel.invokeMethod('callHangup', callId);
  }

  /// 开启摄像头
  Future<void> enableCamera(bool isEnable) async {
    Map map = {'callId': callId, 'isEnable': isEnable};
    await _methodChannel.invokeMethod('callEnableCamera', map);
  }

  /// 设置用户的视频 view
  Future<void> setVideoView(String userId, VideoView view) async {
    Map map = {'callId': callId, 'userId': userId, 'viewId': view.viewId};
    await _methodChannel.invokeMethod('callSetVideoView', map);
  }

  /// 开始预览
  Future<void> startPreview(VideoView view) async {
    Map map = {'callId': callId, 'viewId': view.viewId};
    await _methodChannel.invokeMethod('callStartPreview', map);
  }

  /// 设置麦克风静音
  /// - Parameter isMute: 是否静音
  Future<void> muteMicrophone(bool isMute) async {
    Map map = {'callId': callId, 'isMute': isMute};
    await _methodChannel.invokeMethod('callMuteMicrophone', map);
  }

  /// 设置扬声器静音
  /// - Parameter isMute: 是否静音
  Future<void> muteSpeaker(bool isMute) async {
    Map map = {'callId': callId, 'isMute': isMute};
    await _methodChannel.invokeMethod('callMuteSpeaker', map);
  }

  /// 设置外放声音
  /// - Parameter isEnable: YES 使用外放扬声器；NO 使用听筒
  Future<void> setSpeakerEnable(bool isEnable) async {
    Map map = {'callId': callId, 'isEnable': isEnable};
    await _methodChannel.invokeMethod('callSetSpeakerEnable', map);
  }

  /// 切换摄像头，默认 YES 使用前置摄像头
  /// - Parameter isEnable: YES 使用前置摄像头；NO 使用后置摄像头
  Future<void> useFrontCamera(bool isEnable) async {
    Map map = {'callId': callId, 'isEnable': isEnable};
    await _methodChannel.invokeMethod('callUseFrontCamera', map);
  }

  /// 呼叫用户加入通话（isMultiCall 为 NO 时不支持该功能）
  /// - Parameter userIdList: 呼叫的用户 id 列表
  Future<void> inviteUsers(List<String> userIdList) async {
    Map map = {'callId': callId, 'userIdList': userIdList};
    await _methodChannel.invokeMethod('callInviteUsers', map);
  }

  Function()? onCallConnect;
  Function(int finishReason)? onCallFinish;
  Function(List<String> userIdList, String inviterId)? onUsersInvite;
  Function(List<String> userIdList)? onUsersConnect;
  Function(List<String> userIdList)? onUsersLeave;
  Function(String userId, bool enable)? onUserCameraChange;
  Function(String userId, bool enable)? onUserMicrophoneChange;
  Function(int errorCode)? onErrorOccur;
  Function(Map<String, double>)? onSoundLevelUpdate;
}