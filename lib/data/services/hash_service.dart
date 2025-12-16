import 'dart:io';
import 'package:crypto/crypto.dart';

class HashService {
  Future<String> hashFile(File file) async {
    final stream = file.openRead();
    final digest = await sha256.bind(stream).first;
    return digest.toString();
  }

  //FIXME
  Future<String> hashFolder(Directory folder) async {
    return folder.path;
  }
}
