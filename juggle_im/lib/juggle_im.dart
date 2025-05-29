

import 'package:flutter/services.dart';
import 'package:juggle_im/internal/content_type_center.dart';
import 'package:juggle_im/juggle_const.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_info.dart';
import 'package:juggle_im/model/get_conversation_info_option.dart';
import 'package:juggle_im/model/get_message_option.dart';
import 'package:juggle_im/model/get_message_result.dart';
import 'package:juggle_im/model/group_message_read_detail.dart';
import 'package:juggle_im/model/group_message_read_info.dart';
import 'package:juggle_im/model/media_message_content.dart';
import 'package:juggle_im/model/message.dart';
import 'package:juggle_im/model/message/file_message.dart';
import 'package:juggle_im/model/message/image_message.dart';
import 'package:juggle_im/model/message/recall_info_message.dart';
import 'package:juggle_im/model/message/text_message.dart';
import 'package:juggle_im/model/message/video_message.dart';
import 'package:juggle_im/model/message/voice_message.dart';
import 'package:juggle_im/model/message_content.dart';
import 'package:juggle_im/model/message_reaction.dart';
import 'package:juggle_im/model/result.dart';
import 'package:juggle_im/model/send_message_option.dart';
import 'package:juggle_im/model/user_info.dart';

class JuggleIm {
  static final JuggleIm _instance = JuggleIm._internal();
  final _methodChannel = const MethodChannel('juggle_im');
  final Map<int, DataCallback<Message>> _sendMessageCallbackMap = {};
  final Map<int, SendMessageProgressCallback> _sendMessageProgressCallbackMap = {};

  JuggleIm._internal() {
    _registerMessages();
  }

  static JuggleIm get instance => _instance;

  Future<String?> getPlatformVersion() async {
    final version = await _methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> setServers(List<String> servers) async {
    Map map = {"list": servers};
    await _methodChannel.invokeMethod('setServers', map);
  }

  Future<void> init(String appKey) async {
    Map map = {"appKey": appKey};
    await _methodChannel.invokeMethod('init', map);
    _methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  //connect
  Future<void> connect(String token) async {
    Map map = {"token": token};
    await _methodChannel.invokeMethod('connect', map);
  }

  Future<void> disconnect(bool receivePush) async {
    Map map = {"receivePush": receivePush};
    await _methodChannel.invokeMethod('disconnect', map);
  }

  Future<int?> getConnectionStatus() async {
    final status = await _methodChannel.invokeMethod<int>('getConnectionStatus');
    return status;
  }

  //conversation
  Future<List<ConversationInfo>?> getConversationInfoList() async {
    List? list = await _methodChannel.invokeMethod("getConversationInfoList");
    if (list == null) {
      return [];
    }
    List<ConversationInfo> result = [];
    for (Map map in list) {
      ConversationInfo c = ConversationInfo.fromMap(map);
      result.add(c);
    }
    return result;
  }

  Future<List<ConversationInfo>?> getConversationInfoListByOption(GetConversationInfoOption option) async {
    Map map = {'count': option.count??0, 'timestamp': option.timestamp??0, 'direction': option.direction??0};
    if (option.conversationTypes != null) {
      map['conversationTypes'] = option.conversationTypes;
    }
    if (option.tagId != null) {
      map['tagId'] = option.tagId;
    }
    List? list = await _methodChannel.invokeListMethod('getConversationInfoListByOption', map);
    if (list == null) {
      return [];
    }
    List<ConversationInfo> result = [];
    for (Map map in list) {
      ConversationInfo c = ConversationInfo.fromMap(map);
      result.add(c);
    }
    return result;
  }

  Future<ConversationInfo?> getConversationInfo(Conversation conversation) async {
    Map map = conversation.toMap();
    Map result = await _methodChannel.invokeMethod('getConversationInfo', map);
    ConversationInfo info = ConversationInfo.fromMap(result);
    return info;
  }

  Future<Result<void>?> deleteConversationInfo(Conversation conversation) async {
    Map map = conversation.toMap();
    int errorCode = await _methodChannel.invokeMethod('deleteConversationInfo', map);
    var result = Result<void>();
    result.errorCode = errorCode;
    return result;
  }

  Future<void> setDraft(Conversation conversation, String draft) async {
    Map conversationMap = conversation.toMap();
    Map map = {'conversation': conversationMap, 'draft': draft};
    await _methodChannel.invokeMethod('setDraft', map);
  }

  Future<Result<ConversationInfo>?> createConversationInfo(Conversation conversation) async {
    Map map = conversation.toMap();
    Map resultMap = await _methodChannel.invokeMethod('createConversationInfo', map);
    var result =  Result<ConversationInfo>();
    Map? conversationInfoMap = resultMap['conversationInfo'];
    if (conversationInfoMap != null) {
      result.t = ConversationInfo.fromMap(conversationInfoMap);
    }

    int? errorCode = resultMap["errorCode"];
    if (errorCode != null) {
      result.errorCode = errorCode;
    }
    return result;
  }

  Future<int?> getTotalUnreadCount([List<int>? conversationTypes]) async {
    var map = {};
    if (conversationTypes != null) {
      map['conversationTypes'] = conversationTypes;
    }
    return await _methodChannel.invokeMethod('getTotalUnreadCount', map);
  }

  Future<Result<void>?> clearUnreadCount(Conversation conversation) async {
    Map map = conversation.toMap();
    int resultCode = await _methodChannel.invokeMethod('clearUnreadCount', map);
    var result = Result<void>();
    result.errorCode = resultCode;
    return result;
  }

  Future<Result<void>?> clearTotalUnreadCount() async {
    int resultCode = await _methodChannel.invokeMethod('clearTotalUnreadCount');
    var result = Result<void>();
    result.errorCode = resultCode;
    return result;
  }

  Future<Result<void>?> setMute(Conversation conversation, bool isMute) async {
    Map conversationMap = conversation.toMap();
    Map map = {"conversation": conversationMap, "isMute": isMute};
    int code = await _methodChannel.invokeMethod('setMute', map);
    var result = Result<void>();
    result.errorCode = code;
    return result;
  }

  Future<Result<void>?> setTop(Conversation conversation, bool isTop) async {
    Map conversationMap = conversation.toMap();
    Map map = {"conversation": conversationMap, "isTop": isTop};
    int code = await _methodChannel.invokeMethod('setTop', map);
    var result = Result<void>();
    result.errorCode = code;
    return result;
  }

  Future<Result<void>?> setUnread(Conversation conversation) async {
    Map map = conversation.toMap();
    int resultCode = await _methodChannel.invokeMethod('setUnread', map);
    var result = Result<void>();
    result.errorCode = resultCode;
    return result;
  }

  //message
  void registerMessageType(MessageFactory factory) {
    ContentTypeCenter.registerMessageType(factory);
  }

  Future<Message?> sendMessage(MessageContent content, Conversation conversation, DataCallback<Message> callback, [SendMessageOption? option]) async {
    Map map = {'contentType': content.getContentType(), "content": content.encode(), "conversation": conversation.toMap()};
    if (option != null) {
      map['option'] = option.toMap();
    }
    Map resultMap = await _methodChannel.invokeMethod('sendMessage', map);
    Message message = Message.fromMap(resultMap);
    _sendMessageCallbackMap[message.clientMsgNo!] = callback;
    return message;
  }

  Future<Message?> sendMediaMessage(MediaMessageContent content, Conversation conversation, DataCallback<Message> callback, SendMessageProgressCallback progressCallback, [SendMessageOption? option]) async {
    Map map = {'contentType': content.getContentType(), "content": content.encode(), "conversation": conversation.toMap()};
    if (option != null) {
      map['option'] = option.toMap();
    }
    Map resultMap = await _methodChannel.invokeMethod('sendMediaMessage', map);
    Message message = Message.fromMap(resultMap);
    _sendMessageCallbackMap[message.clientMsgNo!] = callback;
    _sendMessageProgressCallbackMap[message.clientMsgNo!] = progressCallback;
    return message;
  }

  Future<GetMessageResult<List<Message>>?> getMessages(Conversation conversation, int direction, GetMessageOption option) async {
    Map map = {'conversation': conversation.toMap(), 'direction': direction, 'option': option.toMap()};
    Map resultMap = await _methodChannel.invokeMethod('getMessages', map);
    var result = GetMessageResult<List<Message>>();
    result.errorCode = resultMap['errorCode'] ?? 0;
    result.hasMore = resultMap['hasMore'] ?? true;
    result.timestamp = resultMap['timestamp'];
    List<Message> list = [];
    if (resultMap['messages'] != null) {
      for (Map messageMap in resultMap['messages']) {
        Message message = Message.fromMap(messageMap);
        list.add(message);
      }
    }
    result.t = list;

    return result;
  }

  Future<int?> deleteMessagesByClientMsgNoList(Conversation conversation, List<int> clientMsgNoList, [bool? forAllUsers]) async {
    Map map = {'conversation': conversation.toMap(), 'clientMsgNoList': clientMsgNoList};
    if (forAllUsers != null) {
      map['forAllUsers'] = forAllUsers;
    }
    int result = await _methodChannel.invokeMethod('deleteMessagesByClientMsgNoList', map);
    return result;
  }

  Future<int?> deleteMessagesByMessageIdList(Conversation conversation, List<String> messageIdList, [bool? forAllUsers]) async {
    Map map = {'conversation': conversation.toMap(), 'messageIdList': messageIdList};
    if (forAllUsers != null) {
      map['forAllUsers'] = forAllUsers;
    }
    int result = await _methodChannel.invokeMethod('deleteMessagesByMessageIdList', map);
    return result;
  }

  Future<Result<Message>?> recallMessage(String messageId, [Map? extra]) async {
    Map map = {'messageId': messageId};
    if (extra != null) {
      map['extra'] = extra;
    }
    Map resultMap = await _methodChannel.invokeMethod('recallMessage', map);
    var result = Result<Message>();
    result.errorCode = resultMap['errorCode'];
    if (resultMap['message'] != null) {
      result.t = Message.fromMap(resultMap['message']);
    }
    return result;
  }

  Future<int?> clearMessages(Conversation conversation, int startTime, [bool? forAllUsers]) async {
    Map map = {'conversation': conversation.toMap(), 'startTime': startTime};
    if (forAllUsers != null) {
      map['forAllUsers'] = forAllUsers;
    }
    return await _methodChannel.invokeMethod('clearMessages', map);
  }

  Future<List<Message>?> getMessagesByMessageIdList(List<String> messageIdList) async {
    Map map = {'messageIdList': messageIdList};
    List resultList = await _methodChannel.invokeMethod('getMessagesByMessageIdList', map);
    List<Message> messageList = [];
    for (Map messageMap in resultList) {
      Message message = Message.fromMap(messageMap);
      messageList.add(message);
    }
    return messageList;
  }

  Future<List<Message>?> getMessagesByClientMsgNoList(List<int> clientMsgNoList) async {
    Map map = {'clientMsgNoList': clientMsgNoList};
    List resultList = await _methodChannel.invokeMethod('getMessagesByClientMsgNoList', map);
    List<Message> messageList = [];
    for (Map messageMap in resultList) {
      Message message = Message.fromMap(messageMap);
      messageList.add(message);
    }
    return messageList;
  }

  Future<int?> sendReadReceipt(Conversation conversation, List<String> messageIdList) async {
    Map map = {'conversation': conversation.toMap(), 'messageIdList': messageIdList};
    return await _methodChannel.invokeMethod('sendReadReceipt', map);
  }

  Future<Result<GroupMessageReadDetail>?> getGroupMessageReadDetail(String messageId, Conversation conversation) async {
    Map map = {'conversation': conversation.toMap(), 'messageId': messageId};
    Map resultMap = await _methodChannel.invokeMethod('getGroupMessageReadDetail', map);
    var result = Result<GroupMessageReadDetail>();
    result.errorCode = resultMap['errorCode'];
    if (result.errorCode == 0) {
      GroupMessageReadDetail detail = GroupMessageReadDetail();
      List readMembersMapList = resultMap['readMembers'];
      List unreadMembersMapList = resultMap['unreadMembers'];
      List<UserInfo> readMembers = [];
      List<UserInfo> unreadMembers = [];
      for (Map readMemberMap in readMembersMapList) {
        UserInfo userInfo = UserInfo.fromMap(readMemberMap);
        readMembers.add(userInfo);
      }
      for (Map unreadMemberMap in unreadMembersMapList) {
        UserInfo userInfo = UserInfo.fromMap(unreadMemberMap);
        unreadMembers.add(userInfo);
      }
      detail.readMembers = readMembers;
      detail.unreadMembers = unreadMembers;
      result.t = detail;
    }
    return result;
  }

  Future<Result<List<Message>>?> getMergedMessageList(String messageId) async {
    Map map = {'messageId': messageId};
    Map resultMap = await _methodChannel.invokeMethod('getMergedMessageList', map);
    var result = Result<List<Message>>();
    result.errorCode = resultMap['errorCode'];
    if (result.errorCode == 0) {
      List messageMapList = resultMap['messages'];
      List<Message> messages = [];
      for (Map messageMap in messageMapList) {
        Message message = Message.fromMap(messageMap);
        messages.add(message);
      }
      result.t = messages;
    }
    return result;
  }

  Future<GetMessageResult<List<Message>>?> getMentionMessages(Conversation conversation, int count, int timestamp, int direction) async {
    Map map = {'conversation': conversation.toMap(), 'count': count, 'timestamp': timestamp, 'direction': direction};
    Map resultMap = await _methodChannel.invokeMethod('getMentionMessages', map);
    var result = GetMessageResult<List<Message>>();
    result.errorCode = resultMap['errorcode'];
    if (result.errorCode == 0) {
      result.hasMore = !resultMap['isFinished'];
      List messageMapList = resultMap['messages'];
      List<Message> messages = [];
      for (Map messageMap in messageMapList) {
        Message message = Message.fromMap(messageMap);
        messages.add(message);
      }
      result.t = messages;
    }
    return result;
  }

  Future<int?> addMessageReaction(String messageId, Conversation conversation, String reactionId) async {
    Map map = {'messageId': messageId, 'conversation': conversation.toMap(), 'reactionId': reactionId};
    return await _methodChannel.invokeMethod('addMessageReaction', map);
  }

  Future<int?> removeMessageReaction(String messageId, Conversation conversation, String reactionId) async {
    Map map = {'messageId': messageId, 'conversation': conversation.toMap(), 'reactionId': reactionId};
    return await _methodChannel.invokeMethod('removeMessageReaction', map);
  }

  Future<Result<List<MessageReaction>>?> getMessagesReaction(List<String> messageIdList, Conversation conversation) async {
    Map map = {'messageIdList': messageIdList, 'conversation': conversation.toMap()};
    Map resultMap = await _methodChannel.invokeMethod('getMessagesReaction', map);
    var result = Result<List<MessageReaction>>();
    result.errorCode = resultMap['errorCode'];
    if (result.errorCode == 0) {
      List mapList = resultMap['reactionList'];
      List<MessageReaction> reactionList = [];
      for (Map reactionMap in mapList) {
        MessageReaction reaction = MessageReaction.fromMap(reactionMap);
        reactionList.add(reaction);
      }
      result.t = reactionList;
    }
    return result;
  }

  Future<Result<Message>?> updateMessage(String messageId, MessageContent content, Conversation conversation) async {
    Map map = {'contentType': content.getContentType(), 'messageId': messageId, "content": content.encode(), "conversation": conversation.toMap()};
    Map resultMap = await _methodChannel.invokeMethod('updateMessage', map);
    var result = Result<Message>();
    result.errorCode = resultMap['errorCode'];
    if (result.errorCode == 0) {
      Message message = Message.fromMap(resultMap['message']);
      result.t = message;
    }
    return result;
  }

  //internal
  Future<dynamic> _methodCallHandler(MethodCall call) {
    switch (call.method) {
      case "onConnectionStatusChange":
        Map map = call.arguments;
        int status = map["status"];
        int code = map["code"];
        String extra = map["extra"];
        if (onConnectionStatusChange != null) {
          onConnectionStatusChange!(status, code, extra);
        }

      case "onDbOpen":
        if (onDbOpen != null) {
          onDbOpen!();
        }

      case "onDbClose":
        if (onDbClose != null) {
          onDbClose!();
        }

      case "onConversationInfoAdd":
        Map map = call.arguments;
        List<ConversationInfo> list = [];
        for (Map conversationInfoMap in map['conversationInfoList']) {
          ConversationInfo info = ConversationInfo.fromMap(conversationInfoMap);
          list.add(info);
        }
        if (onConversationInfoAdd != null) {
          onConversationInfoAdd!(list);
        }

      case "onConversationInfoUpdate":
        Map map = call.arguments;
        List<ConversationInfo> list = [];
        for (Map conversationInfoMap in map['conversationInfoList']) {
          ConversationInfo info = ConversationInfo.fromMap(conversationInfoMap);
          list.add(info);
        }
        if (onConversationInfoUpdate != null) {
          onConversationInfoUpdate!(list);
        }

      case "onConversationInfoDelete":
        Map map = call.arguments;
        List<ConversationInfo> list = [];
        for (Map conversationInfoMap in map['conversationInfoList']) {
          ConversationInfo info = ConversationInfo.fromMap(conversationInfoMap);
          list.add(info);
        }
        if (onConversationInfoDelete != null) {
          onConversationInfoDelete!(list);
        }

      case 'onTotalUnreadMessageCountUpdate':
        Map map = call.arguments;
        int count = map['count'];
        if (onTotalUnreadMessageCountUpdate != null) {
          onTotalUnreadMessageCountUpdate!(count);
        }

      case 'onMessageSendSuccess':
        Map map = call.arguments;
        Message message = Message.fromMap(map['message']);
        int clientMsgNo = message.clientMsgNo!;
        _sendMessageCallbackMap[clientMsgNo]!(message, 0);
        _sendMessageCallbackMap.remove(clientMsgNo);
        _sendMessageProgressCallbackMap.remove(clientMsgNo);

      case 'onMessageSendError':
        Map map = call.arguments;
        int errorCode = map['errorCode'];
        Message message = Message.fromMap(map['message']);
        int clientMsgNo = message.clientMsgNo!;
        _sendMessageCallbackMap[clientMsgNo]!(message, errorCode);
        _sendMessageCallbackMap.remove(clientMsgNo);
        _sendMessageProgressCallbackMap.remove(clientMsgNo);

      case 'onMessageProgress':
        Map map = call.arguments;
        int progress = map['progress'];
        Message message = Message.fromMap(map['message']);
        int clientMsgNo = message.clientMsgNo!;
        _sendMessageProgressCallbackMap[clientMsgNo]!(message, progress);

      case 'onMessageReceive':
        Map map = call.arguments;
        Message message = Message.fromMap(map);
        if (onMessageReceive != null) {
          onMessageReceive!(message);
        }

      case 'onMessageRecall':
        Map map = call.arguments;
        Message message = Message.fromMap(map);
        if (onMessageRecall != null) {
          onMessageRecall!(message);
        }

      case 'onMessageDelete':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        if (onMessageDelete != null) {
          onMessageDelete!(conversation, map['clientMsgNoList']);
        }

      case 'onMessageClear':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        if (onMessageClear != null) {
          onMessageClear!(conversation, map['timestamp'], map['senderId']);
        }

      case 'onMessageUpdate':
        Map map = call.arguments;
        Message message = Message.fromMap(map);
        if (onMessageUpdate != null) {
          onMessageUpdate!(message);
        }

      case 'onMessageReactionAdd':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        MessageReaction reaction = MessageReaction.fromMap(map['reaction']);
        if (onMessageReactionAdd != null) {
          onMessageReactionAdd!(conversation, reaction);
        }

      case 'onMessageReactionRemove':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        MessageReaction reaction = MessageReaction.fromMap(map['reaction']);
        if (onMessageReactionRemove != null) {
          onMessageReactionRemove!(conversation, reaction);
        }

      case 'onMessagesRead':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        if (onMessagesRead != null) {
          onMessagesRead!(conversation, map['messageIdList']);
        }

      case 'onGroupMessagesRead':
        Map map = call.arguments;
        Conversation conversation = Conversation.fromMap(map['conversation']);
        Map<String, Map> messagesMap = map['messages'];
        Map<String, GroupMessageReadInfo> messages = {};
        messagesMap.forEach((messageId, infoMap) {
          messages[messageId] = GroupMessageReadInfo.fromMap(infoMap);
        });
        if (onGroupMessagesRead != null) {
          onGroupMessagesRead!(conversation, messages);
        }

    }
    return Future.value(null);
  }

  void _registerMessages() {
    registerMessageType(() => TextMessage());
    registerMessageType(() => ImageMessage());
    registerMessageType(() => FileMessage());
    registerMessageType(() => RecallInfoMessage());
    registerMessageType(() => VideoMessage());
    registerMessageType(() => VoiceMessage());
  }

  Function(int connectionStatus, int code, String extra)? onConnectionStatusChange;
  Function()? onDbOpen;
  Function()? onDbClose;

  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoAdd;
  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoUpdate;
  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoDelete;
  Function(int count)? onTotalUnreadMessageCountUpdate;

  Function(Message message)? onMessageReceive;
  Function(Message message)? onMessageRecall;
  Function(Conversation conversation, List<int> clientMsgNoList)? onMessageDelete;
  Function(Conversation conversation, int timestamp, String? senderId)? onMessageClear;
  Function(Message message)? onMessageUpdate;
  Function(Conversation conversation, MessageReaction reaction)? onMessageReactionAdd;
  Function(Conversation conversation, MessageReaction reaction)? onMessageReactionRemove;
  Function(Conversation conversation, List<String> messageIdList)? onMessagesRead;
  Function(Conversation conversation, Map<String, GroupMessageReadInfo> messages)? onGroupMessagesRead;


}
