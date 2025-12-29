import 'dart:io';
import 'dart:typed_data';

import 'package:cross_platform_project/core/converters/bytes_to_stream_converter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteStorageDataSource {
  final SupabaseClient client;
  final BytesToStreamConverter bytesToStreamConverter;

  RemoteStorageDataSource({
    required this.client,
    required this.bytesToStreamConverter,
  });

  static const String userFileStorage = 'FileStorage';

  Future<Stream<List<int>>> downloadFile({required String path}) async {
    final data = await client.storage.from(userFileStorage).download(path);
    return bytesToStreamConverter.convert(data);
  }

  Future<void> uploadFile({required File file, required String path}) async {
    var res = await client.storage
        .from(userFileStorage)
        .upload(path, file, fileOptions: FileOptions(upsert: true));
    if (res.isEmpty) {
      throw Exception('failed to upload to storage for $path');
    }
  }

  Future<void> moveFile({
    required String oldPath,
    required String newPath,
  }) async {
    final storageResponse = await client.storage
        .from(userFileStorage)
        .move(oldPath, newPath);
    if (storageResponse != 'Successfully moved') {
      throw Exception('failed to move in storage from $oldPath to $newPath');
    }
  }

  Future<void> deleteFile({required String path}) async {
    var storageResponse = await client.storage.from(userFileStorage).remove([
      path,
    ]);
    if (storageResponse.isEmpty) {
      throw Exception('failed to delete in storage $path');
    }
  }
}
