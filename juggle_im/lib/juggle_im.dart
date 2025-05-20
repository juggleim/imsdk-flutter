
import 'juggle_im_platform_interface.dart';

class JuggleIm {
  Future<String?> getPlatformVersion() {
    return JuggleImPlatform.instance.getPlatformVersion();
  }
}
