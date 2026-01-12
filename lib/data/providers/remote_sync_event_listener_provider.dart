import 'package:cross_platform_project/core/providers/supabase_client_provider.dart';
import 'package:cross_platform_project/data/data_source/remote/remote_sync_event_listener.dart';
import 'package:cross_platform_project/data/models/providers/file_model_mapper_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteSyncEventListenerProvider = Provider<RemoteSyncEventListener>((
  ref,
) {
  final client = ref.watch(supabaseClientProvider);
  final mapper = ref.watch(fileModelMapperProvider);
  return RemoteSyncEventListener(client: client, mapper: mapper);
});
