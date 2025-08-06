import 'package:juggle_im/model/message_mention_info.dart';
import 'package:juggle_im/model/push_data.dart';

class SendMessageOption {
  String? referredMessageId;
  MessageMentionInfo? mentionInfo;
  PushData? pushData;
  int lifeTime = 0;
  int lifeTimeAfterRead = 0;

  Map toMap() {
    Map map = {'lifeTime': lifeTime, 'lifeTimeAfterRead': lifeTimeAfterRead};
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