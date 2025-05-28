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

typedef DataCallback<T> = void Function(T t, int errorCode);