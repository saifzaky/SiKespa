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

  /// Validate blood type
  static String? bloodType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Golongan darah tidak boleh kosong';
    }

    final validTypes = ['A', 'B', 'AB', 'O'];
    final type = value.replaceAll('+', '').replaceAll('-', '').toUpperCase();

    if (!validTypes.contains(type)) {
      return 'Golongan darah tidak valid (A, B, AB, O)';
    }

    return null;
  }

  /// Validate systolic blood pressure
  static String? systolicBP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tekanan darah sistolik tidak boleh kosong';
    }

    final bp = int.tryParse(value);
    if (bp == null) {
      return 'Harus berupa angka';
    }

    if (bp < 70 || bp > 250) {
      return 'Nilai tidak valid (70-250 mmHg)';
    }

    return null;
  }

  /// Validate diastolic blood pressure
  static String? diastolicBP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tekanan darah diastolik tidak boleh kosong';
    }

    final bp = int.tryParse(value);
    if (bp == null) {
      return 'Harus berupa angka';
    }

    if (bp < 40 || bp > 150) {
      return 'Nilai tidak valid (40-150 mmHg)';
    }

    return null;
  }

  /// Validate heart rate
  static String? heartRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Detak jantung tidak boleh kosong';
    }

    final hr = int.tryParse(value);
    if (hr == null) {
      return 'Harus berupa angka';
    }

    if (hr < 30 || hr > 220) {
      return 'Nilai tidak valid (30-220 bpm)';
    }

    return null;
  }

  /// Validate temperature
  static String? temperature(String? value) {
    if (value == null || value.isEmpty) {
      return 'Suhu tubuh tidak boleh kosong';
    }

    final temp = double.tryParse(value);
    if (temp == null) {
      return 'Harus berupa angka';
    }

    if (temp < 30.0 || temp > 45.0) {
      return 'Nilai tidak valid (30-45°C)';
    }

    return null;
  }

  /// Validate weight
  static String? weight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Berat badan tidak boleh kosong';
    }

    final weight = double.tryParse(value);
    if (weight == null) {
      return 'Harus berupa angka';
    }

    if (weight < 0.5 || weight > 500) {
      return 'Nilai tidak valid (0.5-500 kg)';
    }

    return null;
  }

  /// Validate height
  static String? height(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tinggi badan tidak boleh kosong';
    }

    final height = double.tryParse(value);
    if (height == null) {
      return 'Harus berupa angka';
    }

    if (height < 30 || height > 300) {
      return 'Nilai tidak valid (30-300 cm)';
    }

    return null;
  }

  /// Validate blood sugar
  static String? bloodSugar(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final sugar = int.tryParse(value);
    if (sugar == null) {
      return 'Harus berupa angka';
    }

    if (sugar < 0 || sugar > 600) {
      return 'Nilai tidak valid (0-600 mg/dL)';
    }

    return null;
  }

  /// Check if vital signs are in normal range (for warnings, not validation)
  static String? getVitalSignWarning({
    int? systolic,
    int? diastolic,
    int? heartRate,
    double? temperature,
  }) {
    final warnings = <String>[];

    if (systolic != null && (systolic < 90 || systolic > 140)) {
      warnings.add('Tekanan sistolik di luar normal (90-140)');
    }

    if (diastolic != null && (diastolic < 60 || diastolic > 90)) {
      warnings.add('Tekanan diastolik di luar normal (60-90)');
    }

    if (heartRate != null && (heartRate < 60 || heartRate > 100)) {
      warnings.add('Detak jantung di luar normal (60-100)');
    }

    if (temperature != null && (temperature < 36.0 || temperature > 37.5)) {
      warnings.add('Suhu tubuh di luar normal (36-37.5°C)');
    }

    return warnings.isEmpty ? null : warnings.join('\n');
  }
}
