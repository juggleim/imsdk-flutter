import 'dart:convert';

import 'package:juggle_im/juggle_const.dart';
import 'package:juggle_im/model/media_message_content.dart';

class FileMessage extends MediaMessageContent {
  String name = '';
  int size = 0;
  String type = '';
  String extra = '';

  FileMessage();

  @override
  String getContentType() {
    return "jg:file";
  }

  @override
  String encode() {
    String path = Utility.removePrivatePrefix(localPath);
    Map map = {'url': url, 'name': name, 'local': path, 'size': size, 'type': type, 'extra': extra};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    url = map['url'] ?? '';
    name = map['name'] ?? '';
    localPath = map['local'] ?? '';
    size = map['size'] ?? 0;
    extra = map['extra'] ?? '';
    type = map['type'] ?? '';
  }

  @override
  String conversationDigest() {
    return "[File]";
  }
}