import 'package:juggle_im/model/message_reaction_item.dart';

class MessageReaction {
  String? messageId;
  List<MessageReactionItem>? itemList;

  static MessageReaction fromMap(Map map) {
    MessageReaction reaction = MessageReaction();
    reaction.messageId = map['messageId'];
    List itemMapList = map['itemList'];
    List<MessageReactionItem> iList = [];
    for (Map itemMap in itemMapList) {
      MessageReactionItem item = MessageReactionItem.fromMap(itemMap);
      iList.add(item);
    }
    reaction.itemList = iList;
    return reaction;
  }
}