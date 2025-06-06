
class ConversationMentionMessage {
  String senderId = '';
  String msgId = '';
  int msgTime = 0;
  int type = 0;

  static ConversationMentionMessage fromMap(Map map) {
    ConversationMentionMessage m = ConversationMentionMessage();
    m.senderId = map['senderId'] ?? '';
    m.msgId = map['msgId'] ?? '';
    m.msgTime = map['msgTime'] ?? 0;
    m.type = map['type'] ?? 0;
    return m;
  } 
}

class ConversationMentionInfo {
  List<ConversationMentionMessage> mentionMsgList = [];

  static ConversationMentionInfo fromMap(Map map) {
    ConversationMentionInfo info = ConversationMentionInfo();
    List<ConversationMentionMessage> list = [];
    for (Map messageMap in map['mentionMsgList']) {
      ConversationMentionMessage m = ConversationMentionMessage.fromMap(messageMap);
      list.add(m);
    }
    info.mentionMsgList = list;
    return info;
  }
}