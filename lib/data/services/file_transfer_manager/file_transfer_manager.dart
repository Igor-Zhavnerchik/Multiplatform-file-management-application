import 'dart:collection';
import 'dart:math' as math;

import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/common/utility/result.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/handlers/download_handler.dart';
import 'package:cross_platform_project/data/services/file_transfer_manager/handlers/upload_handler.dart';

enum TransferAction { download, upload }

class TransferEvent {
  final TransferAction action;
  final FileModel payload;
  final int retry;

  TransferEvent({required this.action, required this.payload, this.retry = 0});

  TransferEvent copyWith({
    TransferAction? action,
    FileModel? payload,
    int? retry,
  }) {
    return TransferEvent(
      action: action ?? this.action,
      payload: payload ?? this.payload,
      retry: retry ?? this.retry,
    );
  }
}

class FileTransferManager {
  final DownloadHandler downloadHandler;
  final UploadHandler uploadHandler;

  final Queue<TransferEvent> pendingQueue = Queue<TransferEvent>();

  FileTransferManager({
    required this.downloadHandler,
    required this.uploadHandler,
  });

  void addTransferEvent({
    required TransferAction action,
    required FileModel payload,
    int retry = 0,
  }) {
    pendingQueue.add(
      TransferEvent(action: action, payload: payload, retry: retry),
    );
    _executeTransfer();
  }

  final int maxRetry = 5;
  bool _executing = false;
  void _executeTransfer() async {
    if (_executing) {
      return;
    }
    _executing = true;
    while (pendingQueue.isNotEmpty) {
      final event = pendingQueue.removeFirst();
      final model = event.payload;
      final Result<void> result = switch (event.action) {
        TransferAction.download => await downloadHandler.handle(model: model),

        TransferAction.upload => await uploadHandler.handle(model: model),
      };
      result.when(
        success: (_) => debugLog(
          'successfully resolved ${event.action.name} event for ${model.name}',
        ),
        failure: (msg, err, source) {
          debugLog('$msg error: $err source: $source');
          if (event.retry >= maxRetry) {
            debugLog('max retry attempts reached');
          } else {
            Future.delayed(
              Duration(seconds: math.min(60, math.pow(2, event.retry).toInt())),
              () {
                addTransferEvent(
                  action: event.action,
                  payload: event.payload,
                  retry: event.retry + 1,
                );
              },
            );
          }
        },
      );
    }
    _executing = false;
  }
}
