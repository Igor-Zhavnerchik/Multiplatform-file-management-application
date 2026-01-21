import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class FileUpdateRequest {
  final String id;
  final String? ownerId;
  final String? parentId;

  final String? name;
  final bool? isFolder;
  final int? size;
  final String? hash;

  final bool? contentSyncEnabled;

  final SyncStatus? syncStatus;
  final DownloadStatus? downloadStatus;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? contentUpdatedAt;

  const FileUpdateRequest({
    required this.id,
    this.ownerId,
    this.parentId,
    this.name,
    this.isFolder,
    this.size,
    this.hash,
    this.contentSyncEnabled,
    this.syncStatus,
    this.downloadStatus,
    this.createdAt,
    this.updatedAt,
    this.contentUpdatedAt,
  });

  FileUpdateRequest copyWith({
    String? ownerId,
    String? parentId,
    String? name,
    bool? isFolder,
    int? size,
    String? hash,
    bool? contentSyncEnabled,
    SyncStatus? syncStatus,
    DownloadStatus? downloadStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? contentUpdatedAt,
  }) {
    return FileUpdateRequest(
      id: id,
      ownerId: ownerId ?? this.ownerId,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      isFolder: isFolder ?? this.isFolder,
      size: size ?? this.size,
      hash: hash ?? this.hash,
      contentSyncEnabled:
          contentSyncEnabled ?? this.contentSyncEnabled,
      syncStatus: syncStatus ?? this.syncStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentUpdatedAt:
          contentUpdatedAt ?? this.contentUpdatedAt,
    );
  }

  FilesCompanion toCompanion() {
    return FilesCompanion(
      ownerId: Value.absentIfNull(ownerId),
      parentId: Value.absentIfNull(parentId),
      name: Value.absentIfNull(name),
      isFolder: Value.absentIfNull(isFolder),
      size: Value.absentIfNull(size),
      hash: Value.absentIfNull(hash),
      contentSyncEnabled:
          Value.absentIfNull(contentSyncEnabled),
      syncStatus: Value.absentIfNull(syncStatus),
      downloadStatus: Value.absentIfNull(downloadStatus),
      createdAt: Value.absentIfNull(createdAt),
      updatedAt: Value.absentIfNull(updatedAt),
      contentUpdatedAt:
          Value.absentIfNull(contentUpdatedAt),
    );
  }
}

extension FileUpdateRequestFromModelMapper on FileModelMapper {
  FileUpdateRequest toUpdateRequest(FileModel model) {
    return FileUpdateRequest(
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
}

extension FileUpdateRequestToMetadataMapper on FileUpdateRequest {
  Map<String, dynamic> toMetadata() {
    return {
      'id': id,
      'owner_id': ownerId,
      'parent_id': parentId,
      'name': name,
      'is_folder': isFolder,
      'download_status': downloadStatus?.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'content_updated_at':
          contentUpdatedAt?.toIso8601String(),
    };
  }
}
