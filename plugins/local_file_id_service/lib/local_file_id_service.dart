
import 'local_file_id_service_platform_interface.dart';

class LocalFileIdService {
  Future<String?> getPlatformVersion() {
    return LocalFileIdServicePlatform.instance.getPlatformVersion();
  }
}
