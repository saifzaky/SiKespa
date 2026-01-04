# 📚 DOKUMENTASI ROADMAP PENGERJAAN SIKESPA

## Sistem Kesehatan Pasien - Panduan Pengembangan Lengkap

**Dokumen ini menjelaskan perjalanan lengkap pengembangan aplikasi SiKespa dari awal hingga selesai.**

---

# DAFTAR ISI

| Bagian | Judul | Halaman |
|--------|-------|---------|
| A | [Pendahuluan](#a-pendahuluan) | Latar belakang proyek |
| B | [Persiapan Proyek](#b-persiapan-proyek) | Tools dan environment |
| C | [Phase 1: Project Setup](#c-phase-1-project-setup) | Membuat proyek Flutter |
| D | [Phase 2: Firebase Setup](#d-phase-2-firebase-setup) | Konfigurasi Firebase |
| E | [Phase 3: Foundation](#e-phase-3-foundation) | Models, Utils, Constants |
| F | [Phase 4: Services](#f-phase-4-services) | Business Logic Layer |
| G | [Phase 5: Authentication](#g-phase-5-authentication) | Login & Register |
| H | [Phase 6: Patient Module](#h-phase-6-patient-module) | Modul Pasien |
| I | [Phase 7: Doctor Module](#i-phase-7-doctor-module) | Modul Dokter |
| J | [Phase 8: Admin Module](#j-phase-8-admin-module) | Modul Admin |
| K | [Phase 9: Widgets](#k-phase-9-widgets) | Komponen Reusable |
| L | [Phase 10: Polish](#l-phase-10-polish) | Optimasi & Testing |
| M | [Phase 11: Deployment](#m-phase-11-deployment) | Build & Release |

---

# A. PENDAHULUAN

## A.1 Latar Belakang

Proyek SiKespa (Sistem Kesehatan Pasien) dikembangkan untuk menjawab kebutuhan digitalisasi layanan kesehatan. Berikut adalah masalah yang ingin diselesaikan:

### Masalah yang Dihadapi

```
┌────────────────────────────────────────────────────────────────┐
│                    MASALAH SAAT INI                            │
├────────────────────────────────────────────────────────────────┤
│ 1. Rekam medis kertas mudah hilang dan rusak                   │
│ 2. Pasien sering lupa jadwal minum obat                        │
│ 3. Dokter kesulitan mengakses riwayat pasien                   │
│ 4. Data kesehatan tersebar di banyak tempat                    │
│ 5. Tidak ada monitoring kesehatan berkelanjutan                │
└────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌────────────────────────────────────────────────────────────────┐
│                    SOLUSI SIKESPA                              │
├────────────────────────────────────────────────────────────────┤
│ 1. Rekam medis digital tersimpan di cloud                      │
│ 2. Pengingat obat otomatis dengan notifikasi                   │
│ 3. Akses data pasien real-time untuk dokter                    │
│ 4. Semua data terpusat dalam satu aplikasi                     │
│ 5. Monitoring vital signs dengan grafik visual                 │
└────────────────────────────────────────────────────────────────┘
```

## A.2 Tujuan Proyek

1. **Untuk Pasien**: Memudahkan pengelolaan data kesehatan pribadi
2. **Untuk Dokter**: Mempercepat akses informasi pasien
3. **Untuk Admin**: Menyederhanakan manajemen sistem kesehatan

## A.3 Scope Proyek

### Yang Termasuk (In Scope)
- ✅ Sistem autentikasi multi-role
- ✅ Manajemen profil pasien
- ✅ Pencatatan vital signs
- ✅ Rekam medis digital
- ✅ Jadwal dan pengingat obat
- ✅ Dashboard untuk setiap role
- ✅ Statistik dan analytics

### Yang Tidak Termasuk (Out of Scope)
- ❌ Pembayaran online
- ❌ Video call konsultasi
- ❌ Integrasi dengan rumah sakit
- ❌ Resep elektronik ke apotek

## A.4 Timeline Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         TIMELINE PENGERJAAN                                  │
├───────┬─────────────────────┬─────────┬─────────────────────────────────────┤
│ Phase │ Nama                │ Durasi  │ Output                              │
├───────┼─────────────────────┼─────────┼─────────────────────────────────────┤
│   1   │ Project Setup       │ 1 hari  │ Flutter project, dependencies       │
│   2   │ Firebase Setup      │ 1 hari  │ Firebase project, config files      │
│   3   │ Foundation          │ 2 hari  │ Models, Utils, Constants            │
│   4   │ Services            │ 3 hari  │ Auth, Firestore, Storage services   │
│   5   │ Authentication      │ 2 hari  │ Login, Register, Role routing       │
│   6   │ Patient Module      │ 5 hari  │ 9 screens untuk pasien              │
│   7   │ Doctor Module       │ 3 hari  │ 4 screens untuk dokter              │
│   8   │ Admin Module        │ 4 hari  │ 7 screens untuk admin               │
│   9   │ Widgets             │ 2 hari  │ 5 reusable widgets                  │
│  10   │ Polish              │ 3 hari  │ Optimasi, testing, bug fixing       │
│  11   │ Deployment          │ 2 hari  │ Build APK, release                  │
├───────┼─────────────────────┼─────────┼─────────────────────────────────────┤
│ TOTAL │                     │ 28 hari │                                     │
└───────┴─────────────────────┴─────────┴─────────────────────────────────────┘
```

---

# B. PERSIAPAN PROYEK

## B.1 Tools yang Dibutuhkan

### Software Development
| Tool | Versi | Kegunaan | Download |
|------|-------|----------|----------|
| Flutter SDK | >=3.4.3 | Framework utama | flutter.dev |
| Dart SDK | (ikut Flutter) | Bahasa pemrograman | - |
| Android Studio | Latest | IDE + Android Emulator | developer.android.com |
| VS Code | Latest | Code editor alternatif | code.visualstudio.com |
| Git | Latest | Version control | git-scm.com |

### Firebase Tools
| Tool | Kegunaan | Instalasi |
|------|----------|-----------|
| Firebase CLI | Deploy rules | `npm install -g firebase-tools` |
| FlutterFire CLI | Generate config | `dart pub global activate flutterfire_cli` |

### Akun yang Dibutuhkan
1. **Google Account** - Untuk Firebase
2. **GitHub Account** - Untuk version control (opsional)
3. **Google Play Console** - Untuk publish ke Play Store (opsional)
4. **Apple Developer** - Untuk publish ke App Store (opsional)

## B.2 Verifikasi Environment

Sebelum mulai, jalankan perintah berikut:

```bash
# Cek Flutter
flutter --version
# Output: Flutter 3.x.x

# Cek Dart
dart --version
# Output: Dart SDK version: 3.x.x

# Cek kesiapan Flutter
flutter doctor
# Pastikan semua ✓ (centang hijau)
```

### Contoh Output flutter doctor yang Benar:
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.4.3, on macOS 14.0)
[✓] Android toolchain - develop for Android devices
[✓] Xcode - develop for iOS and macOS
[✓] Chrome - develop for the web
[✓] Android Studio
[✓] VS Code
[✓] Connected device (2 available)
[✓] Network resources

• No issues found!
```

---

# C. PHASE 1: PROJECT SETUP

## C.1 Membuat Proyek Flutter Baru

### Step 1: Buat Proyek
```bash
# Buat proyek dengan nama sikespa
flutter create sikespa

# Masuk ke folder proyek
cd sikespa
```

### Step 2: Struktur Awal Proyek
Setelah `flutter create`, struktur folder akan seperti ini:
```
sikespa/
├── android/              ← Konfigurasi Android native
├── ios/                  ← Konfigurasi iOS native
├── lib/                  ← SOURCE CODE UTAMA
│   └── main.dart         ← Entry point aplikasi
├── test/                 ← Unit tests
├── pubspec.yaml          ← Konfigurasi proyek & dependencies
└── README.md             ← Dokumentasi
```

## C.2 Konfigurasi pubspec.yaml

### Step 1: Buka pubspec.yaml

File ini berisi informasi proyek dan daftar dependencies (package yang dibutuhkan).

### Step 2: Edit pubspec.yaml

```yaml
name: sikespa
description: "Sistem Kesehatan Pasien - Medical Records Management"
publish_to: 'none'  # Tidak dipublish ke pub.dev
version: 1.0.0+1    # Format: major.minor.patch+buildNumber

# Versi SDK yang didukung
environment:
  sdk: '>=3.4.3 <4.0.0'

# DEPENDENCIES - Package yang dibutuhkan
dependencies:
  flutter:
    sdk: flutter

  # ═══════════════════════════════════════════════════════
  # FIREBASE - Backend as a Service
  # ═══════════════════════════════════════════════════════
  firebase_core: ^3.8.1          # Core Firebase
  firebase_auth: ^5.3.4          # Authentication
  cloud_firestore: ^5.6.12       # NoSQL Database
  firebase_storage: ^12.3.4      # File Storage
  firebase_messaging: ^15.1.4    # Push Notification
  firebase_analytics: ^11.3.4    # Analytics (opsional)
  firebase_database: ^11.3.4     # Realtime DB (opsional)
  
  # ═══════════════════════════════════════════════════════
  # STATE MANAGEMENT
  # ═══════════════════════════════════════════════════════
  provider: ^6.1.2               # State management
  
  # ═══════════════════════════════════════════════════════
  # UI & UTILITIES
  # ═══════════════════════════════════════════════════════
  intl: ^0.19.0                  # Internationalization & date formatting
  cupertino_icons: ^1.0.6        # iOS style icons
  
  # ═══════════════════════════════════════════════════════
  # IMAGE & FILE HANDLING
  # ═══════════════════════════════════════════════════════
  image_picker: ^1.1.2           # Pilih foto dari galeri/kamera
  file_picker: ^8.1.6            # Pilih file dokumen
  cached_network_image: ^3.4.1   # Cache gambar dari internet
  
  # ═══════════════════════════════════════════════════════
  # NOTIFICATIONS
  # ═══════════════════════════════════════════════════════
  flutter_local_notifications: ^18.0.1  # Local notification
  
  # ═══════════════════════════════════════════════════════
  # CALENDAR & DATETIME
  # ═══════════════════════════════════════════════════════
  table_calendar: ^3.1.2         # Kalender widget
  timezone: ^0.9.4               # Timezone handling
  
  # ═══════════════════════════════════════════════════════
  # CHARTS & VISUALIZATION
  # ═══════════════════════════════════════════════════════
  fl_chart: ^0.70.2              # Grafik & chart
  
  # ═══════════════════════════════════════════════════════
  # PDF GENERATION
  # ═══════════════════════════════════════════════════════
  pdf: ^3.11.1                   # Generate PDF
  printing: ^5.13.4              # Print PDF
  
  # ═══════════════════════════════════════════════════════
  # UTILITIES
  # ═══════════════════════════════════════════════════════
  path: ^1.9.0                   # Path manipulation
  logger: ^2.0.2                 # Logging untuk debugging

# DEV DEPENDENCIES - Hanya untuk development
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0          # Linting rules
  flutter_launcher_icons: ^0.13.1 # Generate app icons

# FLUTTER CONFIGURATION
flutter:
  uses-material-design: true
  
  # Assets (gambar, font, dll)
  assets:
    - assets/images/logo_primary.png
    - assets/images/logo_icon.png
    - assets/images/logo_horizontal.png
```

### Step 3: Install Dependencies

```bash
flutter pub get
```

Perintah ini akan mendownload semua package yang didefinisikan di pubspec.yaml.

## C.3 Membuat Struktur Folder

### Step 1: Buat Folder-folder

```bash
# Buat folder untuk source code
mkdir -p lib/models
mkdir -p lib/providers
mkdir -p lib/screens/auth
mkdir -p lib/screens/patient
mkdir -p lib/screens/doctor
mkdir -p lib/screens/admin
mkdir -p lib/screens/common
mkdir -p lib/services
mkdir -p lib/utils
mkdir -p lib/widgets

# Buat folder untuk assets
mkdir -p assets/images
mkdir -p assets/fonts
```

### Step 2: Struktur Akhir

```
lib/
├── main.dart                    # Entry point
├── firebase_options.dart        # Firebase config (auto-generated)
│
├── models/                      # Data models
│   ├── user_model.dart
│   ├── patient_profile.dart
│   ├── vital_signs.dart
│   ├── medical_record.dart
│   ├── prescription.dart
│   ├── schedule.dart
│   ├── treatment_history.dart
│   ├── treatment_note.dart
│   └── doctor_patient_assignment.dart
│
├── providers/                   # State management
│   ├── auth_provider.dart
│   └── patient_provider.dart
│
├── screens/                     # UI Screens
│   ├── auth/
│   ├── patient/
│   ├── doctor/
│   ├── admin/
│   ├── common/
│   ├── home_screen.dart
│   └── splash_screen.dart
│
├── services/                    # Business logic
│   ├── auth_service.dart
│   ├── firebase_service.dart
│   ├── firestore_service.dart
│   ├── storage_service.dart
│   ├── notification_service.dart
│   └── pdf_service.dart
│
├── utils/                       # Utilities
│   ├── app_colors.dart
│   ├── app_constants.dart
│   ├── app_text_styles.dart
│   ├── validator.dart
│   ├── exceptions.dart
│   ├── error_handler.dart
│   ├── result.dart
│   └── logger.dart
│
└── widgets/                     # Reusable widgets
    ├── complete_profile_dialog.dart
    ├── empty_state_widget.dart
    ├── error_display_widget.dart
    ├── filter_dialog.dart
    └── vital_sign_card.dart
```

---

# D. PHASE 2: FIREBASE SETUP

## D.1 Membuat Firebase Project

### Step 1: Buka Firebase Console
1. Buka browser, akses: https://console.firebase.google.com
2. Login dengan akun Google

### Step 2: Buat Project Baru
1. Klik **"Create a project"** atau **"Add project"**
2. Masukkan nama project: **SiKespa**
3. Klik **"Continue"**
4. (Opsional) Enable Google Analytics
5. Klik **"Create project"**
6. Tunggu sampai selesai (~1-2 menit)
7. Klik **"Continue"**

## D.2 Mengaktifkan Firebase Services

### A. Authentication

```
Path: Build → Authentication → Get started
```

1. Di sidebar kiri, klik **"Build"**
2. Klik **"Authentication"**
3. Klik **"Get started"**
4. Pilih tab **"Sign-in method"**
5. Klik **"Email/Password"**
6. Toggle **"Enable"** ke ON
7. Klik **"Save"**

### B. Cloud Firestore

```
Path: Build → Firestore Database → Create database
```

1. Klik **"Build" → "Firestore Database"**
2. Klik **"Create database"**
3. Pilih **"Start in test mode"** (untuk development)
   ```
   ⚠️ Test mode memiliki waktu kedaluwarsa (30 hari)
   Nanti kita akan set security rules proper
   ```
4. Pilih lokasi server: **asia-southeast1** (Singapore, terdekat untuk Indonesia)
5. Klik **"Enable"**

### C. Firebase Storage

```
Path: Build → Storage → Get started
```

1. Klik **"Build" → "Storage"**
2. Klik **"Get started"**
3. Pilih **"Start in test mode"**
4. Klik **"Next"**
5. Pilih lokasi (sama dengan Firestore)
6. Klik **"Done"**

### D. Firebase Messaging (Opsional)

```
Path: Engage → Messaging
```

1. Klik **"Engage" → "Messaging"**
2. Ikuti wizard untuk setup

## D.3 Menambahkan App ke Firebase

### Untuk Android

1. Di halaman **Project Overview**, klik icon **Android** (🤖)
2. Masukkan informasi:
   - **Android package name**: `com.example.sikespa`
   - **App nickname**: `SiKespa Android`
   - **Debug signing certificate SHA-1**: (opsional, untuk Google Sign-In)
3. Klik **"Register app"**
4. Download **`google-services.json`**
5. Pindahkan file ke: `android/app/google-services.json`
6. Klik **"Next"** → **"Next"** → **"Continue to console"**

### Untuk iOS (Jika dibutuhkan)

1. Di halaman **Project Overview**, klik icon **Apple** (🍎)
2. Masukkan informasi:
   - **iOS bundle ID**: `com.example.sikespa`
   - **App nickname**: `SiKespa iOS`
3. Klik **"Register app"**
4. Download **`GoogleService-Info.plist`**
5. Pindahkan file ke: `ios/Runner/GoogleService-Info.plist`
6. Klik **"Next"** → **"Continue to console"**

## D.4 Generate firebase_options.dart

### Step 1: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Step 2: Configure

```bash
flutterfire configure
```

Ikuti prompt yang muncul:
1. Pilih Firebase project yang sudah dibuat
2. Pilih platform (Android, iOS, web)
3. File `lib/firebase_options.dart` akan otomatis dibuat

### Step 3: Verifikasi

Buka `lib/firebase_options.dart` dan pastikan terisi dengan konfigurasi project Anda.

## D.5 Setup Security Rules

### Firestore Rules

Buat file `firestore.rules` di root project:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    function isAdmin() {
      return isAuthenticated() && getUserRole() == 'admin';
    }
    
    function isDoctor() {
      return isAuthenticated() && getUserRole() == 'doctor';
    }
    
    function isPatient() {
      return isAuthenticated() && getUserRole() == 'patient';
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }

    // Users Collection
    match /users/{userId} {
      allow read: if isAuthenticated() && (isOwner(userId) || isAdmin());
      allow create: if isAuthenticated();
      allow update: if isAuthenticated() && (isOwner(userId) || isAdmin());
      allow delete: if isAdmin();
    }
    
    // Patients Collection
    match /patients/{patientId} {
      allow read: if isAuthenticated() && 
                     (isOwner(patientId) || isDoctor() || isAdmin());
      allow create: if isAdmin();
      allow update: if isAuthenticated() && 
                       (isOwner(patientId) || isAdmin());
      allow delete: if isAdmin();
      
      // Vital Signs Subcollection
      match /vitalSigns/{signId} {
        allow read: if isAuthenticated() && 
                       (isOwner(patientId) || isDoctor() || isAdmin());
        allow create, update: if isAuthenticated() && 
                                 (isOwner(patientId) || isDoctor() || isAdmin());
        allow delete: if isAuthenticated() && 
                         (isOwner(patientId) || isAdmin());
      }
      
      // Medical Records Subcollection
      match /medicalRecords/{recordId} {
        allow read: if isAuthenticated() && 
                       (isOwner(patientId) || isDoctor() || isAdmin());
        allow create, update: if isAuthenticated() && 
                                 (isDoctor() || isAdmin());
        allow delete: if isAdmin();
      }
      
      // Schedules Subcollection
      match /schedules/{scheduleId} {
        allow read, create, update: if isAuthenticated() && 
                                       (isOwner(patientId) || isDoctor() || isAdmin());
        allow delete: if isAuthenticated() && 
                         (isOwner(patientId) || isAdmin());
      }
      
      // Treatment History Subcollection
      match /treatmentHistory/{historyId} {
        allow read: if isAuthenticated() && 
                       (isOwner(patientId) || isDoctor() || isAdmin());
        allow create, update: if isAuthenticated() && 
                                 (isDoctor() || isAdmin());
        allow delete: if isAdmin();
      }
    }
    
    // Doctor-Patient Assignments
    match /doctorPatientAssignments/{assignmentId} {
      allow read: if isAuthenticated();
      allow create, update, delete: if isAdmin();
    }
    
    // Default deny
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### Storage Rules

Buat file `storage.rules` di root project:

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    // Patient photos and documents
    match /patients/{patientId}/{allPaths=**} {
      // Anyone authenticated can read (for doctors viewing patient files)
      allow read: if isAuthenticated();
      
      // Only owner or admin can upload
      allow write: if isAuthenticated() && 
                      (isOwner(patientId) || 
                       get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // General uploads
    match /uploads/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isAuthenticated();
    }
  }
}
```

### Deploy Rules

```bash
# Login ke Firebase
firebase login

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage
```

---

# E. PHASE 3: FOUNDATION

## E.1 Membuat Utils (Utilities)

### A. app_colors.dart

**Path:** `lib/utils/app_colors.dart`

**Tujuan:** Mendefinisikan semua warna yang digunakan di aplikasi agar konsisten.

```dart
import 'package:flutter/material.dart';

/// Kelas yang berisi semua warna yang digunakan di aplikasi
class AppColors {
  // Private constructor - tidak bisa di-instantiate
  AppColors._();

  // ═══════════════════════════════════════════════════════
  // PRIMARY COLORS - Warna utama (Medical Blue)
  // ═══════════════════════════════════════════════════════
  static const Color primary = Color(0xFF2196F3);      // Biru utama
  static const Color primaryLight = Color(0xFF64B5F6); // Biru terang
  static const Color primaryDark = Color(0xFF1976D2);  // Biru gelap

  // ═══════════════════════════════════════════════════════
  // SECONDARY COLORS - Warna sekunder (Health Green)
  // ═══════════════════════════════════════════════════════
  static const Color secondary = Color(0xFF4CAF50);     // Hijau utama
  static const Color secondaryLight = Color(0xFF81C784); // Hijau terang

  // ═══════════════════════════════════════════════════════
  // SEMANTIC COLORS - Warna dengan makna tertentu
  // ═══════════════════════════════════════════════════════
  static const Color error = Color(0xFFF44336);    // Merah untuk error
  static const Color warning = Color(0xFFFF9800);  // Oranye untuk warning
  static const Color success = Color(0xFF4CAF50);  // Hijau untuk sukses
  static const Color info = Color(0xFF2196F3);     // Biru untuk informasi

  // ═══════════════════════════════════════════════════════
  // NEUTRAL COLORS - Warna netral
  // ═══════════════════════════════════════════════════════
  static const Color background = Color(0xFFF5F5F5);   // Abu-abu terang
  static const Color surface = Colors.white;            // Putih
  static const Color textPrimary = Color(0xFF212121);   // Hitam untuk teks utama
  static const Color textSecondary = Color(0xFF757575); // Abu-abu untuk teks sekunder
}
```

### B. app_constants.dart

**Path:** `lib/utils/app_constants.dart`

**Tujuan:** Menyimpan konstanta yang digunakan berulang kali.

```dart
/// Kelas yang berisi semua konstanta aplikasi
class AppConstants {
  // Private constructor
  AppConstants._();

  // ═══════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════
  static const String appName = 'SiKespa';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Sistem Kesehatan Pasien';

  // ═══════════════════════════════════════════════════════
  // FIRESTORE COLLECTIONS
  // ═══════════════════════════════════════════════════════
  static const String usersCollection = 'users';
  static const String patientsCollection = 'patients';
  static const String vitalSignsCollection = 'vitalSigns';
  static const String medicalRecordsCollection = 'medicalRecords';
  static const String schedulesCollection = 'schedules';
  static const String treatmentHistoryCollection = 'treatmentHistory';
  static const String doctorAssignmentsCollection = 'doctorPatientAssignments';

  // ═══════════════════════════════════════════════════════
  // USER ROLES
  // ═══════════════════════════════════════════════════════
  static const String rolePatient = 'patient';
  static const String roleDoctor = 'doctor';
  static const String roleAdmin = 'admin';

  // ═══════════════════════════════════════════════════════
  // DROPDOWN OPTIONS
  // ═══════════════════════════════════════════════════════
  static const List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  static const List<String> genders = ['Laki-laki', 'Perempuan'];
  static const List<String> scheduleTypes = ['consultation', 'medication', 'checkup'];

  // ═══════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════
  static const int minPasswordLength = 6;
  static const int maxNameLength = 100;
  static const int minAge = 0;
  static const int maxAge = 150;
}
```

### C. validator.dart

**Path:** `lib/utils/validator.dart`

**Tujuan:** Fungsi-fungsi untuk validasi input form.

```dart
/// Kelas untuk validasi input form
class Validator {
  // Private constructor
  Validator._();

  /// Validasi email
  /// Return null jika valid, return pesan error jika tidak valid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    // Pattern regex untuk email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    
    return null; // null = valid
  }

  /// Validasi password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    
    return null;
  }

  /// Validasi konfirmasi password
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != password) {
      return 'Password tidak cocok';
    }
    
    return null;
  }

  /// Validasi nama
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama tidak boleh kosong';
    }
    
    if (value.length < 2) {
      return 'Nama minimal 2 karakter';
    }
    
    if (value.length > 100) {
      return 'Nama maksimal 100 karakter';
    }
    
    return null;
  }

  /// Validasi nomor telepon
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    
    // Hapus karakter non-digit
    final digits = value.replaceAll(RegExp(r'\D'), '');
    
    if (digits.length < 10 || digits.length > 13) {
      return 'Nomor telepon tidak valid (10-13 digit)';
    }
    
    return null;
  }

  /// Validasi umur
  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Umur tidak boleh kosong';
    }
    
    final age = int.tryParse(value);
    
    if (age == null) {
      return 'Umur harus berupa angka';
    }
    
    if (age < 0 || age > 150) {
      return 'Umur tidak valid (0-150)';
    }
    
    return null;
  }

  /// Validasi field wajib (tidak boleh kosong)
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }
}
```

### D. logger.dart

**Path:** `lib/utils/logger.dart`

**Tujuan:** Utility untuk logging dan debugging.

```dart
import 'package:logger/logger.dart';

/// Logger wrapper untuk debugging
class AppLogger {
  // Private constructor
  AppLogger._();
  
  // Instance logger dengan konfigurasi custom
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,        // Jumlah method stack trace
      errorMethodCount: 8,   // Jumlah method untuk error
      lineLength: 120,       // Lebar garis
      colors: true,          // Warna di console
      printEmojis: true,     // Emoji untuk tipe log
      printTime: true,       // Timestamp
    ),
  );

  /// Debug log - untuk informasi debugging
  static void d(String message) {
    _logger.d(message);
  }

  /// Info log - untuk informasi umum
  static void i(String message) {
    _logger.i(message);
  }

  /// Warning log - untuk peringatan
  static void w(String message) {
    _logger.w(message);
  }

  /// Error log - untuk error
  static void e(String message, {dynamic error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
```

## E.2 Membuat Data Models

### A. user_model.dart

**Path:** `lib/models/user_model.dart`

```dart
/// Model untuk data user (semua role)
class UserModel {
  final String uid;        // ID unik dari Firebase Auth
  final String email;      // Email untuk login
  final String name;       // Nama lengkap
  final String role;       // 'patient', 'doctor', atau 'admin'
  final DateTime createdAt; // Waktu akun dibuat

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  /// Konversi ke Map untuk disimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Buat instance dari Map (data Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'patient',
      createdAt: DateTime.parse(
        map['createdAt'] ?? DateTime.now().toIso8601String()
      ),
    );
  }

  /// Copy dengan modifikasi
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### B. patient_profile.dart

**Path:** `lib/models/patient_profile.dart`

```dart
/// Model untuk profil lengkap pasien
class PatientProfile {
  final String id;              // ID dokumen Firestore
  final String userId;          // Reference ke users collection
  final String name;            // Nama lengkap
  final int age;                // Umur
  final String gender;          // Jenis kelamin
  final String bloodType;       // Golongan darah
  final List<String> allergies; // Daftar alergi
  final String emergencyContact; // Kontak darurat
  final String insuranceNumber; // Nomor asuransi/BPJS
  final String? photoUrl;       // URL foto profil (opsional)

  PatientProfile({
    required this.id,
    required this.userId,
    required this.name,
    required this.age,
    required this.gender,
    required this.bloodType,
    required this.allergies,
    required this.emergencyContact,
    required this.insuranceNumber,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'age': age,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'emergencyContact': emergencyContact,
      'insuranceNumber': insuranceNumber,
      'photoUrl': photoUrl,
    };
  }

  factory PatientProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return PatientProfile(
      id: documentId,
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? 'Laki-laki',
      bloodType: map['bloodType'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      emergencyContact: map['emergencyContact'] ?? '',
      insuranceNumber: map['insuranceNumber'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }

  PatientProfile copyWith({
    String? id,
    String? userId,
    String? name,
    int? age,
    String? gender,
    String? bloodType,
    List<String>? allergies,
    String? emergencyContact,
    String? insuranceNumber,
    String? photoUrl,
  }) {
    return PatientProfile(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      insuranceNumber: insuranceNumber ?? this.insuranceNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
```

### C. vital_signs.dart

**Path:** `lib/models/vital_signs.dart`

```dart
/// Model untuk tanda-tanda vital pasien
class VitalSigns {
  final String id;
  final String patientId;
  final double? systolicBP;       // Tekanan sistolik (mmHg)
  final double? diastolicBP;      // Tekanan diastolik (mmHg)
  final double? heartRate;        // Detak jantung (BPM)
  final double? temperature;      // Suhu tubuh (°C)
  final double? oxygenSaturation; // SpO2 (%)
  final double? respiratoryRate;  // Laju napas (x/menit)
  final double? weight;           // Berat badan (kg)
  final double? height;           // Tinggi badan (cm)
  final String? notes;            // Catatan tambahan
  final DateTime recordedAt;      // Waktu pencatatan

  VitalSigns({
    required this.id,
    required this.patientId,
    this.systolicBP,
    this.diastolicBP,
    this.heartRate,
    this.temperature,
    this.oxygenSaturation,
    this.respiratoryRate,
    this.weight,
    this.height,
    this.notes,
    required this.recordedAt,
  });

  /// Hitung BMI (Body Mass Index)
  double? get bmi {
    if (weight != null && height != null && height! > 0) {
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    }
    return null;
  }

  /// Kategori BMI
  String? get bmiCategory {
    final bmiValue = bmi;
    if (bmiValue == null) return null;
    
    if (bmiValue < 18.5) return 'Underweight';
    if (bmiValue < 25) return 'Normal';
    if (bmiValue < 30) return 'Overweight';
    return 'Obese';
  }

  /// Format tekanan darah
  String get bloodPressureDisplay {
    if (systolicBP != null && diastolicBP != null) {
      return '${systolicBP!.toInt()}/${diastolicBP!.toInt()} mmHg';
    }
    return '-';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'systolicBP': systolicBP,
      'diastolicBP': diastolicBP,
      'heartRate': heartRate,
      'temperature': temperature,
      'oxygenSaturation': oxygenSaturation,
      'respiratoryRate': respiratoryRate,
      'weight': weight,
      'height': height,
      'notes': notes,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map, String documentId) {
    return VitalSigns(
      id: documentId,
      patientId: map['patientId'] ?? '',
      systolicBP: map['systolicBP']?.toDouble(),
      diastolicBP: map['diastolicBP']?.toDouble(),
      heartRate: map['heartRate']?.toDouble(),
      temperature: map['temperature']?.toDouble(),
      oxygenSaturation: map['oxygenSaturation']?.toDouble(),
      respiratoryRate: map['respiratoryRate']?.toDouble(),
      weight: map['weight']?.toDouble(),
      height: map['height']?.toDouble(),
      notes: map['notes'],
      recordedAt: DateTime.parse(
        map['recordedAt'] ?? DateTime.now().toIso8601String()
      ),
    );
  }
}
```

---

# F. PHASE 4: SERVICES

## F.1 Auth Service

**Path:** `lib/services/auth_service.dart`

Menangani semua operasi autentikasi dengan Firebase Auth.

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utils/app_constants.dart';
import '../utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream untuk listen perubahan auth state
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // User saat ini
  User? get currentUser => _auth.currentUser;

  /// Login dengan email dan password
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.i('Attempting login for: $email');
      
      // Login ke Firebase Auth
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ambil data user dari Firestore
      DocumentSnapshot doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(result.user!.uid)
          .get();

      if (!doc.exists) {
        throw Exception('User data not found in database');
      }

      AppLogger.i('Login successful for: $email');
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } on FirebaseAuthException catch (e) {
      AppLogger.e('Login failed', error: e);
      throw _handleAuthException(e);
    }
  }

  /// Register user baru
  Future<UserModel> register({
    required String email,
    required String password,
    required String name,
    String role = 'patient',
  }) async {
    try {
      AppLogger.i('Attempting registration for: $email');
      
      // Buat user di Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Buat model user
      UserModel user = UserModel(
        uid: result.user!.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      );

      // Simpan ke Firestore
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toMap());

      AppLogger.i('Registration successful for: $email');
      return user;
    } on FirebaseAuthException catch (e) {
      AppLogger.e('Registration failed', error: e);
      throw _handleAuthException(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    AppLogger.i('Logging out user');
    await _auth.signOut();
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.i('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Ambil data user dari Firestore
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'user-not-found':
        return 'User tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'invalid-email':
        return 'Email tidak valid';
      case 'user-disabled':
        return 'Akun dinonaktifkan';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }
}
```

## F.2 Firestore Service

**Path:** `lib/services/firestore_service.dart`

Menangani semua operasi CRUD ke Cloud Firestore.

(Kode lengkap ada di proyek)

---

# G. PHASE 5: AUTHENTICATION

## G.1 Auth Provider

**Path:** `lib/providers/auth_provider.dart`

Provider untuk mengelola state autentikasi secara global.

## G.2 Login Screen

**Path:** `lib/screens/auth/login_screen.dart`

## G.3 Register Screen

**Path:** `lib/screens/auth/register_screen.dart`

## G.4 main.dart dengan Role Routing

**Path:** `lib/main.dart`

Routing berdasarkan role user setelah login:
- patient → Patient Dashboard
- doctor → Doctor Dashboard
- admin → Admin Dashboard

---

# H. PHASE 6: PATIENT MODULE

## H.1 Daftar Screen

| No | Screen | File | Deskripsi |
|----|--------|------|-----------|
| 1 | Dashboard | `dashboard_screen.dart` | Halaman utama pasien |
| 2 | Profile | `profile_screen.dart` | Data profil pasien |
| 3 | Vital Signs History | `vital_signs_history_screen.dart` | Riwayat vital signs |
| 4 | Add Vital Signs | `add_vital_signs_screen.dart` | Input vital signs baru |
| 5 | Medical Records | `medical_records_screen.dart` | Daftar rekam medis |
| 6 | Treatment History | `treatment_history_screen.dart` | Riwayat perawatan |
| 7 | Schedule | `schedule_screen.dart` | Jadwal dengan kalender |
| 8 | Medication Reminders | `medication_reminders_screen.dart` | Daftar pengingat obat |
| 9 | Add Medication | `add_medication_screen.dart` | Tambah pengingat obat |

## H.2 Alur Navigasi

```
Dashboard
    │
    ├── Profile ─────────────── Edit Profile
    │
    ├── Vital Signs ─────────── Add Vital Signs
    │       │
    │       └── History ──────── Detail + Chart
    │
    ├── Medical Records ──────── Record Detail
    │
    ├── Treatment History ────── History Detail
    │
    ├── Schedule ─────────────── Calendar View
    │
    └── Medication ───────────── Add Medication
```

---

# I. PHASE 7: DOCTOR MODULE

## I.1 Daftar Screen

| No | Screen | File | Deskripsi |
|----|--------|------|-----------|
| 1 | Doctor Dashboard | `doctor_dashboard_screen.dart` | Halaman utama dokter |
| 2 | Patient Detail | `doctor_patient_detail_screen.dart` | Detail lengkap pasien |
| 3 | Add Prescription | `add_prescription_screen.dart` | Buat resep obat |
| 4 | Add Treatment Note | `add_treatment_note_screen.dart` | Catatan perawatan |

---

# J. PHASE 8: ADMIN MODULE

## J.1 Daftar Screen

| No | Screen | File | Deskripsi |
|----|--------|------|-----------|
| 1 | Admin Dashboard | `admin_dashboard.dart` | Halaman utama admin |
| 2 | Statistics | `statistics_screen.dart` | Statistik & chart |
| 3 | Manage Patients | `manage_patients_screen.dart` | Daftar semua pasien |
| 4 | Patient Detail | `patient_detail_screen.dart` | Detail pasien |
| 5 | Add Patient | `add_patient_screen.dart` | Tambah pasien baru |
| 6 | Edit Patient | `edit_patient_screen.dart` | Edit data pasien |
| 7 | Add Medical Record | `add_medical_record_screen.dart` | Tambah rekam medis |

---

# K. PHASE 9: WIDGETS

## K.1 Daftar Widget Reusable

| Widget | File | Kegunaan |
|--------|------|----------|
| Complete Profile Dialog | `complete_profile_dialog.dart` | Dialog untuk melengkapi profil |
| Empty State Widget | `empty_state_widget.dart` | Tampilan saat data kosong |
| Error Display Widget | `error_display_widget.dart` | Tampilan error dengan retry |
| Filter Dialog | `filter_dialog.dart` | Dialog filter data |
| Vital Sign Card | `vital_sign_card.dart` | Card untuk satu vital sign |

---

# L. PHASE 10: POLISH

## L.1 Optimasi

- [ ] Lazy loading untuk list panjang
- [ ] Image caching
- [ ] Pagination
- [ ] Offline support

## L.2 Testing

```bash
# Unit test
flutter test

# Widget test
flutter test test/widget_test.dart
```

## L.3 Bug Fixing

- Review semua flow
- Test di berbagai device
- Fix edge cases

---

# M. PHASE 11: DEPLOYMENT

## M.1 Pre-Release Checklist

- [ ] Update version di pubspec.yaml
- [ ] Deploy Firebase security rules (production)
- [ ] Generate app icons
- [ ] Prepare screenshots
- [ ] Write app description
- [ ] Test final build

## M.2 Build Commands

```bash
# Android APK
flutter build apk --release

# App Bundle untuk Play Store
flutter build appbundle --release

# iOS
flutter build ios --release
```

## M.3 Publish

- Google Play Store: Upload .aab file
- Apple App Store: Archive via Xcode

---

# 📝 CHANGELOG

| Version | Tanggal | Perubahan |
|---------|---------|-----------|
| 1.0.0 | 2025-12-24 | Initial release |

---

**Dokumen ini dibuat untuk memudahkan pemahaman dan pengembangan aplikasi SiKespa.**

<p align="center">
  Made with ❤️ for better healthcare management
</p>
