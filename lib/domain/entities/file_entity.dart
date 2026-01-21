enum SyncStatus {
  syncronized,
  created,
  updated,
  deleted,

  updatedLocally,
  updatedRemotely,
  updatingLocally,
  updatingRemotely,
  deletingRemotely,
  deletingLocally,

  failedLocalUpdate,
  failedLocalDelete,

  failedRemoteCreate,
  failedRemoteUpdate,
  failedRemoteDelete,
}

enum DownloadStatus {
  notDownloaded,
  haveNewVersion,
  downloaded,
  downloading,
  uploading,
  failedUpload,
  failedDownload,
}

class FileEntity {
  final String id;
  final String ownerId;
  final String? parentId;

  final String name;

  final bool isFolder;
  final int? size;
  final String? hash;

  final bool contentSyncEnabled;

  final SyncStatus syncStatus;
  final DownloadStatus downloadStatus;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime contentUpdatedAt;

  const FileEntity({
    required this.id,
    required this.ownerId,
    required this.parentId,

    required this.name,
    required this.isFolder,
    required this.size,
    required this.hash,

    required this.contentSyncEnabled,

    required this.syncStatus,
    required this.downloadStatus,

    required this.createdAt,
    required this.updatedAt,
    required this.contentUpdatedAt,
  });

  FileEntity copyWith({
    String? id,
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
    return FileEntity(
      id: id ?? this.id,
      ownerId: this.ownerId,
      parentId: parentId ?? this.parentId,

      name: name ?? this.name,
      isFolder: isFolder ?? this.isFolder,
      size: size ?? this.size,
      hash: hash ?? this.hash,

      contentSyncEnabled: contentSyncEnabled ?? this.contentSyncEnabled,

      syncStatus: syncStatus ?? this.syncStatus,
      downloadStatus: downloadStatus ?? this.downloadStatus,

      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      contentUpdatedAt: contentUpdatedAt ?? this.contentUpdatedAt,
    );
  }
}
