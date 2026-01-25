import 'dart:async';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDatabaseDataSource {
  final SupabaseClient client;

  RemoteDatabaseDataSource({required this.client});

  static const String fileMetadataTable = 'FileStorageMetadata';

  Future<List<Map<String, dynamic>>> getMetadata({
    required String userId,
  }) async {
    try {
      debugLog('getting files metadata from supabase for user: $userId');
      debugLog('Session: ${client.auth.currentSession}');
      debugLog('User: ${client.auth.currentUser}');
      var fileList = await client
          .from(fileMetadataTable)
          .select()
          .eq('owner_id', userId)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              debugLog('timeout');
              throw TimeoutException('Supabase select() hung');
            },
          );

      debugLog('got ${fileList.length} files');
      return fileList;
    } catch (e) {
      debugLog(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>?> getSingleMetadata({
    required String userId,
    required String fileId,
  }) async {
    final file = await client
        .from(fileMetadataTable)
        .select()
        .eq('owner_id', userId)
        .eq('id', fileId)
        .maybeSingle();
    return file == null ? null : Map<String, dynamic>.from(file);
  }

  Future<void> uploadMetadata({required Map<String, dynamic> metadata}) async {
    debugLog('updating metadata for ${metadata['name']}');
    var res = await client
        .from(fileMetadataTable)
        .upsert(metadata, onConflict: 'id')
        .select()
        .maybeSingle();
    if (res == null || res.isEmpty) {
      throw Exception('failed to upload metadata for ${metadata['path']}');
    }
  }

  Future<void> moveMetadata({
    required String id,
    required String newPath,
  }) async {
    final dbResponse = await client
        .from(fileMetadataTable)
        .update({'path': newPath})
        .eq('id', id)
        .select()
        .maybeSingle();
    if (dbResponse == null) {
      throw Exception('failed to move metadata for $id to $newPath');
    }
  }

  Future<void> deleteMetadata({required String id}) async {
    var dbResponse = await client
        .from(fileMetadataTable)
        .delete()
        .eq('id', id)
        .select()
        .maybeSingle();
    if (dbResponse == null) {
      throw Exception('failed to delete in metadata for $id');
    }
  }
}
