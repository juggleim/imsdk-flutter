import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'juggle_im_method_channel.dart';

abstract class JuggleImPlatform extends PlatformInterface {
  /// Constructs a JuggleImPlatform.
  JuggleImPlatform() : super(token: _token);

  static final Object _token = Object();

  static JuggleImPlatform _instance = MethodChannelJuggleIm();

  /// The default instance of [JuggleImPlatform] to use.
  ///
  /// Defaults to [MethodChannelJuggleIm].
  static JuggleImPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [JuggleImPlatform] when
  /// they register themselves.
  static set instance(JuggleImPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
