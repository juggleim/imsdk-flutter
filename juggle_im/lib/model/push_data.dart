class PushData {
  String? content;
  String? extra;

  Map toMap() {
    return {"content": content, 'extra': extra};
  }
}