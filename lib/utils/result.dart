/// Result pattern for better error handling
/// Provides a way to return either success or failure without throwing exceptions

class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  final String? errorCode;

  /// Private constructor
  Result._({
    this.data,
    this.error,
    required this.isSuccess,
    this.errorCode,
  });

  /// Success factory
  factory Result.success(T data) {
    return Result._(
      data: data,
      isSuccess: true,
    );
  }

  /// Failure factory
  factory Result.failure(String error, {String? errorCode}) {
    return Result._(
      error: error,
      isSuccess: false,
      errorCode: errorCode,
    );
  }

  /// Check if result is a failure
  bool get isFailure => !isSuccess;

  /// Get data or throw error
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw Exception(error ?? 'Unknown error');
  }

  /// Get data or return default value
  T getOrElse(T defaultValue) {
    return data ?? defaultValue;
  }

  /// Map the success value
  Result<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      return Result.success(transform(data!));
    }
    return Result.failure(error ?? 'Unknown error', errorCode: errorCode);
  }

  /// FlatMap for chaining operations
  Result<R> flatMap<R>(Result<R> Function(T data) transform) {
    if (isSuccess && data != null) {
      return transform(data!);
    }
    return Result.failure(error ?? 'Unknown error', errorCode: errorCode);
  }

  /// Handle both success and failure cases
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onFailure,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data!);
    }
    return onFailure(error ?? 'Unknown error');
  }
}
