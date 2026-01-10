import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlyFileListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);

      return storageRepository.watchFileStream(
        parentId: parentId,
        onlyFiles: true,
      );
    });

final onlyFoldersListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String?>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);

      ref.onDispose(() => debugLog('DISPOSED FOLDER STREAM PROVIDER'));
      return storageRepository.watchFileStream(
        parentId: parentId,
        onlyFolders: true,
      );
    });

final childrenListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String?>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);
      return storageRepository.watchFileStream(parentId: parentId);
    });
