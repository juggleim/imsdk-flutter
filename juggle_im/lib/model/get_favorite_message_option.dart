class GetFavoriteMessageOption {
  String offset = '';
  int count = 1;

  Map toMap() {
    return {'offset': offset, 'count': count};
  }
}