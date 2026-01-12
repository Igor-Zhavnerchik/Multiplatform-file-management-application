import 'package:cross_platform_project/domain/entities/file_entity.dart';

class FileModel {
  final String id;
  final String ownerId;
  final String? parentId;

  final int depth;
  final String name;
  final String? mimeType;
  final bool isFolder;
  final int? size;
  final String? hash;

  final bool? downloadEnabled;

  final SyncStatus syncStatus;
  final DownloadStatus downloadStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const FileModel({
    required this.id,
    required this.ownerId,
    required this.parentId,

    required this.depth,
    required this.name,
    required this.mimeType,
    required this.isFolder,
    required this.size,
    required this.hash,

    required this.downloadEnabled,

    required this.syncStatus,
    required this.downloadStatus,

    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  FileModel copyWith({
    String? id,
    String? ownerId,
    String? parentId,

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
    return FileModel(
      id: id ?? this.id,
      ownerId: this.ownerId,
      parentId: parentId ?? this.parentId,

      depth: depth ?? this.depth,
      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      isFolder: isFolder ?? this.isFolder,
      size: size ?? this.size,
      hash: hash ?? this.hash,

      downloadEnabled: downloadEnabled ?? this.downloadEnabled,

      syncStatus: syncStatus ?? this.syncStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
