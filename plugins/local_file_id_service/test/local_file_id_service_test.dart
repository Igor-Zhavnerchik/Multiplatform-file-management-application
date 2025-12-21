import 'package:flutter_test/flutter_test.dart';
import 'package:local_file_id_service/local_file_id_service.dart';
import 'package:local_file_id_service/local_file_id_service_platform_interface.dart';
import 'package:local_file_id_service/local_file_id_service_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLocalFileIdServicePlatform
    with MockPlatformInterfaceMixin
    implements LocalFileIdServicePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LocalFileIdServicePlatform initialPlatform = LocalFileIdServicePlatform.instance;

  test('$MethodChannelLocalFileIdService is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLocalFileIdService>());
  });

  test('getPlatformVersion', () async {
    LocalFileIdService localFileIdServicePlugin = LocalFileIdService();
    MockLocalFileIdServicePlatform fakePlatform = MockLocalFileIdServicePlatform();
    LocalFileIdServicePlatform.instance = fakePlatform;

    expect(await localFileIdServicePlugin.getPlatformVersion(), '42');
  });
}
