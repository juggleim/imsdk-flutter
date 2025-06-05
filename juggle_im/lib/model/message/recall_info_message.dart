import 'dart:convert';

import 'package:juggle_im/model/message_content.dart';

class RecallInfoMessage extends MessageContent {
  Map? exts;

  RecallInfoMessage();

  @override
  String getContentType() {
    return 'jg:recallinfo';
  }

  @override
  String encode() {
    Map map = {'exts': exts};
    return json.encode(map
    );
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    exts = map['exts'];
  }

}