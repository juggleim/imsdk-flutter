import 'package:juggle_im/model/message.dart';
import 'package:juggle_im/model/user_info.dart';

class TopMessageResult {
  Message message;
  UserInfo operator;
  int timestamp;

  TopMessageResult(this.message, this.operator, this.timestamp);
}