import 'dart:convert';

import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/message_content.dart';
import 'package:juggle_im/model/user_info.dart';

class MergeMessagePreviewUnit {
  String previewContent = '';
  UserInfo sender;

  MergeMessagePreviewUnit(this.previewContent, this.sender);

  Map<String, Object> toMap() {
    Map<String, Object> map = {'content': previewContent};
    map['userId'] = sender.userId;
    map['userName'] = sender.userName;
    map['portrait'] = sender.portrait;
    return map;
  }

  static MergeMessagePreviewUnit fromMap(Map map) {
    String p = map['content'] ?? '';
    UserInfo sender = UserInfo();
    sender.userId = map['userId'] ?? '';
    sender.userName = map['userName'] ?? '';
    sender.portrait = map['portrait'] ?? '';
    return MergeMessagePreviewUnit(p, sender);
  }
}

class MergeMessage extends MessageContent {
  Conversation? conversation;
  String title = '';
  List<String> messageIdList = [];
  List<MergeMessagePreviewUnit> previewList = [];
  String extra = '';
  String containerMsgId = '';

  MergeMessage();

  MergeMessage.create(this.title, this.conversation, this.messageIdList, this.previewList);

  @override
  String getContentType() {
    return 'jg:merge';
  }

  @override
  String encode() {
    Map map = {'title': title, 'extra': extra, 'containerMsgId': containerMsgId};
    if (conversation != null) {
      map['conversationType'] = conversation!.conversationType;
      map['conversationId'] = conversation!.conversationId;
    }
    if (messageIdList.isNotEmpty) {
      map['messageIdList'] = messageIdList;
    }
    if (previewList.isNotEmpty) {
      List<Map<String, Object>> list = [];
      for (MergeMessagePreviewUnit unit in previewList) {
        Map<String, Object> unitMap = unit.toMap();
        list.add(unitMap);
      }
      map['previewList'] = list;
    }
    return json.encode(map);
  }

  @override
  void decode(String content) {
    Map map = json.decode(content);
    int conversationType = map['conversationType'];
    String conversationId = map['conversationId'];
    conversation = Conversation(conversationType, conversationId);
    title = map['title'] ?? '';
    if (map['messageIdList'] != null) {
      List<Object?> sourceList = map['messageIdList'];
      messageIdList = sourceList.map((item) => item.toString()).toList();
    }
    if (map['previewList'] != null) {
      List<MergeMessagePreviewUnit> l = [];
      for (Map<String, dynamic> unitMap in map['previewList']) {
        MergeMessagePreviewUnit unit = MergeMessagePreviewUnit.fromMap(unitMap);
        l.add(unit);
      }
      previewList = l;
    }
    extra = map['extra'] ?? '';
    containerMsgId = map['containerMsgId'] ?? '';
  }

  @override
  String conversationDigest() {
    return '[Merge]';
  }

}