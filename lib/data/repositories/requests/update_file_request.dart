import 'package:cross_platform_project/data/data_source/local/database/app_database.dart';
import 'package:cross_platform_project/data/models/file_model.dart';
import 'package:cross_platform_project/data/models/file_model_mapper.dart';
import 'package:cross_platform_project/domain/entities/file_entity.dart';
import 'package:drift/drift.dart';

class FileUpdateRequest {
  final String id;
  final String? ownerId;

  final String? parentId;
  final int? depth;
  final String? name;
  final String? mimeType;
  final bool? isFolder;
  final int? size;
  final String? hash;

  final bool? syncEnabled;
  final bool? downloadEnabled;

  final SyncStatus? syncStatus;
  final DownloadStatus? downloadStatus;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const FileUpdateRequest({
    required this.id,
    this.ownerId,
    this.parentId,
    this.depth,
    this.name,
    this.mimeType,
    this.isFolder,
    this.size,
    this.hash,
    this.syncEnabled,
    this.downloadEnabled,
    this.syncStatus,
    this.downloadStatus,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  FileUpdateRequest copyWith({
    String? parentId,
    String? ownerId,
    int? depth,
    String? name,
    String? mimeType,
    bool? isFolder,
    int? size,
    String? hash,
    bool? syncEnabled,
    bool? downloadEnabled,
    SyncStatus? syncStatus,
    DownloadStatus? downloadStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return FileUpdateRequest(
      id: id,
      ownerId: ownerId ?? this.ownerId,
      parentId: parentId ?? this.parentId,
      depth: depth ?? this.depth,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      isFolder: isFolder ?? this.isFolder,
      size: size ?? this.size,
      hash: hash ?? this.hash,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      downloadEnabled: downloadEnabled ?? this.downloadEnabled,
      syncStatus: syncStatus ?? this.syncStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  FilesCompanion toCompanion() {
    return FilesCompanion(
      parentId: parentId != null ? Value(parentId!) : Value.absent(),
      ownerId: ownerId != null ? Value(ownerId!) : Value.absent(),
      depth: depth != null ? Value(depth!) : Value.absent(),
      name: name != null ? Value(name!) : Value.absent(),
      mimeType: mimeType != null ? Value(mimeType!) : Value.absent(),
      isFolder: isFolder != null ? Value(isFolder!) : Value.absent(),
      size: size != null ? Value(size!) : Value.absent(),
      hash: hash != null ? Value(hash!) : Value.absent(),
      downloadEnabled: downloadEnabled != null
          ? Value(downloadEnabled!)
          : Value.absent(),
      syncStatus: syncStatus != null ? Value(syncStatus!) : Value.absent(),
      downloadStatus: downloadStatus != null
          ? Value(downloadStatus!)
          : Value.absent(),
      createdAt: createdAt != null ? Value(createdAt!) : Value.absent(),
      updatedAt: updatedAt != null ? Value(updatedAt!) : Value.absent(),
      deletedAt: deletedAt != null ? Value(deletedAt!) : Value.absent(),
    );
  }
}

extension FileUpdateRequestFromModelMapper on FileModelMapper {
  FileUpdateRequest toUpdateRequest(FileModel model) {
    return FileUpdateRequest(
      id: model.id,
      ownerId: model.ownerId,
      parentId: model.parentId,
      depth: model.depth,
      name: model.name,
      mimeType: model.mimeType,
      isFolder: model.isFolder,
      size: model.size,
      hash: model.hash,
      downloadEnabled: model.downloadEnabled,
      syncStatus: model.syncStatus,
      downloadStatus: model.downloadStatus,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      deletedAt: model.deletedAt,
    );
  }
}

extension FileUpdateRequestToMetadataMapper on FileUpdateRequest {
  Map<String, dynamic> toMetadata() {
    return {
      'id': id,
      'owner_id': ownerId,
      'parent_id': parentId,
      'depth': depth,
      'name': name,
      'mime_type': mimeType,
      'is_folder': isFolder,
      'size': size,
      'hash': hash,
      'download_status': downloadStatus?.name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }
}
