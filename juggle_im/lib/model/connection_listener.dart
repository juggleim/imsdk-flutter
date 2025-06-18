abstract class ConnectionListener {
  void onConnectionStatusChange(int connectionStatus, int code, String extra);
  void onDbOpen();
  void onDbClose();
}