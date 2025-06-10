import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class GroupNotifyMessage extends MessageContent {
  String content = '';
  String messageType = '';

  GroupNotifyMessage();

  @override
  String encode() {
    return content;
  }

  @override
  void decode(String type, String string) {
    content = string;
    messageType = type;
  }
}