
import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class TextMessage extends MessageContent {
  String content = '';
  String extra = '';


  TextMessage();
  TextMessage.content(this.content);

  @override
  String getContentType() {
    return "jg:text";
  }

  @override
  String encode() {
    Map map = {"content": content, "extra": extra};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    content = map["content"] ?? '';
    extra = map["extra"] ?? '';
  }

  @override
  String conversationDigest() {
    return content;
  }
}