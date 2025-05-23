
import 'package:flutter/services.dart';
import 'package:juggle_im/internal/content_type_center.dart';
import 'package:juggle_im/model/conversation_info.dart';
import 'package:juggle_im/model/message/text_message.dart';
import 'package:juggle_im/model/message_content.dart';

class JuggleIm {
  static final JuggleIm _instance = JuggleIm._internal();
  final methodChannel = const MethodChannel('juggle_im');

  JuggleIm._internal() {
    _registerMessages();
  }

  static JuggleIm get instance => _instance;

  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<void> setServers(List<String> servers) async {
    Map map = {"list": servers};
    await methodChannel.invokeMethod('setServers', map);
  }

  Future<void> init(String appKey) async {
    Map map = {"appKey": appKey};
    await methodChannel.invokeMethod('init', map);
    methodChannel.setMethodCallHandler(_methodCallHandler);
  }

  //connect
  Future<void> connect(String token) async {
    Map map = {"token": token};
    await methodChannel.invokeMethod('connect', map);
  }

  Future<void> disconnect(bool receivePush) async {
    Map map = {"receivePush": receivePush};
    await methodChannel.invokeMethod('disconnect', map);
  }

  Future<int?> getConnectionStatus() async {
    final status = await methodChannel.invokeMethod<int>('getConnectionStatus');
    return status;
  }

  //conversation
  Future<List<ConversationInfo>?> getConversationInfoList() async {
    List? list = await methodChannel.invokeMethod("getConversationInfoList");
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

  //message
  void registerMessageType(String contentType, MessageDecoder decoder) {
    ContentTypeCenter.registerMessageType(contentType, decoder);
  }


  //internal
  Future<dynamic> _methodCallHandler(MethodCall call) {
    switch (call.method) {
      case "onConnectionStatusChange": {
        Map map = call.arguments;
        int status = map["status"];
        int code = map["code"];
        String extra = map["extra"];
        if (onConnectionStatusChange != null) {
          onConnectionStatusChange!(status, code, extra);
        }
      }
      break;

      case "onDbOpen": {
        if (onDbOpen != null) {
          onDbOpen!();
        }
      }
      break;

      case "onDbClose": {
        if (onDbClose != null) {
          onDbClose!();
        }
      }
      break;
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

}
