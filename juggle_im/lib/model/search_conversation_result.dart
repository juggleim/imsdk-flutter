import 'package:juggle_im/model/conversation_info.dart';

class SearchConversationResult {
  ConversationInfo conversationInfo;
  int matchedCount;

  SearchConversationResult(this.conversationInfo, this.matchedCount);
}