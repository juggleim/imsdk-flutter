import 'package:juggle_im/model/message_mention_info.dart';
import 'package:juggle_im/model/push_data.dart';

class SendMessageOption {
  String? referredMessageId;
  MessageMentionInfo? mentionInfo;
  PushData? pushData;

  Map toMap() {
    Map map = {'referredMessageId': referredMessageId, 'mentionInfo': mentionInfo?.toMap(), 'pushData': pushData?.toMap()};
    return map;
  }
}