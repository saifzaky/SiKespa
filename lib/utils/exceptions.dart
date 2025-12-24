/// Custom exceptions for SiKespa application
/// Provides better error handling and user-friendly error messages

/// Base exception class for all app-specific exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppException(this.message, {this.code, this.originalError});

  @override
  String toString() => message;
}

/// Authentication related exceptions
class AuthException extends AppException {
  AuthException(super.message, {super.code, super.originalError});

  factory AuthException.fromFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return AuthException('Email tidak terdaftar', code: code);
      case 'wrong-password':
        return AuthException('Password salah', code: code);
      case 'email-already-in-use':
        return AuthException('Email sudah digunakan', code: code);
      case 'weak-password':
        return AuthException('Password terlalu lemah (minimal 6 karakter)',
            code: code);
      case 'invalid-email':
        return AuthException('Format email tidak valid', code: code);
      case 'user-disabled':
        return AuthException('Akun telah dinonaktifkan', code: code);
      case 'too-many-requests':
        return AuthException('Terlalu banyak percobaan. Coba lagi nanti',
            code: code);
      case 'network-request-failed':
        return AuthException('Tidak ada koneksi internet', code: code);
      default:
        return AuthException('Terjadi kesalahan autentikasi', code: code);
    }
  }
}

/// Firestore related exceptions
class FirestoreException extends AppException {
  FirestoreException(super.message, {super.code, super.originalError});

  factory FirestoreException.fromError(dynamic error) {
    if (error.toString().contains('permission-denied')) {
      return FirestoreException('Anda tidak memiliki akses ke data ini',
          code: 'permission-denied');
    } else if (error.toString().contains('not-found')) {
      return FirestoreException('Data tidak ditemukan', code: 'not-found');
    } else if (error.toString().contains('network')) {
      return FirestoreException('Tidak ada koneksi internet', code: 'network');
    }
    return FirestoreException('Terjadi kesalahan saat mengakses data');
  }
}

/// Storage related exceptions
class StorageException extends AppException {
  StorageException(super.message, {super.code, super.originalError});

  factory StorageException.fromError(dynamic error) {
    if (error.toString().contains('unauthorized')) {
      return StorageException('Tidak memiliki izin upload',
          code: 'unauthorized');
    } else if (error.toString().contains('quota-exceeded')) {
      return StorageException('Kuota penyimpanan penuh',
          code: 'quota-exceeded');
    }
    return StorageException('Gagal mengunggah file');
  }
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(super.message, {super.code});
}

/// Network exceptions
class NetworkException extends AppException {
  NetworkException(super.message, {super.code, super.originalError});
}
