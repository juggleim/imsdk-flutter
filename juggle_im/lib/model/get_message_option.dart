class GetMessageOption {
  int? startTime;
  int? count;
  List<String>? contentTypes;

  Map toMap() {
    Map map = {'startTime': startTime ?? 0, 'count': count ?? 0};
    if (contentTypes != null) {
      var list = [];
      for (String contentType in contentTypes!) {
        list.add(contentType);
      }
      map['contentTypes'] = list;
    }
    return map;
  }
}