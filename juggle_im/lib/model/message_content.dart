abstract class MessageContent {
  String getContentType() {
    return "jg:unknown";
  }

  String conversationDigest() {
    return "";
  }

  String encode();

  void decode(String content);

  String getSearchContent() {
    return '';
  }
}