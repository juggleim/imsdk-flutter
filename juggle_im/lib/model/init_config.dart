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

class PushConfig {

}

class InitConfig {
  LogConfig? logConfig;
  PushConfig? pushConfig;

  Map toMap() {
    Map map = {};
    if (logConfig != null) {
      map['logConfig'] = logConfig!.toMap();
    }
    return map;
  }
}