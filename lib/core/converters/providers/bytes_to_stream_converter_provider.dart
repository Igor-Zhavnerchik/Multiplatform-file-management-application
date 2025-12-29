import 'package:cross_platform_project/core/converters/bytes_to_stream_converter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bytesToStreamConverterProvider = Provider<BytesToStreamConverter>((ref) {
  return BytesToStreamConverter();
});
