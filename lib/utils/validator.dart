import 'app_constants.dart';

class Validator {
  /// Validate email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  /// Validate password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password minimal ${AppConstants.minPasswordLength} karakter';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password maksimal ${AppConstants.maxPasswordLength} karakter';
    }

    return null;
  }

  /// Validate password with strength requirements
  static String? strongPassword(String? value) {
    final basicValidation = password(value);
    if (basicValidation != null) return basicValidation;

    // Additional strength checks
    if (!RegExp(r'[A-Z]').hasMatch(value!)) {
      return 'Password harus mengandung huruf besar';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  /// Validate name
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }

    if (value.length < AppConstants.minNameLength) {
      return 'Nama minimal ${AppConstants.minNameLength} karakter';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Nama maksimal ${AppConstants.maxNameLength} karakter';
    }

    // Check for invalid characters
    if (!RegExp(r'^[a-zA-Z\s.]+$').hasMatch(value)) {
      return 'Nama hanya boleh mengandung huruf dan spasi';
    }

    return null;
  }

  /// Validate phone number
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    // Indonesian phone number format
    if (!RegExp(r'^(\+62|62|0)[0-9]{9,12}$').hasMatch(value)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  /// Validate age
  static String? age(String? value) {
    if (value == null || value.isEmpty) {
      return 'Umur tidak boleh kosong';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Umur harus berupa angka';
    }

    if (age < 0 || age > 150) {
      return 'Umur tidak valid';
    }

    return null;
  }

  /// Generic required field validator
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  /// Validate match (for password confirmation)
  static String? match(String? value, String? compareValue, String fieldName) {
    if (value != compareValue) {
      return '$fieldName tidak cocok';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(String? value, int min, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < min) {
      return '$fieldName minimal $min karakter';
    }

    return null;
  }

  /// Validate maximum length
  static String? maxLength(String? value, int max, String fieldName) {
    if (value == null) return null;

    if (value.length > max) {
      return '$fieldName maksimal $max karakter';
    }

    return null;
  }
}
