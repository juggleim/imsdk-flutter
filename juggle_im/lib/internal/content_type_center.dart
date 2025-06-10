import 'package:juggle_im/model/message_content.dart';

typedef MessageFactory = MessageContent Function();

class ContentTypeCenter {
  
  static final Map<String, Function> _contentTypeMap = {};

  static registerMessageType(String contentType, MessageFactory factory) {
    _contentTypeMap[contentType] = factory;
  }

  static MessageContent? getContent(String? type, String contentString) {
    if (type == null) {
      return null;
    }
    final factory = _contentTypeMap[type] as MessageFactory?;
    if (factory != null) {
      MessageContent content = factory();
      content.decode(type, contentString);
      return content;
    }
    return null;
  }
}