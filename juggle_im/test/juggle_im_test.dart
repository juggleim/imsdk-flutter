import 'package:flutter_test/flutter_test.dart';
import 'package:juggle_im/juggle_im.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockJuggleImPlatform
    with MockPlatformInterfaceMixin {

  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {

  test('getPlatformVersion', () async {
    JuggleIm juggleImPlugin = JuggleIm.instance;

    expect(await juggleImPlugin.getPlatformVersion(), '42');
  });
}
