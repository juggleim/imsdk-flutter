import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class CallFinishNotifyMessage extends MessageContent {
  static const int typeCancel = 0;
  static const int typeReject = 1;
  static const int typeNoResponse = 2;
  static const int typeComplete = 3;

  int finishType = 3;
  int duration = 0;
  int mediaType = 0;

  CallFinishNotifyMessage();

  @override
  String getContentType() {
    return 'jg:callfinishntf';
  }

  @override
  String encode() {
    Map map = {'reason': finishType, 'duration': duration, 'media_type': mediaType};
    return json.encode(map);
  }

  @override
  void decode(String content) {
    Map map = json.decode(content);
    finishType = map['reason'] ?? 3;
    duration = map['duration'] ?? 0;
    mediaType = map['media_type'] ?? 0;
  }

  @override
  String conversationDigest() {
    return '[Call]';
  }
}