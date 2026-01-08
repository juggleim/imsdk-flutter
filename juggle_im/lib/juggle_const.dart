import 'package:flutter/foundation.dart';
import 'package:juggle_im/model/message.dart';

class ConnectionStatus {
  static const int idle = 0;
  static const int connected = 1;
  static const int disconnected = 2;
  static const int connecting = 3;
  static const int failure = 4;
}

class PullDirection {
  static const int newer = 0;
  static const int older = 1;
}

class LogLevel {
  static const int none = 0;
  static const int fatal = 1;
  static const int error = 2;
  static const int warning = 3;
  static const int info = 4;
  static const int debug = 5;
  static const int verbose = 6;
}

class Utility {
  static String removePrivatePrefix(String path) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return path;
    }
    const String privatePrefix = "/private/";
    if (path.startsWith(privatePrefix)) {
      return path.replaceFirst(privatePrefix, "/");
    }
    return path;
  }
}

typedef DataCallback<T> = void Function(T t, int errorCode);
typedef SendMessageProgressCallback = void Function(Message message, int progress);