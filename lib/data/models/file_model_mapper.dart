import 'package:cross_platform_project/common/debug/debugger.dart';
import 'package:cross_platform_project/application/services/settings_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class FileModelMapper {
  final SettingsService settings;
  FileModelMapper({required this.settings});

  FilesCompanion toInsert(FileModel model, String localFileId) =>
      FilesCompanion.insert(
        id: model.id,
        ownerId: model.ownerId,
        parentId: Value(model.parentId),
        localFileId: localFileId,
        name: model.name,
        isFolder: model.isFolder,
        size: Value(model.size),
        hash: Value(model.hash),
        contentSyncEnabled: model.contentSyncEnabled,
        syncStatus: model.syncStatus,
        downloadStatus: model.downloadStatus,
        createdAt: model.createdAt,
        updatedAt: model.updatedAt,
        contentUpdatedAt: model.contentUpdatedAt,
      );

  FilesCompanion toUpdate(FileModel model, {String? localFileId}) =>
      FilesCompanion(
        parentId: Value(model.parentId),
        name: Value(model.name),
        size: Value(model.size),
        hash: Value(model.hash),
        contentSyncEnabled: Value(model.contentSyncEnabled),
        syncStatus: Value(model.syncStatus),
        downloadStatus: Value(model.downloadStatus),
        updatedAt: Value(model.updatedAt),
        contentUpdatedAt: Value(model.contentUpdatedAt),
        localFileId: Value.absentIfNull(localFileId),
      );

  FileModel fromDbFile(DbFile dbFile) => FileModel(
    id: dbFile.id,
    ownerId: dbFile.ownerId,
    parentId: dbFile.parentId,
    name: dbFile.name,
    isFolder: dbFile.isFolder,
    size: dbFile.size,
    hash: dbFile.hash,
    contentSyncEnabled: dbFile.contentSyncEnabled,
    syncStatus: dbFile.syncStatus,
    downloadStatus: dbFile.downloadStatus,
    createdAt: dbFile.createdAt.toUtc(),
    updatedAt: dbFile.updatedAt.toUtc(),
    contentUpdatedAt: dbFile.contentUpdatedAt.toUtc(),
  );

  FileEntity toEntity(FileModel model) {
    return FileEntity(
      id: model.id,
      ownerId: model.ownerId,
      parentId: model.parentId,
      name: model.name,
      isFolder: model.isFolder,
      size: model.size,
      hash: model.hash,
      contentSyncEnabled: model.contentSyncEnabled,
      syncStatus: model.syncStatus,
      downloadStatus: model.downloadStatus,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      contentUpdatedAt: model.contentUpdatedAt,
    );
  }

  FileModel fromEntity(FileEntity entity) {
    return FileModel(
      id: entity.id,
      ownerId: entity.ownerId,
      parentId: entity.parentId,
      name: entity.name,
      isFolder: entity.isFolder,
      size: entity.size,
      hash: entity.hash,
      contentSyncEnabled: entity.contentSyncEnabled,
      syncStatus: entity.syncStatus,
      downloadStatus: entity.downloadStatus,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      contentUpdatedAt: entity.contentUpdatedAt,
    );
  }

  Map<String, dynamic> toMetadata({required FileModel model}) {
    return {
      'id': model.id,
      'owner_id': model.ownerId,
      'parent_id': model.parentId,
      'name': model.name,
      'is_folder': model.isFolder,
      'download_status': model.downloadStatus.name,
      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
      'content_updated_at': model.contentUpdatedAt.toIso8601String(),
    };
  }

  FileModel fromMetadata({required Map<String, dynamic> metadata}) {
    debugLog('converting to FileModel from $metadata');
    return FileModel(
      id: metadata['id'],
      ownerId: metadata['owner_id'],
      parentId: metadata['parent_id'],
      name: metadata['name'],
      isFolder: metadata['is_folder'],
      size: null,
      hash: null,
      contentSyncEnabled: settings.defaultContentSyncEnabled,
      syncStatus: SyncStatus.syncronized,
      downloadStatus: DownloadStatus.values.byName(metadata['download_status']),
      createdAt: DateTime.parse(metadata['created_at']),
      updatedAt: DateTime.parse(metadata['updated_at']),
      contentUpdatedAt: DateTime.parse(metadata['content_updated_at']),
    );
  }
}
