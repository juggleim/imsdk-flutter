class GetMomentOption {
  int startTime = 0;
  int count = 10;
  int direction = 0;

  Map toMap() {
    return {
      'startTime': startTime,
      'count': count,
      'direction': direction,
    };
  }
}