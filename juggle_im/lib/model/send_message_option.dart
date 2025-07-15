import 'package:juggle_im/model/message_mention_info.dart';
import 'package:juggle_im/model/push_data.dart';

class SendMessageOption {
  String? referredMessageId;
  MessageMentionInfo? mentionInfo;
  PushData? pushData;

  Map toMap() {
    Map map = {};
    if (referredMessageId != null) {
      map['referredMsgId'] = referredMessageId;
    }
    if (mentionInfo != null) {
      map['mentionInfo'] = mentionInfo!.toMap();
    }
    if (pushData != null) {
      map['pushData'] = pushData!.toMap();
    }
    return map;
  }
}