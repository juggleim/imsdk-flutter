import 'package:juggle_im/model/message_content.dart';

typedef MessageFactory = MessageContent Function();

class ContentTypeCenter {
  
  static final Map<String, Function> _contentTypeMap = {};

  static registerMessageType(MessageFactory factory) {
    MessageContent content = factory();
    _contentTypeMap[content.getContentType()] = factory;
  }

  static MessageContent? getContent(String? type, String contentString) {
    if (type == null) {
      return null;
    }
    final factory = _contentTypeMap[type] as MessageFactory?;
    if (factory != null) {
      MessageContent content = factory();
      content.decode(contentString);
      return content;
    }
    return null;
  }
}