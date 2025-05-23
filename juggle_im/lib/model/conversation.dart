import 'dart:convert';

class ConversationType {
  static const int unknown = 0;
  static const int private = 1;
  static const int group = 2;
  static const int chatroom = 3;
  static const int system = 4;
}

class Conversation {
  int conversationType;
  String conversationId;

  Conversation(this.conversationType, this.conversationId);

  static Conversation conversationFromString(String str) {
    Map map = json.decode(str);
    return conversationFromMap(map);
  }

  static Conversation conversationFromMap(Map map) {
    int conversationType = map["conversationType"];
    String conversationId = map['conversationId'];
    return Conversation(conversationType, conversationId);
  }
}