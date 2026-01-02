import 'package:cross_platform_project/data/providers/current_user_provider.dart';
import 'package:cross_platform_project/data/providers/storage_repository_provider.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final onlyFileListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);

      final userId = ref.watch(currentUserIdProvider).value;
      return storageRepository.watchFileStream(
        parentId: parentId,
        onlyFiles: true,
        ownerId: userId,
      );
    });

final onlyFoldersListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String?>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);

      final userId = ref.watch(currentUserIdProvider).value;
      return storageRepository.watchFileStream(
        parentId: parentId,
        onlyFolders: true,
        ownerId: userId,
      );
    });

final childrenListProvider = StreamProvider.autoDispose
    .family<List<FileEntity>, String?>((ref, parentId) {
      final storageRepository = ref.watch(storageRepositoryProvider);
      final userId = ref.watch(currentUserIdProvider).value;
      return storageRepository.watchFileStream(
        parentId: parentId,
        ownerId: userId,
      );
    });
