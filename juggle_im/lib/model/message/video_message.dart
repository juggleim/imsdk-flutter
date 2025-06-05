import 'dart:convert';

import 'package:juggle_im/model/media_message_content.dart';

class VideoMessage extends MediaMessageContent {
  String? snapshotLocalPath;
  String? snapshotUrl;
  int? height;
  int? width;
  int? size;
  int? duration;
  String? extra;

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
    url = map['url'];
    snapshotLocalPath = map['snapshotLocalPath'];
    localPath = map['local'];
    width = map['width'];
    height = map['height'];
    size = map['size'];
    extra = map['extra'];
    snapshotUrl = map['poster'];
    duration = map['duration'];
  }

  @override
  String conversationDigest() {
    return '[Video]';
  }
}