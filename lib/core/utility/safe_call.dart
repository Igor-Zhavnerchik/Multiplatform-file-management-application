import 'package:cross_platform_project/core/utility/result.dart';

Future<Result<T>> safeCall<T>(
  Future<T> Function() action, {
  required String source,
  String? failureMessage,
}) async {
  try {
    var res = await action();
    return Success(res);
  } catch (e) {
    return Failure(failureMessage ?? 'error occured', source: source, error: e);
  }
}
