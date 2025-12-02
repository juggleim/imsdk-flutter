class GetMomentCommentOption {
  String momentId = '';
  int startTime = 0;
  int count = 10;
  int direction = 0;

  Map toMap() {
    return {
      'momentId': momentId,
      'startTime': startTime,
      'count': count,
      'direction': direction,
    };
  }
}