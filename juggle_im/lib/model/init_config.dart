class LogConfig {
  int? consoleLevel;
  int? writeLevel;

  Map toMap() {
    Map map = {};
    if (consoleLevel != null) {
      map['consoleLevel'] = consoleLevel;
    }
    if (writeLevel != null) {
      map['writeLevel'] = writeLevel;
    }
    return map;
  }
}

class XMConfig {
  String appId = '';
  String appKey = '';

  Map toMap() {
    Map map = {'appId': appId, 'appKey': appKey};
    return map;
  }

}

class HWConfig {
  String appId = '';

  Map toMap() {
    Map map = {'appId': appId};
    return map;
  }
}

class VIVOConfig {
}

class OPPOConfig {
  String appKey = '';
  String appSecret = '';

  Map toMap() {
    Map map = {'appKey': appKey, 'appSecret': appSecret};
    return map;
  }
}

class JGConfig {
}

class PushConfig {
  XMConfig? xmConfig;
  HWConfig? hwConfig;
  VIVOConfig? vivoConfig;
  OPPOConfig? oppoConfig;
  JGConfig? jgConfig;

  Map toMap() {
    Map map = {};
    if (xmConfig != null) {
      map['xmConfig'] = xmConfig!.toMap();
    }
    if (hwConfig != null) {
      map['hwConfig'] = hwConfig!.toMap();
    }
    if (vivoConfig != null) {
      map['vivoConfig'] = '';
    }
    if (oppoConfig != null) {
      map['oppoConfig'] = oppoConfig!.toMap();
    }
    if (jgConfig != null) {
      map['jgConfig'] = '';
    }
    return map;
  }
}

class InitConfig {
  LogConfig? logConfig;
  PushConfig? pushConfig;

  Map toMap() {
    Map map = {};
    if (logConfig != null) {
      map['logConfig'] = logConfig!.toMap();
    }
    if (pushConfig != null) {
      map['pushConfig'] = pushConfig!.toMap();
    }
    return map;
  }
}