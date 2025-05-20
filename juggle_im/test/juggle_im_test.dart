import 'package:flutter_test/flutter_test.dart';
import 'package:juggle_im/juggle_im.dart';
import 'package:juggle_im/juggle_im_platform_interface.dart';
import 'package:juggle_im/juggle_im_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJuggleImPlatform
    with MockPlatformInterfaceMixin
    implements JuggleImPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final JuggleImPlatform initialPlatform = JuggleImPlatform.instance;

  test('$MethodChannelJuggleIm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelJuggleIm>());
  });

  test('getPlatformVersion', () async {
    JuggleIm juggleImPlugin = JuggleIm();
    MockJuggleImPlatform fakePlatform = MockJuggleImPlatform();
    JuggleImPlatform.instance = fakePlatform;

    expect(await juggleImPlugin.getPlatformVersion(), '42');
  });
}
