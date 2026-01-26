import 'package:juggle_im/internal/content_type_center.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/group_message_read_info.dart';
import 'package:juggle_im/model/message_content.dart';
import 'package:juggle_im/model/message_mention_info.dart';
import 'package:juggle_im/model/user_info.dart';

class MessageDirection {
  static int send = 1;
  static int receive = 2;
}

class MessageState {
  static int unknown = 0;
  static int sending = 1;
  static int sent = 2;
  static int fail = 3;
  static int uploading = 4;
}

class Message {
  Conversation conversation;
  String contentType = '';
  int clientMsgNo = -1;
  String messageId = '';
  int direction = 0;
  int messageState = 0;
  bool hasRead = false;
  int timestamp = 0;
  String senderUserId = '';
  MessageContent? content;
  GroupMessageReadInfo? groupReadInfo;
  MessageMentionInfo? mentionInfo;
  Message? referredMsg;
  String localAttribute = '';
  bool isEdit = false;
  UserInfo? sender;
  String senderDisplayName = '';
  String friendAlias = '';
  String groupMemberAlias = '';
  int destroyTime = 0;
  int lifeTimeAfterRead = 0;

  Message(this.conversation);

  static Message fromMap(Map map) {
    Map conversationMap = map["conversation"];
    Conversation conversation = Conversation.fromMap(conversationMap);
    Message m = Message(conversation);
    m.contentType = map['contentType'] ?? '';
    m.clientMsgNo = map['clientMsgNo'] ?? -1;
    m.messageId = map['messageId'] ?? '';
    m.direction = map['direction'] ?? 0;
    m.messageState = map['messageState'] ?? 0;
    m.hasRead = map['hasRead'] ?? false;
    m.timestamp = map['timestamp'] ?? 0;
    m.senderUserId = map['senderUserId'] ?? '';
    String? contentString = map["content"];
    if (contentString != null) {
      m.content = ContentTypeCenter.getContent(m.contentType, contentString);
    }
    Map? groupReadInfoMap = map['groupReadInfo'];
    if (groupReadInfoMap != null) {
      m.groupReadInfo = GroupMessageReadInfo.fromMap(groupReadInfoMap);
    }
    Map? mentionInfoMap = map['mentionInfo'];
    if (mentionInfoMap != null) {
      m.mentionInfo = MessageMentionInfo.fromMap(mentionInfoMap);
    }
    if (map['referredMsg'] != null) {
      m.referredMsg = Message.fromMap(map['referredMsg']);
    }
    m.localAttribute = map['localAttribute'] ?? '';
    m.isEdit = map['isEdit'] ?? false;
    if (map['sender'] != null) {
      m.sender = UserInfo.fromMap(map['sender']);
    }
    m.senderDisplayName = map['senderDisplayName'] ?? '';
    m.friendAlias = map['friendAlias'] ?? '';
    m.groupMemberAlias = map['groupMemberAlias'] ?? '';
    m.destroyTime = map['destroyTime'] ?? 0;
    m.lifeTimeAfterRead = map['lifeTimeAfterRead'] ?? 0;

    return m;
  }

  Map toMap() {
    Map map = {'contentType': contentType,
      'clientMsgNo': clientMsgNo,
      'messageId': messageId,
      'direction': direction,
      'messageState': messageState,
      'hasRead': hasRead,
      'timestamp': timestamp,
      'senderUserId': senderUserId,
      'localAttribute': localAttribute,
      'isEdit': isEdit,
      'destroyTime': destroyTime,
      'lifeTimeAfterRead': lifeTimeAfterRead
      };
    map['conversation'] = conversation.toMap();
    if (content != null) {
      map['content'] = content!.encode();
    }
    // 不需要
    // if (groupReadInfo != null) {
    //   map['groupReadInfo'] = groupReadInfo.toMap();
    // }
    if (mentionInfo != null) {
      map['mentionInfo'] = mentionInfo!.toMap();
    }
    if (referredMsg != null) {
      map['referredMsg'] = referredMsg!.toMap();
    }
    if (sender != null) {
      map['sender'] = sender!.toMap();
    }
    return map;
  }
}