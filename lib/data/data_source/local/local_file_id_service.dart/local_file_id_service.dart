import 'package:cross_platform_project/data/data_source/local/local_file_id_service.dart/local_file_id_service_plugin.dart';

class LocalFileIdService {
  Future<String> getFileId({required String path}) async {
    return await LocalFileIdServicePlugin.getFileId(path);
  }
}
