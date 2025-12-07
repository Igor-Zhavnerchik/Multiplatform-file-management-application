import 'dart:convert';
import 'dart:io';

import 'package:cross_platform_project/data/data_source/local/local_storage_service.dart';
import 'package:flutter/services.dart';

class JsonStorage {
  final LocalStorageService files;

  JsonStorage({required this.files});

  Future<void> save({
    required String path,
    required Map<String, dynamic> jsonData,
  }) async {
    final jsonString = jsonEncode(jsonData);
    final fileData = Uint8List.fromList(utf8.encode(jsonString));
    await files.saveBytes(path: path, bytes: fileData);
  }

  Future<Map<String, dynamic>> getFromJson({required String path}) async {
    final file = files.getEntity(path: path, isFolder: false) as File;
    final jsonString = await file.readAsString();
    return jsonDecode(jsonString);
  }
}
