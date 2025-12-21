import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'local_file_id_service_method_channel.dart';

abstract class LocalFileIdServicePlatform extends PlatformInterface {
  /// Constructs a LocalFileIdServicePlatform.
  LocalFileIdServicePlatform() : super(token: _token);

  static final Object _token = Object();

  static LocalFileIdServicePlatform _instance = MethodChannelLocalFileIdService();

  /// The default instance of [LocalFileIdServicePlatform] to use.
  ///
  /// Defaults to [MethodChannelLocalFileIdService].
  static LocalFileIdServicePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LocalFileIdServicePlatform] when
  /// they register themselves.
  static set instance(LocalFileIdServicePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
