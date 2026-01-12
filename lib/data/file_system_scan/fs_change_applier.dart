import 'package:collection/collection.dart';
import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/storage_path_service.dart';
import 'package:cross_platform_project/data/data_source/local/local_data_source.dart';
import 'package:cross_platform_project/data/file_system_scan/file_system_scanner.dart';
import 'package:cross_platform_project/data/file_system_scan/reconciler.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/data/repositories/requests/update_file_request.dart';
import 'package:cross_platform_project/domain/repositories/storage_repository.dart';

class FsChangeApplier {
  FsChangeApplier({
    required this.storage,
    required this.localDataSource,
    required this.mapper,
    required this.pathService,
  });

  final StorageRepository storage;
  final FileModelMapper mapper;
  final StoragePathService pathService;
  final LocalDataSource localDataSource;

  Future<void> apply({required List<DbChange> changeList}) async {
    final PriorityQueue<DbChange> changeQueue = PriorityQueue<DbChange>(
      (c1, c2) => c1.depth.compareTo(c2.depth),
    );
    changeQueue.addAll(changeList);
    while (changeQueue.isNotEmpty) {
      final change = changeQueue.removeFirst();
      switch (change) {
        case DbCreate():
          debugLog('creating ${change.fs.path} from fs');
          late final FileModel parent;
          (await localDataSource.getFile(
            localFileId: change.fs.parentLocalFileId,
          )).when(
            failure: (message, error, source) => throw Exception(
              'failed to get parent for ${change.fs.parentLocalFileId}',
            ),
            success: (data) => parent = data!,
          );
          await storage.createFile(
            overwrite: false,
            parent: mapper.toEntity(parent),
            request: FileCreateRequest(
              name: pathService.getName(change.fs.path),
              isFolder: change.fs is ExistingFolder,
              downloadEnabled: true,
            ),
          );
        case DbUpdate():
          debugLog('updating ${change.file.name} from fs');
          final currentFile = change.file;
          final newFile = change.fs;
          late final String? parentId;
          final parentResult = await localDataSource.getFile(
            localFileId: change.fs.parentLocalFileId,
          );
          parentResult.when(
            success: (parent) {
              parentId = parent?.id;
            },
            failure: (msg, err, source) =>
                debugLog('$msg error: $err source: $source'),
          );

          await storage.updateFile(
            request: FileUpdateRequest(
              id: currentFile.fileId,
              ownerId: await pathService.getOwnerIdByPath(path: change.fs.path),
              parentId: parentId,
              hash: change.hash,
              name: pathService.getName(change.fs.path),
              depth: newFile.depth,
            ),
            overwrite: false,
          );
        case DbDelete():
          final fileResult = await localDataSource.getFile(
            fileId: change.file.fileId,
          );
          fileResult.when(
            success: (file) =>
                storage.deleteFile(entity: mapper.toEntity(file!)),
            failure: (_, _, _) => {debugLog('file is already deleted')},
          );
      }
    }
  }
}
