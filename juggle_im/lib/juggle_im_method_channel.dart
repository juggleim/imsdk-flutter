import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'juggle_im_platform_interface.dart';

/// An implementation of [JuggleImPlatform] that uses method channels.
class MethodChannelJuggleIm extends JuggleImPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('juggle_im');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
