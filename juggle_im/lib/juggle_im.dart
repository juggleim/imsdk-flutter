
import 'package:flutter/services.dart';

class JuggleIm {
  static final JuggleIm _instance = JuggleIm._internal();
  final methodChannel = const MethodChannel('juggle_im');

  JuggleIm._internal();

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

  Future<void> connect(String token) async {
    Map map = {"token": token};
    await methodChannel.invokeMethod('connect', map);
  }

  Future<void> disconnect(bool receivePush) async {
    Map map = {"receivePush": receivePush};
    await methodChannel.invokeMethod('disconnect', map);
  }



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
    }
    return Future.value(null);
  }

  Function(int connectionStatus, int code, String extra)? onConnectionStatusChange;

}
