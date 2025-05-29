import 'package:juggle_im/model/message_content.dart';

class RecallInfoMessage extends MessageContent {
  Map? exts;

  RecallInfoMessage();

  @override
  String getContentType() {
    return 'jg:recallinfo';
  }

  @override
  Map encode() {
    Map map = {'exts': exts};
    return map;
  }

  @override
  void decode(Map map) {
    exts = map['exts'];
  }

}