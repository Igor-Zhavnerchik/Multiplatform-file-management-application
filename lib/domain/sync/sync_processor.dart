import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/delete_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/create_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/update_handler.dart';

enum SyncAction { create, delete, update }

enum SyncSource { remote, local }

class SyncEvent {
  final SyncAction action;
  final SyncSource source;
  late final int priority;
  final FileEntity? localFile;
  final FileEntity? remoteFile;
  final int retry;

  SyncEvent({
    required this.action,
    required this.source,
    required this.localFile,
    required this.remoteFile,
    this.retry = 0,
  }) {
    priority = switch (action) {
      SyncAction.update => 20,
      SyncAction.delete => 10,
      SyncAction.create => 0,
    };
  }

  SyncEvent copyWith({
    final SyncAction? action,
    final SyncSource? source,
    final FileEntity? localFile,
    final FileEntity? remoteFile,
    final int? retry,
  }) => SyncEvent(
    action: action ?? this.action,
    source: source ?? this.source,
    localFile: localFile ?? this.localFile,

    remoteFile: remoteFile ?? this.remoteFile,
    retry: retry ?? this.retry,
  );
}

class SyncProcessor {
  final UpdateHandler updateHandler;
  final CreateHandler createHandler;
  final DeleteHandler deleteHandler;
  final PriorityQueue<SyncEvent> _queue;

  bool _isProcessing = false;

  final int maxRetry = 3;

  SyncProcessor({
    required this.updateHandler,
    required this.createHandler,
    required this.deleteHandler,
  }) : _queue = PriorityQueue<SyncEvent>(
         (a, b) => a.priority.compareTo(b.priority),
       );

  void addEvent({required SyncEvent event}) {
    _queue.add(event);
    debugLog(
      'adding ${event.action.name} event for ${event.remoteFile?.name ?? event.localFile!.name}',
    );
    _process();
  }

  Future<void> _process() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final event = _queue.removeFirst();
      final result = await _handleEvent(event);
      if (result.isFailure) {
        print(
          'failed to execute event.\n'
          'action: ${event.action}\n'
          'source: ${event.source}\n'
          'file name: ${event.remoteFile?.name ?? event.localFile!.name}\n'
          'error: ${(result as Failure).error}\n'
          'source: ${(result).source}\n',
        );
      }
    }

    _isProcessing = false;
  }

  Future<Result<void>> _handleEvent(SyncEvent event) async {
    Result<void> result = switch (event.action) {
      SyncAction.update => await updateHandler.handle(event),
      SyncAction.delete => await deleteHandler.handle(event),
      SyncAction.create => await createHandler.handle(event),
    };
    if (result.isFailure) {
      if (event.retry >= maxRetry) {
        return Failure("Max Retry Attempts Reached");
      }
      _queue.add(event.copyWith(retry: event.retry + 1));
    }
    return result;
  }
}
