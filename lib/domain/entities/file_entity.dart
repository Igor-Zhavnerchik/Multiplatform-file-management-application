enum SyncStatus {
  syncronized,
  created,
  creating,
  updated,
  deleted,

  uploadingNew,
  uploading,
  downloading,
  updatingLocally,
  updatingRemotely,
  deletingRemotely,
  deletingLocally,

  failedUploadNew,
  failedUpload,
  failedDownload,
  failedLocalDelete,
  failedRemoteDelete,
  failedRemoteUpdate,
  failedLocalUpdate,
}

enum DownloadStatus { downloaded, notDownloaded, processingDownload }

class FileEntity {
  final String id;
  final String ownerId;
  final String? parentId;

  final String name;
  final String? mimeType;

  final bool isFolder;
  final int? size;
  final String? hash;

  final bool syncEnabled;
  final bool downloadEnabled;

  final SyncStatus syncStatus;
  final DownloadStatus downloadStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  const FileEntity({
    required this.id,
    required this.ownerId,
    required this.parentId,

    required this.name,
    required this.mimeType,
    required this.isFolder,
    required this.size,
    required this.hash,

    required this.syncEnabled,
    required this.downloadEnabled,

    required this.syncStatus,
    required this.downloadStatus,

    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  FileEntity copyWith({
    String? id,
    String? ownerId,
    String? parentId,

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
    return FileEntity(
      id: id ?? this.id,
      ownerId: this.ownerId,
      parentId: parentId ?? this.parentId,

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
}
