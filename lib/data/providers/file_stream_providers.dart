import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlyFileListProvider = StreamProvider.family<List<FileEntity>, String>((
  ref,
  parentId,
) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  return storageRepository.watchFileStream(parentId: parentId, onlyFiles: true);
});

final onlyFoldersListProvider = StreamProvider.family<List<FileEntity>, String>(
  (ref, parentId) {
    final storageRepository = ref.watch(storageRepositoryProvider);
    return storageRepository.watchFileStream(
      parentId: parentId,
      onlyFolders: true,
    );
  },
);

final childrenListProvider = StreamProvider.family<List<FileEntity>, String?>((
  ref,
  parentId,
) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  return storageRepository.watchFileStream(parentId: parentId);
});
