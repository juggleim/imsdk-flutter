import 'dart:convert';

import 'package:juggle_im/model/media_message_content.dart';

class VoiceMessage extends MediaMessageContent {
  int? duration;
  String? extra;

  VoiceMessage();

  @override
  String getContentType() {
    return 'jg:voice';
  }

  @override
  String encode() {
    Map map = {'url': url, 'local': localPath, 'duration': duration, 'extra': extra};
    return json.encode(map);
  }

  @override
  void decode(String string) {
    Map map = json.decode(string);
    url = map['url'];
    localPath = map['local'];
    duration = map['duration'];
    extra = map['extra'];
  }

  @override
  String conversationDigest() {
    return '[Voice]';
  }
}