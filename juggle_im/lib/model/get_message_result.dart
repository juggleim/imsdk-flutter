import 'package:juggle_im/model/result.dart';

class GetMessageResult<T> extends Result<T> {
  int timestamp = 0;
  bool hasMore = true;
}