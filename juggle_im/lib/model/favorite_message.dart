import 'package:juggle_im/model/message.dart';

class FavoriteMessage {
  Message message;
  int createdTime;

  FavoriteMessage(this.message, this.createdTime);

  static FavoriteMessage fromMap(Map map) {
    Message m = Message.fromMap(map['message']);
    int t = map['createdTime'] ?? 0;
    return FavoriteMessage(m, t);
  }
}