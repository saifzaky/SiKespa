import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'exceptions.dart';
import 'logger.dart';

/// Error handler utility for consistent error handling across the app
class ErrorHandler {
  /// Convert Firebase Auth exception to user-friendly message
  static String getFirebaseAuthErrorMessage(
      firebase_auth.FirebaseAuthException e) {
    AppLogger.e('Firebase Auth Error', e, e.stackTrace);

    switch (e.code) {
      case 'user-not-found':
        return 'Email tidak terdaftar';
      case 'wrong-password':
        return 'Password salah';
      case 'email-already-in-use':
        return 'Email sudah digunakan';
      case 'weak-password':
        return 'Password terlalu lemah (minimal 6 karakter)';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'requires-recent-login':
        return 'Silakan login ulang untuk melanjutkan';
      default:
        return 'Terjadi kesalahan autentikasi: ${e.message ?? 'Unknown error'}';
    }
  }

  /// Convert Firestore exception to user-friendly message
  static String getFirestoreErrorMessage(FirebaseException e) {
    AppLogger.e('Firestore Error', e, e.stackTrace);

    switch (e.code) {
      case 'permission-denied':
        return 'Anda tidak memiliki akses ke data ini';
      case 'not-found':
        return 'Data tidak ditemukan';
      case 'already-exists':
        return 'Data sudah ada';
      case 'resource-exhausted':
        return 'Terlalu banyak permintaan. Coba lagi nanti';
      case 'unauthenticated':
        return 'Silakan login terlebih dahulu';
      case 'unavailable':
        return 'Layanan tidak tersedia. Coba lagi nanti';
      case 'deadline-exceeded':
        return 'Waktu permintaan habis. Coba lagi';
      default:
        if (e.message?.contains('network') ?? false) {
          return 'Tidak ada koneksi internet';
        }
        return 'Terjadi kesalahan saat mengakses data: ${e.message ?? 'Unknown error'}';
    }
  }

  /// Get user-friendly error message from any error
  static String getErrorMessage(dynamic error) {
    if (error is AppException) {
      AppLogger.e('App Exception', error);
      return error.message;
    } else if (error is firebase_auth.FirebaseAuthException) {
      return getFirebaseAuthErrorMessage(error);
    } else if (error is FirebaseException) {
      return getFirestoreErrorMessage(error);
    } else if (error is FormatException) {
      AppLogger.e('Format Exception', error);
      return 'Format data tidak valid';
    } else {
      AppLogger.e('Unknown Error', error);
      return 'Terjadi kesalahan: ${error.toString()}';
    }
  }

  /// Show error snackbar to user
  static void showErrorSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            messenger.hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Show success snackbar to user
  static void showSuccessSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show warning snackbar to user
  static void showWarningSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_outlined, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show info snackbar to user
  static void showInfoSnackBar(BuildContext context, String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Log error with context
  static void logError(String context, dynamic error,
      [StackTrace? stackTrace]) {
    AppLogger.e('[$context] Error occurred', error, stackTrace);
  }

  /// Show error dialog (for critical errors)
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onAction();
              },
              child: Text(actionLabel),
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Handle error and show appropriate UI feedback
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    bool showDialog = false,
  }) {
    final message = customMessage ?? getErrorMessage(error);

    if (showDialog) {
      showErrorDialog(
        context,
        title: 'Terjadi Kesalahan',
        message: message,
      );
    } else {
      showErrorSnackBar(context, message);
    }
  }
}
