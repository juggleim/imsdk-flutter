import 'package:juggle_im/model/message_content.dart';

abstract class MediaMessageContent extends MessageContent {
  String localPath = '';
  String url = '';
}