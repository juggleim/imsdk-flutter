import 'package:juggle_im/model/message_content.dart';

typedef MessageDecoder = MessageContent Function(Map map);

class ContentTypeCenter {
  static final Map<String, MessageDecoder> _decoders = <String, MessageDecoder>{};

  static registerMessageType(String type, MessageDecoder decoder) {
    _decoders[type] = decoder;
  }

  static MessageContent? getContent(String? type, Map map) {
    if (_decoders[type] != null) {
      return _decoders[type]!(map);
    }
    return null;
  }
}