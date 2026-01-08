import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/delete_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/load_handler.dart';
import 'package:cross_platform_project/domain/sync/sync_handlers/update_handler.dart';

enum SyncAction { create, load, delete, update }

enum SyncSource { remote, local }

class SyncEvent {
  final SyncAction action;
  final SyncSource source;
  late final int priority;
  final FileModel payload;
  final int retry;

  SyncEvent({
    required this.action,
    required this.source,
    required this.payload,
    this.retry = 0,
  }) {
    priority = switch (action) {
      SyncAction.load => 30,
      SyncAction.update => 20,
      SyncAction.delete => 10,
      SyncAction.create => 0,
    };
  }

  SyncEvent copyWith({
    final SyncAction? action,
    final SyncSource? source,
    final FileModel? payload,
    final int? retry,
  }) => SyncEvent(
    action: action ?? this.action,
    source: source ?? this.source,
    payload: payload ?? this.payload,
    retry: retry ?? this.retry,
  );
}

class SyncProcessor {
  final UpdateHandler updateHandler;
  final LoadHandler loadHandler;
  final DeleteHandler deleteHandler;
  final PriorityQueue<SyncEvent> _queue;
  Completer<void>? _syncCompleter;

  bool _isProcessing = false;

  //FIXME to 3
  final int maxRetry = 0;

  SyncProcessor({
    required this.updateHandler,
    required this.loadHandler,
    required this.deleteHandler,
  }) : _queue = PriorityQueue<SyncEvent>(
         (a, b) => a.priority.compareTo(b.priority),
       );

  Future<void> waitSyncCompletetion() {
    return _isProcessing ? _syncCompleter!.future : Future.value();
  }

  void addEvent({required SyncEvent event}) {
    _queue.add(event);
    debugLog('adding ${event.action.name} event for ${event.payload.name}');
    _process();
  }

  Future<void> _process() async {
    if (_isProcessing) return;
    _isProcessing = true;
    _syncCompleter = Completer<void>();

    while (_queue.isNotEmpty) {
      final event = _queue.removeFirst();
      final result = await _handleEvent(event);
      if (result.isFailure) {
        print(
          'failed to execute event.\n'
          'action: ${event.action}\n'
          'source: ${event.source}\n'
          'file name: ${event.payload.name}\n'
          'error: ${(result as Failure).error}\n'
          'source: ${(result).source}\n',
        );
      }
    }

    _syncCompleter!.complete();
    _isProcessing = false;
  }

  Future<Result<void>> _handleEvent(SyncEvent event) async {
    Result<void> result = switch (event.action) {
      SyncAction.update => await updateHandler.handle(event),
      SyncAction.load => await loadHandler.handle(event),
      SyncAction.delete => await deleteHandler.handle(event),
      SyncAction.create => await loadHandler.handle(event),
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
