
class MomentMediaType {
  static const int image = 0;
  static const int video = 1;
}

class MomentMedia {
  String url = '';
  int type = 0;
  String snapshotUrl = '';
  int height = 0;
  int width = 0;
  int duration = 0;

  Map toMap() {
    Map map = {
      'url': url,
      'type': type,
      'snapshot_url': snapshotUrl,
      'height': height,
      'width': width,
      'duration': duration
    };
    return map;
  }

  static MomentMedia fromMap(Map map) {
    MomentMedia media = MomentMedia();
    media.url = map['url'] ?? '';
    media.type = map['type'] ?? 0;
    media.snapshotUrl = map['snapshot_url'] ?? '';
    media.height = map['height'] ?? 0;
    media.width = map['width'] ?? 0;
    media.duration = map['duration'] ?? 0;
    return media;
  }
}