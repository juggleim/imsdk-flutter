abstract class MessageContent {
  String getContentType() {
    return "jg:unknown";
  }

  String conversationDigest() {
    return "";
  }

  Map encode();

  void decode(Map map);

  String getSearchContent() {
    return '';
  }
}