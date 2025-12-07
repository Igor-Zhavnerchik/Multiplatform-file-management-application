sealed class Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, Object? error) failure,
  }) {
    return switch (this) {
      Success<T> s => success(s.data),
      Failure<T> f => failure(f.message, f.error),
    };
  }
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success($data)';
}

class Failure<T> extends Result<T> {
  final String message;
  final Object? error;
  final String? source;

  const Failure(this.message, {this.error, this.source});

  @override
  String toString() =>
      'Failure(message: $message, error: $error, source: $source)';
}
