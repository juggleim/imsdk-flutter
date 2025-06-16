import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class GroupNotifyMessage extends MessageContent {
  String content = '';
  String aaa = '';
  // String messageType = '';

  GroupNotifyMessage();

  @override
  String getContentType() {
    return "jgd:grpntf2";
  }
  

  @override
  String encode() {
    Map map = {"content": content, "aaa": aaa};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    content = map['content'] ?? '';
    aaa = map['aaa'] ?? '';
    // messageType = type;
  }
}