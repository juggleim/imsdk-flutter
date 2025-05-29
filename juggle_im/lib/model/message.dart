import 'package:juggle_im/internal/content_type_center.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/group_message_read_info.dart';
import 'package:juggle_im/model/message_content.dart';
import 'package:juggle_im/model/message_mention_info.dart';

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
  Conversation? conversation;
  String? contentType;
  int? clientMsgNo;
  String? messageId;
  int? direction;
  int? messageState;
  bool? hasRead;
  int? timestamp;
  String? senderUserId;
  MessageContent? content;
  GroupMessageReadInfo? groupReadInfo;
  MessageMentionInfo? mentionInfo;
  Message? referredMsg;
  String? localAttribute;
  bool? isEdit;

  static Message fromMap(Map map) {
    Message m = Message();
    Map conversationMap = map["conversation"];
    m.conversation = Conversation.fromMap(conversationMap);
    m.contentType = map['contentType'];
    m.clientMsgNo = map['clientMsgNo'];
    m.messageId = map['messageId'];
    m.direction = map['direction'];
    m.messageState = map['messageState'];
    m.hasRead = map['hasRead'];
    m.timestamp = map['timestamp'];
    m.senderUserId = map['senderUserId'];
    Map? contentMap = map["content"];
    if (contentMap != null) {
      m.content = ContentTypeCenter.getContent(m.contentType, contentMap);
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
    m.localAttribute = map['localAttribute'];
    m.isEdit = map['isEdit'];

    return m;
  }
}