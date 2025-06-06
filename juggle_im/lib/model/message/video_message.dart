import 'dart:convert';

import 'package:juggle_im/model/media_message_content.dart';

class VideoMessage extends MediaMessageContent {
  String snapshotLocalPath = '';
  String snapshotUrl = '';
  int height = 0;
  int width = 0;
  int size = 0;
  int duration = 0;
  String extra = '';

  VideoMessage();

  @override
  String getContentType() {
    return 'jg:video';
  }

  @override
  String encode() {
    Map map = {'url': url, 'snapshotLocalPath': snapshotLocalPath, 'local': localPath, 'width': width, 'height': height, 'size': size, 'extra': extra, 'poster': snapshotUrl, 'duration': duration};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    url = map['url'] ?? '';
    snapshotLocalPath = map['snapshotLocalPath'] ?? '';
    localPath = map['local'] ?? '';
    width = map['width'] ?? 0;
    height = map['height'] ?? 0;
    size = map['size'] ?? 0;
    extra = map['extra'] ?? '';
    snapshotUrl = map['poster'] ?? '';
    duration = map['duration'] ?? 0;
  }

  @override
  String conversationDigest() {
    return '[Video]';
  }
}