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
  Map encode() {
    Map map = {'url': url, 'local': localPath, 'duration': duration, 'extra': extra};
    return map;
  }

  @override
  void decode(Map map) {
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