
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_mention_info.dart';
import 'package:juggle_im/model/message.dart';

class ConversationInfo {
  Conversation? conversation;
  int? unreadCount;
  bool? hasUnread;
  int? sortTime;
  Message? lastMessage;
  bool? isTop;
  int? topTime;
  bool? mute;
  String? draft;
  ConversationMentionInfo? mentionInfo;
  String? name;
  String? portrait;
  Map<String, String>? extra;

  static ConversationInfo fromMap(Map map) {
    Map conversationMap = map['conversation'];
    var result = ConversationInfo();
    result.conversation = Conversation.fromMap(conversationMap);
    result.unreadCount = map['unreadCount'];
    result.hasUnread = map['hasUnread'];
    result.sortTime = map['sortTime'];
    Map? lastMessageMap = map['lastMessage'];
    if (lastMessageMap != null) {
      result.lastMessage = Message.fromMap(lastMessageMap);
    }
    result.isTop = map['isTop'];
    result.topTime = map['topTime'];
    result.mute = map['mute'];
    result.draft = map['draft'];
    Map? mentionInfoMap = map['mentionInfo'];
    if (mentionInfoMap != null) {
      result.mentionInfo = ConversationMentionInfo.fromMap(mentionInfoMap);
    }
    result.name = map['name'];
    result.portrait = map['portrait'];
    result.extra = map['extra'];

    return result;
  }
}