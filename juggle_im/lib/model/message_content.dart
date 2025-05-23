abstract class MessageContent {
  static String getContentType() {
    return "jg:unknown";
  }

  String conversationDigest() {
    return "";
  }

  String encode();

  void decode(Map map);

  String getSearchContent() {
    return '';
  }
}