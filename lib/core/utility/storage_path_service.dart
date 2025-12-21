import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:path/path.dart' as p;

class StoragePathService {
  final String appRootPath;
  final FilesDao filesTable;

  StoragePathService(this.appRootPath, this.filesTable);

  String getRoot() {
    return p.join(appRootPath, 'users');
  }

  String normalize(String path, {bool forRemote = false}) {
    return forRemote ? p.posix.normalize(path) : p.normalize(path);
  }

  String toLocalPath(String path) {
    return normalize(path);
  }

  @deprecated
  String toRemotePath(String path) {
    var normalized = normalize(path, forRemote: true);
    return normalized.replaceFirst(RegExp(r'^/+'), '');
  }

  @deprecated
  String resolve({required String relPath, bool forRemote = false}) {
    return normalize(p.join(appRootPath, relPath), forRemote: forRemote);
  }

  String join({
    required String parent,
    required String child,
    bool forRemote = false,
  }) => forRemote ? p.posix.join(parent, child) : p.join(parent, child);

  String getParentPath({required String path}) => p.dirname(path);

  String getName(String path) {
    return p.basename(path);
  }

  @deprecated
  String joinFromAnotherPath({
    required String parent,
    required String fromPath,
    bool forRemote = false,
  }) => join(parent: parent, child: getName(fromPath), forRemote: forRemote);

  String getRemotePath({required String userId, required fileId}) {
    return 'users/$userId/storage/$fileId';
  }

  Future<String> getLocalPath({
    required String? fileId,
    required String userId,
  }) async {
    if (fileId == null) {
      return p.join(appRootPath, 'users', userId, 'storage');
    }

    return p.join(
      await getLocalPath(
        fileId: await filesTable.getParentIdbyId(fileId),
        userId: userId,
      ),
      await filesTable.getNameById(fileId),
    );
  }

  Future<String> getOwnerIdByPath({required String path}) async {
    final regex = RegExp('${getRoot()}${p.separator}(\\d+)${p.separator}');
    return regex.firstMatch(path)!.group(1)!;
  }
}
