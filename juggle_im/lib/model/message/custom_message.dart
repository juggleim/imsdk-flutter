import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class CustomMessage extends MessageContent {
  String customType = '';
  String content = '';
  String extra = '';

  CustomMessage();
  CustomMessage.content(this.customType, this.content);

  @override
  String getContentType() {
    return "jg:custom";
  }

  @override
  String encode() {
    Map map = {'customType': customType, "content": content, "extra": extra};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    customType = map['customType'] ?? '';
    content = map["content"] ?? '';
    extra = map["extra"] ?? '';
  }

}