import 'dart:async';
import 'dart:typed_data';

class BytesToStreamConverter {
  Stream<List<int>> convert(
    Uint8List bytes, {
    int chunkSize = 64 * 1024,
  }) async* {
    for (var i = 0; i < bytes.length; i += chunkSize) {
      yield bytes.sublist(
        i,
        i + chunkSize > bytes.length ? bytes.length : i + chunkSize,
      );
    }
  }
}
