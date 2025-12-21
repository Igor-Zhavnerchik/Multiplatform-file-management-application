import 'dart:io';
import 'package:crypto/crypto.dart';

class HashService {
  Future<String?> hashFile({required FileSystemEntity file}) async {
    switch (file) {
      case File():
        {
          final stream = file.openRead();
          final digest = await sha256.bind(stream).first;
          return digest.toString();
        }
      case Directory():
        return null;
      default:
        return null;
    }
  }
}
