import 'package:cross_platform_project/domain/entities/file_entity.dart';

class RemoteFileModel {
  final String id;
  final String ownerId;
  final String? parentId;

  final String name;
  final String? mimeType;
  final bool isFolder;
  final int? size;
  final String? hash;

  final DownloadStatus downloadStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const RemoteFileModel({
    required this.id,
    required this.ownerId,
    required this.parentId,

    required this.name,
    required this.mimeType,
    required this.isFolder,
    required this.size,
    required this.hash,

    required this.downloadStatus,

    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  RemoteFileModel copyWith({
    String? id,
    String? ownerId,
    String? parentId,

    String? name,
    String? mimeType,
    bool? isFolder,
    int? size,
    String? hash,

    DownloadStatus? downloadStatus,

    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return RemoteFileModel(
      id: id ?? this.id,
      ownerId: this.ownerId,
      parentId: parentId ?? this.parentId,

      name: name ?? this.name,
      mimeType: mimeType ?? this.mimeType,
      isFolder: isFolder ?? this.isFolder,
      size: size ?? this.size,
      hash: hash ?? this.hash,

      downloadStatus: downloadStatus ?? this.downloadStatus,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
