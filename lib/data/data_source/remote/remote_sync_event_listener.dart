import 'dart:async';

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/sync/sync_processor.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteSyncEventListener {
  final SupabaseClient client;
  final FileModelMapper mapper;
  RemoteSyncEventListener({required this.client, required this.mapper});

  StreamController<SyncEvent> _controller =
      StreamController<SyncEvent>.broadcast();
  RealtimeChannel? _channel;

  Stream<SyncEvent> get syncEventStream => _controller.stream;

  void listenRemoteEvents() {
    debugLog('listening to remote sync events');
    _channel = client
        .channel('public:FileStorageMetadata')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'FileStorageMetadata',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'owner_id',
            value: client.auth.currentSession!.user.id,
          ),
          callback: (payload) {
            try {
              final event = SyncEvent(
                action: switch (payload.eventType) {
                  PostgresChangeEvent.insert => SyncAction.create,
                  PostgresChangeEvent.update => SyncAction.update,
                  PostgresChangeEvent.delete => SyncAction.delete,
                  _ => throw Exception(
                    'remote event should have explicit type',
                  ),
                },
                source: SyncSource.remote,
                localFile: null,
                remoteFile: mapper.toEntity(
                  mapper.fromMetadata(
                    metadata: payload.newRecord.isNotEmpty
                        ? payload.newRecord
                        : payload.oldRecord,
                  ),
                ),
              );
              _controller.add(event);
              debugLog('emitted remote sync ${payload.eventType} event ');
            } catch (e) {
              debugLog(
                'failed to process remote ${payload.eventType} event error: $e',
              );
            }
          },
        )
        .subscribe();
  }

  void dispose() {
    _channel?.unsubscribe();
    if (_channel != null) {
      client.removeChannel(_channel!);
    }
    _controller.close();
  }
}
