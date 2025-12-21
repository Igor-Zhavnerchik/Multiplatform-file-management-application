import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'local_file_id_service_platform_interface.dart';

/// An implementation of [LocalFileIdServicePlatform] that uses method channels.
class MethodChannelLocalFileIdService extends LocalFileIdServicePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('local_file_id_service');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
