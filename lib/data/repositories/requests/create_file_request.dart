class FileCreateRequest {
  final String? localPath;
  final Stream<List<int>>? bytes;
  final String name;
  final bool isFolder;
  final bool contentSyncEnabled;

  FileCreateRequest({
    required this.name,
    this.localPath,
    this.bytes,
    required this.isFolder,
    required this.contentSyncEnabled,
  });

  FileCreateRequest copyWith({
    String? localPath,
    Stream<List<int>>? bytes,
    String? name,
    bool? isFolder,
    bool? contentSyncEnabled,
  }) {
    return FileCreateRequest(
      name: name ?? this.name,
      localPath: localPath ?? this.localPath,
      bytes: bytes ?? this.bytes,
      isFolder: isFolder ?? this.isFolder,
      contentSyncEnabled: contentSyncEnabled ?? this.contentSyncEnabled,
    );
  }
}
