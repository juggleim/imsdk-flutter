
import 'package:flutter/services.dart';
import 'package:juggle_im/internal/content_type_center.dart';
import 'package:juggle_im/model/conversation.dart';
import 'package:juggle_im/model/conversation_info.dart';
import 'package:juggle_im/model/get_conversation_info_option.dart';
import 'package:juggle_im/model/message/text_message.dart';
import 'package:juggle_im/model/result.dart';

class JuggleIm {
  static final JuggleIm _instance = JuggleIm._internal();
  final _methodChannel = const MethodChannel('juggle_im');

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
  void registerMessageType(String contentType, MessageDecoder decoder) {
    ContentTypeCenter.registerMessageType(contentType, decoder);
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

    }
    return Future.value(null);
  }

  void _registerMessages() {
    registerMessageType(TextMessage.getContentType(), (str) {
      TextMessage m = TextMessage();
      m.decode(str);
      return m;
    });
  }

  Function(int connectionStatus, int code, String extra)? onConnectionStatusChange;
  Function()? onDbOpen;
  Function()? onDbClose;

  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoAdd;
  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoUpdate;
  Function(List<ConversationInfo> conversationInfoList)? onConversationInfoDelete;
  Function(int count)? onTotalUnreadMessageCountUpdate;

}
