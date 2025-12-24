/// Application-wide constants
class AppConstants {
  // App Info
  static const String appName = 'SiKespa';
  static const String appFullName = 'Sistem Kesehatan Pasien';
  static const String appVersion = '1.0.0';

  // User Roles
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleAdmin = 'admin';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String patientsCollection = 'patients';

  // Firestore Subcollections
  static const String vitalSignsSubcollection = 'vitalSigns';
  static const String medicalRecordsSubcollection = 'medicalRecords';
  static const String treatmentHistorySubcollection = 'treatmentHistory';
  static const String schedulesSubcollection = 'schedules';

  // Storage Paths
  static const String profilePhotosPath = 'profile_photos';
  static const String medicalDocumentsPath = 'medical_documents';

  // Notification Channels
  static const String mainChannelId = 'sikespa_channel';
  static const String mainChannelName = 'SIKESPA Notifications';
  static const String mainChannelDescription =
      'Notifications for SIKESPA health app';

  static const String medicationChannelId = 'medication_channel';
  static const String medicationChannelName = 'Medication Reminders';
  static const String medicationChannelDescription =
      'Reminders for medication schedule';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 50;

  // Schedule Types
  static const String scheduleTypeConsultation = 'consultation';
  static const String scheduleTypeMedication = 'medication';

  // Blood Types
  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;

  // Timeouts
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);

  // Date Formats
  static const String dateFormat = 'dd MMMM yyyy';
  static const String dateTimeFormat = 'dd MMMM yyyy, HH:mm';
  static const String timeFormat = 'HH:mm';
}
