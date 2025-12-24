# SiKespa - Sistem Kesehatan Pasien

![SiKespa Logo](assets/images/logo_primary.png)

**Platform:** Flutter Mobile Application  
**Version:** 1.0.0+1  
**Status:** Active Development

---

## 📋 Deskripsi

SiKespa (Sistem Kesehatan Pasien) adalah aplikasi mobile berbasis Flutter untuk manajemen kesehatan pasien yang mengintegrasikan sistem rekam medis digital dengan fitur monitoring kesehatan real-time. Aplikasi ini dirancang untuk memudahkan pasien dalam mengelola data kesehatan mereka dan membantu tenaga medis dalam memberikan pelayanan yang lebih baik.

### ✨ Fitur Utama

**Untuk Pasien:**
- 📱 Profil Pasien Lengkap (data pribadi, alergi, kontak darurat)
- 📊 Monitoring Vital Signs (tekanan darah, detak jantung, suhu, dll)
- 📝 Rekam Medis Digital
- 🏥 Riwayat Perawatan
- 📅 Jadwal  Konsultasi & Obat
- 🔔 Notifikasi Pengingat Obat
- 📄 Upload Dokumen Medis

**Untuk Dokter/Admin:**
- 👥 Daftar Pasien
- 🔍 Pencarian Pasien
- 📊 Dashboard Statistik
- ➕ Tambah Rekam Medis
- 👁️ Akses ke Semua Data Pasien

---

## 🏗️ Arsitektur

### Tech Stack
- **Framework:** Flutter (Dart)
- **Backend:** Firebase
  - Authentication
  - Cloud Firestore
  - Firebase Storage
  - Firebase Messaging (FCM)
  - Firebase Analytics
- **State Management:** Provider
- **Local Notifications:** flutter_local_notifications

### Project Structure
```
lib/
├── models/              # Data models
│   ├── user_model.dart
│   ├── patient_profile.dart
│   ├── medical_record.dart
│   ├── vital_signs.dart
│   ├── treatment_history.dart
│   └── schedule.dart
├── providers/           # State management
│   ├── auth_provider.dart
│   └── patient_provider.dart
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   ├── patient/        # Patient screens
│   └── admin/          # Admin screens
├── services/            # Business logic
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   └── notification_service.dart
├── utils/               # Utilities
│   ├── app_colors.dart
│   ├── app_constants.dart
│   ├── app_text_styles.dart
│   ├── validator.dart
│   ├── exceptions.dart
│   ├── result.dart
│   └── logger.dart
└── widgets/             # Reusable widgets
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.4.3 <4.0.0)
- Dart SDK
- Android Studio / VS Code
- Firebase Project

### Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd sisinfo
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Add Android/iOS apps in Firebase console
   - Download and place `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update `firebase_options.dart` with your Firebase config

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔐 Authentication

SiKespa menggunakan Firebase Authentication dengan role-based access control:

**Roles:**
- `patient` - Pasien (akses ke data pribadi)
- `doctor` - Dokter (akses ke semua pasien)
- `admin` - Admin (akses penuh)

**Default Credentials:**
```
Email: admin@sikespa.com
Password: admin123
Role: doctor
```

---

## 📦 Dependencies

### Main Dependencies
```yaml
firebase_core: ^3.8.1
firebase_auth: ^5.3.4
cloud_firestore: ^5.6.12
firebase_storage: ^12.3.4
firebase_messaging: ^15.1.4
provider: ^6.1.2
logger: ^2.0.2
```

### Complete list in `pubspec.yaml`

---

## 🎨 Branding

### Colors
- **Primary:** #2196F3 (Medical Blue)
- **Secondary:** #4CAF50 (Health Green)
- **Error:** #F44336 (Alert Red)
- **Warning:** #FF9800 (Warning Orange)

### Typography
- **Headings:** Poppins (Bold/SemiBold)
- **Body:** Inter (Regular/Medium)

See [Brand Guide](../brain/sikespa_brand_guide.md) for complete branding guidelines.

---

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/services/auth_service_test.dart

# Run with coverage
flutter test --coverage
```

---

## 📱 Build & Release

### Debug Build
```bash
flutter build apk --debug
```

### Release Build
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Generate App Icons
```bash
flutter pub add flutter_launcher_icons
flutter pub run flutter_launcher_icons
```

---

## 🔧 Configuration

### Environment Variables
Currently using single environment. For multiple environments:
1. Create `lib/config/environment.dart`
2. Add dev/staging/prod configs
3. Use `--dart-define` for builds

### Firebase Rules
See `firestore.rules` and `storage.rules` for security configuration.

---

## 📊 Firestore Data Structure

```
users/
  {userId}/
    - uid
    - email
    - name
    - role
    - createdAt

patients/
  {userId}/
    - profile data
    vitalSigns/
      - measurements
    medicalRecords/
      - records
    treatmentHistory/
      - history
    schedules/
      - appointments
```

---

## 🐛 Troubleshooting

### Common Issues

**1. Firebase not initialized**
```bash
flutter clean
flutter pub get
flutter run
```

**2. Logger package errors**
```bash
flutter pub get
flutter pub upgrade
```

**3. Permission denied (Firestore)**
- Check Firestore Security Rules
- Ensure user is authenticated

---

## 📝 Changelog

### Version 1.0.0 (2025-12-24)
- ✨ Initial release
- 🔐 Enhanced security with validation
- 🎨 Brand identity implementation
- 📊 Comprehensive audit and improvements
- 🐛 Bug fixes and optimizations

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

---

## 📄 License

This project is private and proprietary.

---

## 👥 Team

- **Developer:** [Your Name]
- **Auditor:** Antigravity AI

---

## 📞 Support

For issues or questions:
- Create an issue in the repository
- Contact: [your-email@example.com]

---

## 🙏 Acknowledgments

- Flutter Team
- Firebase Team
- All open-source contributors

---

**Made with ❤️ for better healthcare management**
