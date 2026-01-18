import 'package:cross_platform_project/core/debug/debugger.dart';
import 'package:cross_platform_project/core/services/current_user_service.dart';
import 'package:cross_platform_project/data/data_source/local/database/dao/files_dao.dart';
import 'package:path/path.dart' as p;

class StoragePathService {
  late final String appRootPath;
  final FilesDao filesTable;
  final CurrentUserService currentUserService;
  String get currentUserId => currentUserService.currentUserId;

  StoragePathService({
    required this.filesTable,
    required this.currentUserService,
  });

  void init({required String appRootPath}) {
    this.appRootPath = appRootPath;
    debugLog('Path Service INIT with root: ${this.appRootPath}');
  }

  String getRoot() {
    return p.join(appRootPath, 'users');
  }

  String normalize(String path, {bool forRemote = false}) {
    return forRemote ? p.posix.normalize(path) : p.normalize(path);
  }

  String toLocalPath(String path) {
    return normalize(path);
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

  String getRemotePath({required String fileId}) {
    return 'users/$currentUserId/storage/$fileId';
  }

  //FIXME fix recursion to loop
  //FIXME fix direct dao access
  Future<String> getLocalPath({required String? fileId}) async {
    //debugLog('getting path for id: $fileId');
    if (fileId == null) {
      return p.join(appRootPath, 'users', currentUserId);
    }
    final file = await filesTable.getFile(fileId: fileId);
    debugLog('for ${file?.name} parent id: ${file?.parentId}');
    return p.join((await getLocalPath(fileId: file!.parentId)), file.name);
  }

  Future<String> getOwnerIdByPath({required String path}) async {
    //debugLog('getting ownerId from $path');
    final rootPattern = RegExp.escape(getRoot());
    final separatorPattern = RegExp.escape(p.separator);
    final uuidPattern =
        r'([0-9a-fA-F]{8}-'
        r'[0-9a-fA-F]{4}-'
        r'[0-9a-fA-F]{4}-'
        r'[0-9a-fA-F]{4}-'
        r'[0-9a-fA-F]{12})';

    final regex = RegExp(
      rootPattern + separatorPattern + uuidPattern + separatorPattern,
    );
    final res = regex.firstMatch(path)!.group(1)!;
    //debugLog('got: $res');
    return res;
  }

  Future<String> getUsersStorageDirectory() async {
    return p.join(appRootPath, 'users', currentUserId);
  }
}
