import 'package:flutter/services.dart';

class LocalFileIdServicePlugin {
  static const MethodChannel _channel = MethodChannel('local_file_id_service');

  static Future<String> getFileId(String path) async {
    final result = await _channel.invokeMethod<String>('getFileId', {
      'path': path,
    });

    if (result == null) {
      throw StateError('Failed to get fileId for $path');
    }

    return result;
  }
}
