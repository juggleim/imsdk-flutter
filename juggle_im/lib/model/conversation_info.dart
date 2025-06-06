
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_mention_info.dart';
import 'package:juggle_im/model/message.dart';

class ConversationInfo {
  Conversation conversation;
  int unreadCount = 0;
  bool hasUnread = false;
  int sortTime = 0;
  Message? lastMessage;
  bool isTop = false;
  int topTime = 0;
  bool mute = false;
  String draft = '';
  ConversationMentionInfo? mentionInfo;
  String name = '';
  String portrait = '';
  Map<String, String>? extra;

  ConversationInfo(this.conversation);

  static ConversationInfo fromMap(Map map) {
    Map conversationMap = map['conversation'];
    var conversation = Conversation.fromMap(conversationMap);
    var result = ConversationInfo(conversation);
    result.unreadCount = map['unreadCount'] ?? 0;
    result.hasUnread = map['hasUnread'] ?? 0;
    result.sortTime = map['sortTime'] ?? 0;
    Map? lastMessageMap = map['lastMessage'];
    if (lastMessageMap != null) {
      result.lastMessage = Message.fromMap(lastMessageMap);
    }
    result.isTop = map['isTop'] ?? false;
    result.topTime = map['topTime'] ?? 0;
    result.mute = map['mute'] ?? false;
    result.draft = map['draft'] ?? '';
    Map? mentionInfoMap = map['mentionInfo'];
    if (mentionInfoMap != null) {
      result.mentionInfo = ConversationMentionInfo.fromMap(mentionInfoMap);
    }
    result.name = map['name'] ?? '';
    result.portrait = map['portrait'] ?? '';
    result.extra = map['extra'];

    return result;
  }
}