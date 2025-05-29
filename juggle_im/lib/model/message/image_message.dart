import 'package:juggle_im/model/media_message_content.dart';

class ImageMessage extends MediaMessageContent {
  String? thumbnailLocalPath;
  String? thumbnailUrl;
  int? height;
  int? width;
  int? size;
  String? extra;

  ImageMessage();

  @override
  String getContentType() {
    return "jg:img";
  }

  @override
  Map encode() {
    Map map = {'url': url, 'thumbnail': thumbnailUrl, 'local': localPath, 'width': width, 'height': height, 'size': size, 'extra': extra, 'thumbnailLocalPath': thumbnailLocalPath};
    return map;
  }

  @override
  void decode(Map map) {
    url = map['url'];
    thumbnailUrl = map['thumbnail'];
    localPath = map['local'];
    width = map['width'];
    height = map['height'];
    size = map['size'];
    extra = map['extra'];
    thumbnailLocalPath = map['thumbnailLocalPath'];
  }

  @override
  String conversationDigest() {
    return '[Image]';
  }
}