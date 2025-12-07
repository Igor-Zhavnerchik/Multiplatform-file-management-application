import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDatabaseDataSource {
  final SupabaseClient client;

  RemoteDatabaseDataSource({required this.client});

  static const String fileMetadataTable = 'FileStorageMetadata';

  Future<List<Map<String, dynamic>>> getMetadata({
    required String userId,
    required bool getDeleted,
  }) async {
    var fileList = getDeleted
        ? await client
              .from(fileMetadataTable)
              .select()
              .eq('owner_id', userId)
              .not('deleted_at', 'is', null)
        : await client
              .from(fileMetadataTable)
              .select()
              .eq('owner_id', userId)
              .isFilter('deleted_at', null);
    return fileList;
  }

  Future<void> uploadMetadata({required Map<String, dynamic> metadata}) async {
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
