import 'package:juggle_im/model/media_message_content.dart';

class FileMessage extends MediaMessageContent {
  String? name;
  int? size;
  String? type;
  String? extra;

  FileMessage();

  @override
  String getContentType() {
    return "jg:file";
  }

  @override
  Map encode() {
    Map map = {'url': url, 'name': name, 'local': localPath, 'size': size, 'type': type, 'extra': extra};
    return map;
  }

  @override
  void decode(Map map) {
    url = map['url'];
    name = map['name'];
    localPath = map['local'];
    size = map['size'];
    extra = map['extra'];
    type = map['type'];
  }

  @override
  String conversationDigest() {
    return "[File]";
  }
}