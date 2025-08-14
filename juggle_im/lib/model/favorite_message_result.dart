import 'package:juggle_im/model/favorite_message.dart';

class FavoriteMessageResult {
  List<FavoriteMessage> messageList;
  String offset;
  
  FavoriteMessageResult(this.messageList, this.offset);
}