import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/remote_file_model.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class FileModelMapper {
  FilesCompanion toInsert(FileModel model) => FilesCompanion.insert(
    id: model.id,
    ownerId: model.ownerId,
    parentId: Value(model.parentId),

    name: model.name,
    mimeType: Value(model.mimeType),
    isFolder: model.isFolder,
    size: Value(model.size),
    hash: Value(model.hash),

    syncStatus: model.syncStatus.name,
    downloadEnabled: model.downloadEnabled!,

    downloadStatus: model.downloadStatus.name,
    syncEnabled: model.syncEnabled!,

    createdAt: model.createdAt,
    updatedAt: model.updatedAt,
    deletedAt: Value(model.deletedAt),
  );

  FilesCompanion toUpdate(FileModel model) => FilesCompanion(
    id: Value(model.id),
    parentId: Value(model.parentId),

    name: Value(model.name),
    mimeType: Value(model.mimeType),
    size: Value(model.size),
    hash: Value(model.hash),

    updatedAt: Value(model.updatedAt),
    deletedAt: Value(model.deletedAt),
  );

  FileModel fromDbFile(DbFile dbFile) => FileModel(
    id: dbFile.id,
    ownerId: dbFile.ownerId,
    parentId: dbFile.parentId,

    name: dbFile.name,
    mimeType: dbFile.mimeType,
    isFolder: dbFile.isFolder,
    size: dbFile.size,
    hash: dbFile.hash,

    syncEnabled: dbFile.syncEnabled,
    downloadEnabled: dbFile.downloadEnabled,

    syncStatus: SyncStatus.values.byName(dbFile.syncStatus),
    downloadStatus: DownloadStatus.values.byName(dbFile.downloadStatus),

    createdAt: dbFile.createdAt,
    updatedAt: dbFile.updatedAt,
    deletedAt: dbFile.deletedAt,
  );

  FileEntity toEntity(FileModel model) {
    return FileEntity(
      id: model.id,
      ownerId: model.ownerId,
      parentId: model.parentId,

      name: model.name,
      mimeType: model.mimeType,
      isFolder: model.isFolder,
      size: model.size,
      hash: model.hash,

      syncEnabled: model.syncEnabled!,
      downloadStatus: model.downloadStatus,

      syncStatus: model.syncStatus,
      downloadEnabled: model.downloadEnabled!,

      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
    );
  }

  FileModel fromEntity(FileEntity entity) {
    return FileModel(
      id: entity.id,
      ownerId: entity.ownerId,
      parentId: entity.parentId,

      name: entity.name,
      mimeType: entity.mimeType,
      isFolder: entity.isFolder,
      size: entity.size,
      hash: entity.hash,

      syncEnabled: entity.syncEnabled,
      downloadEnabled: entity.downloadEnabled,

      syncStatus: entity.syncStatus,
      downloadStatus: entity.downloadStatus,

      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deletedAt: entity.deletedAt,
    );
  }

  Map<String, dynamic> toMetadata({required FileModel model}) {
    return {
      'id': model.id,
      'owner_id': model.ownerId,
      'parent_id': model.parentId,

      'name': model.name,
      'mime_type': model.mimeType,
      'is_folder': model.isFolder,
      'size': model.size,
      'hash': model.hash,

      'download_status': model.downloadStatus.name,

      'created_at': model.createdAt.toIso8601String(),
      'updated_at': model.updatedAt.toIso8601String(),
      'deleted_at': model.deletedAt == null
          ? null
          : model.updatedAt.toIso8601String(),
    };
  }

  RemoteFileModel fromMetadata({required Map<String, dynamic> metadata}) {
    return RemoteFileModel(
      id: metadata['id'],
      ownerId: metadata['owner_id'],
      parentId: metadata['parent_id'],

      name: metadata['name'],
      mimeType: metadata['mime_type'],
      isFolder: metadata['is_folder'],
      size: metadata['size'],
      hash: metadata['hash'],

      downloadStatus: metadata['download_status'] != null
          ? DownloadStatus.values.byName(metadata['download_status'])
          : DownloadStatus.notDownloaded,

      createdAt: DateTime.parse(metadata['created_at']),
      updatedAt: DateTime.parse(metadata['updated_at']),
      deletedAt: metadata['deleted_at'] != null
          ? DateTime.parse(metadata['deleted_at'])
          : null,
    );
  }

  FileModel fromRemoteFileFodel({
    required RemoteFileModel remoteFileModel,
    required bool syncEnabled,
    required bool downloadEnabled,
    required SyncStatus defaultStatus,
  }) {
    return FileModel(
      id: remoteFileModel.id,
      ownerId: remoteFileModel.ownerId,
      parentId: remoteFileModel.parentId,

      name: remoteFileModel.name,
      mimeType: remoteFileModel.mimeType,
      isFolder: remoteFileModel.isFolder,
      size: remoteFileModel.size,
      hash: remoteFileModel.hash,

      syncEnabled: syncEnabled,
      downloadEnabled: downloadEnabled,

      syncStatus: defaultStatus,
      downloadStatus: remoteFileModel.downloadStatus,

      createdAt: remoteFileModel.createdAt,
      updatedAt: remoteFileModel.updatedAt,
      deletedAt: remoteFileModel.deletedAt,
    );
  }
}
