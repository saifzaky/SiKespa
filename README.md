# 🏥 SiKespa - Sistem Kesehatan Pasien

<p align="center">
  <img src="assets/images/logo_primary.png" alt="SiKespa Logo" width="150"/>
</p>

<p align="center">
  <strong>Aplikasi Mobile untuk Manajemen Kesehatan Pasien</strong><br/>
  Mengintegrasikan Rekam Medis Digital dengan Monitoring Kesehatan Real-Time
</p>

<p align="center">
  <strong>Platform:</strong> Flutter (Android & iOS)<br/>
  <strong>Version:</strong> 1.0.0<br/>
  <strong>Backend:</strong> Firebase
</p>

---

# 📖 DOKUMENTASI LENGKAP

## Daftar Isi

| No | Bagian | Deskripsi |
|----|--------|-----------|
| 1 | [Tentang Aplikasi](#1-tentang-aplikasi) | Apa itu SiKespa dan mengapa dibuat |
| 2 | [Fitur Aplikasi](#2-fitur-aplikasi) | Semua fitur yang tersedia |
| 3 | [Arsitektur Sistem](#3-arsitektur-sistem) | Bagaimana sistem bekerja |
| 4 | [Struktur Proyek](#4-struktur-proyek) | Penjelasan setiap folder dan file |
| 5 | [Cara Instalasi](#5-cara-instalasi) | Panduan lengkap setup proyek |
| 6 | [Konfigurasi Firebase](#6-konfigurasi-firebase) | Setup Firebase step-by-step |
| 7 | [Database & Data Model](#7-database--data-model) | Struktur data di Firestore |
| 8 | [Sistem Autentikasi](#8-sistem-autentikasi) | Login, Register, dan Role |
| 9 | [Penjelasan Modul](#9-penjelasan-modul) | Detail setiap modul aplikasi |
| 10 | [Development Guide](#10-development-guide) | Panduan untuk developer |
| 11 | [Build & Deploy](#11-build--deploy) | Cara build aplikasi |
| 12 | [Troubleshooting](#12-troubleshooting) | Solusi masalah umum |

---

# 1. TENTANG APLIKASI

## 1.1 Apa itu SiKespa?

**SiKespa** adalah singkatan dari **Sistem Kesehatan Pasien**. Ini adalah aplikasi mobile yang membantu:

- **Pasien** mengelola data kesehatan mereka sendiri
- **Dokter** memantau dan merawat pasien dengan lebih efisien
- **Admin** mengelola seluruh sistem dan data

## 1.2 Mengapa SiKespa Dibuat?

Aplikasi ini dibuat untuk menyelesaikan masalah berikut:

| Masalah | Solusi SiKespa |
|---------|---------------|
| Rekam medis berbentuk kertas mudah hilang | Rekam medis digital tersimpan aman di cloud |
| Pasien lupa jadwal minum obat | Pengingat otomatis dengan notifikasi |
| Sulit memantau perkembangan kesehatan | Grafik visual untuk monitoring vital signs |
| Dokter sulit mengakses riwayat pasien | Akses data pasien secara real-time |
| Data kesehatan tersebar di banyak tempat | Semua data terpusat dalam satu aplikasi |

## 1.3 Siapa yang Menggunakan?

Aplikasi ini memiliki **3 jenis pengguna** dengan akses berbeda:

```
┌─────────────────────────────────────────────────────────────┐
│                       PENGGUNA SIKESPA                       │
├───────────────────┬───────────────────┬─────────────────────┤
│      PASIEN       │      DOKTER       │       ADMIN         │
├───────────────────┼───────────────────┼─────────────────────┤
│ • Melihat data    │ • Melihat data    │ • Mengelola semua   │
│   kesehatan       │   semua pasien    │   data              │
│   pribadi         │                   │                     │
│                   │ • Membuat resep   │ • Menambah/hapus    │
│ • Input vital     │   obat            │   pasien            │
│   signs           │                   │                     │
│                   │ • Mencatat        │ • Melihat           │
│ • Melihat jadwal  │   diagnosis       │   statistik         │
│   & pengingat     │                   │                     │
└───────────────────┴───────────────────┴─────────────────────┘
```

---

# 2. FITUR APLIKASI

## 2.1 Fitur untuk Pasien

### A. Dashboard Kesehatan
**Lokasi:** `lib/screens/patient/dashboard_screen.dart`

Dashboard adalah halaman utama yang menampilkan ringkasan kesehatan pasien:
- Vital signs terbaru (tekanan darah, suhu, dll)
- Jadwal konsultasi mendatang
- Pengingat obat hari ini
- Akses cepat ke semua fitur

### B. Profil Pasien
**Lokasi:** `lib/screens/patient/profile_screen.dart`

Data profil yang disimpan:
| Field | Deskripsi | Contoh |
|-------|-----------|--------|
| Nama | Nama lengkap pasien | Budi Santoso |
| Umur | Usia dalam tahun | 35 |
| Jenis Kelamin | Laki-laki/Perempuan | Laki-laki |
| Golongan Darah | A, B, AB, atau O | B+ |
| Alergi | Daftar alergi obat/makanan | Penisilin, Seafood |
| Kontak Darurat | Nomor yang dihubungi saat darurat | 081234567890 |
| No. Asuransi | Nomor BPJS/asuransi | 0001234567 |
| Foto | Foto profil pasien | (URL gambar) |

### C. Monitoring Vital Signs (Tanda-tanda Vital)
**Lokasi:** 
- Riwayat: `lib/screens/patient/vital_signs_history_screen.dart`
- Input: `lib/screens/patient/add_vital_signs_screen.dart`

Vital signs yang bisa dicatat:
| Parameter | Satuan | Nilai Normal | Penjelasan |
|-----------|--------|--------------|------------|
| Tekanan Darah Sistolik | mmHg | 90-120 | Tekanan saat jantung memompa |
| Tekanan Darah Diastolik | mmHg | 60-80 | Tekanan saat jantung istirahat |
| Detak Jantung | BPM | 60-100 | Berapa kali jantung berdetak per menit |
| Suhu Tubuh | °C | 36.1-37.2 | Suhu tubuh normal |
| Saturasi Oksigen (SpO2) | % | 95-100 | Kadar oksigen dalam darah |
| Laju Pernapasan | x/menit | 12-20 | Berapa kali bernapas per menit |
| Berat Badan | kg | - | Berat badan saat ini |
| Tinggi Badan | cm | - | Tinggi badan |

**Fitur Grafik**: Data vital signs ditampilkan dalam grafik untuk melihat tren kesehatan dari waktu ke waktu.

### D. Rekam Medis
**Lokasi:** `lib/screens/patient/medical_records_screen.dart`

Pasien bisa melihat:
- Riwayat diagnosis penyakit
- Treatment/pengobatan yang diberikan
- Nama dokter yang menangani
- Tanggal pemeriksaan
- Dokumen lampiran (hasil lab, rontgen, dll)

### E. Jadwal & Kalender
**Lokasi:** `lib/screens/patient/schedule_screen.dart`

Menggunakan package `table_calendar` untuk menampilkan:
- Jadwal konsultasi dokter
- Jadwal minum obat
- Jadwal check-up rutin

### F. Pengingat Obat
**Lokasi:** 
- Daftar: `lib/screens/patient/medication_reminders_screen.dart`
- Tambah: `lib/screens/patient/add_medication_screen.dart`

Fitur notifikasi untuk mengingatkan:
- Nama obat yang harus diminum
- Waktu minum obat
- Dosis obat
- Notifikasi push ke handphone

---

## 2.2 Fitur untuk Dokter

### A. Dashboard Dokter
**Lokasi:** `lib/screens/doctor/doctor_dashboard_screen.dart`

Menampilkan:
- Daftar pasien yang ditangani
- Ringkasan kesehatan setiap pasien
- Akses cepat ke fitur dokter

### B. Detail Pasien
**Lokasi:** `lib/screens/doctor/doctor_patient_detail_screen.dart`

Dokter bisa melihat secara lengkap:
- Semua vital signs pasien
- Riwayat rekam medis
- Riwayat perawatan
- Resep obat sebelumnya

### C. Buat Resep Obat
**Lokasi:** `lib/screens/doctor/add_prescription_screen.dart`

Dokter bisa membuat resep dengan:
- Nama obat
- Dosis
- Frekuensi minum
- Durasi pengobatan
- Catatan khusus

### D. Catatan Perawatan
**Lokasi:** `lib/screens/doctor/add_treatment_note_screen.dart`

Dokter mencatat:
- Diagnosis penyakit
- Treatment yang diberikan
- Rekomendasi
- Follow-up yang diperlukan

---

## 2.3 Fitur untuk Admin

### A. Dashboard Admin
**Lokasi:** `lib/screens/admin/admin_dashboard.dart`

Menampilkan:
- Total jumlah pasien
- Total jumlah dokter
- Statistik penggunaan aplikasi
- Grafik dan chart

### B. Statistik & Analytics
**Lokasi:** `lib/screens/admin/statistics_screen.dart`

Menggunakan package `fl_chart` untuk menampilkan:
- Grafik jumlah pasien per bulan
- Distribusi penyakit
- Tren kesehatan

### C. Manajemen Pasien
**Lokasi:** `lib/screens/admin/manage_patients_screen.dart`

Fitur:
- Melihat daftar semua pasien
- Mencari pasien berdasarkan nama/ID
- Filter pasien berdasarkan kriteria

### D. CRUD Pasien (Create, Read, Update, Delete)
**Lokasi:**
- Tambah: `lib/screens/admin/add_patient_screen.dart`
- Edit: `lib/screens/admin/edit_patient_screen.dart`
- Detail: `lib/screens/admin/patient_detail_screen.dart`

Admin bisa:
- Menambah pasien baru ke sistem
- Mengedit data pasien
- Menghapus pasien
- Melihat detail lengkap pasien

### E. Tambah Rekam Medis
**Lokasi:** `lib/screens/admin/add_medical_record_screen.dart`

Admin bisa menambahkan rekam medis untuk pasien.

---

# 3. ARSITEKTUR SISTEM

## 3.1 Gambaran Umum

```
┌─────────────────────────────────────────────────────────────────┐
│                        APLIKASI SIKESPA                          │
│                      (Flutter Mobile App)                        │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              │ HTTPS/WebSocket
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         FIREBASE BACKEND                         │
├─────────────┬─────────────┬─────────────┬──────────────────────┤
│  Firebase   │   Cloud     │  Firebase   │     Firebase         │
│    Auth     │  Firestore  │  Storage    │     Messaging        │
├─────────────┼─────────────┼─────────────┼──────────────────────┤
│  Login &    │  Database   │   Upload    │   Push               │
│  Register   │  NoSQL      │   Files     │   Notification       │
└─────────────┴─────────────┴─────────────┴──────────────────────┘
```

## 3.2 Penjelasan Komponen

### A. Flutter (Frontend)
Flutter adalah framework untuk membuat aplikasi mobile. Dengan Flutter:
- Satu codebase untuk Android dan iOS
- UI yang responsif dan smooth
- Hot reload untuk development cepat

### B. Firebase Authentication
Menangani:
- **Login**: User masuk dengan email & password
- **Register**: Pendaftaran user baru
- **Logout**: Keluar dari aplikasi
- **Reset Password**: Lupa password

### C. Cloud Firestore
Database NoSQL yang menyimpan:
- Data user (nama, email, role)
- Data pasien (profil, vital signs)
- Rekam medis
- Jadwal & pengingat

Keunggulan Firestore:
- Real-time sync (data otomatis update)
- Offline support (bisa diakses tanpa internet)
- Scalable (bisa menampung banyak data)

### D. Firebase Storage
Untuk menyimpan file seperti:
- Foto profil pasien
- Dokumen hasil lab
- Gambar rontgen
- File PDF

### E. Firebase Messaging
Untuk mengirim notifikasi:
- Pengingat minum obat
- Jadwal konsultasi
- Peringatan kesehatan

## 3.3 Alur Data

```
USER INPUT                    PROCESSING                    STORAGE
    │                             │                            │
    ▼                             ▼                            ▼
┌─────────┐    submit      ┌───────────┐    save       ┌──────────┐
│  Form   │ ─────────────▶ │  Provider │ ────────────▶ │ Firestore│
│  (UI)   │                │  (State)  │               │ (Cloud)  │
└─────────┘                └───────────┘               └──────────┘
    ▲                             │                            │
    │         update UI           │         listen             │
    └─────────────────────────────┴────────────────────────────┘
```

**Penjelasan:**
1. User mengisi form di UI (misalnya input vital signs)
2. Data dikirim ke Provider untuk diproses
3. Provider menyimpan data ke Firestore
4. Firestore mengirim update ke Provider
5. UI otomatis terupdate dengan data terbaru

---

# 4. STRUKTUR PROYEK

## 4.1 Folder Utama

```
sisinfo/
├── android/          ← Konfigurasi Android
├── ios/              ← Konfigurasi iOS
├── lib/              ← SOURCE CODE UTAMA
├── assets/           ← Gambar, icon, font
├── test/             ← Unit test
├── pubspec.yaml      ← Daftar dependencies
└── README.md         ← Dokumentasi ini
```

## 4.2 Folder lib/ (Detail)

### A. models/ - Data Models
**Fungsi:** Mendefinisikan struktur data yang digunakan di aplikasi.

| File | Penjelasan |
|------|------------|
| `user_model.dart` | Model untuk data user (uid, email, name, role) |
| `patient_profile.dart` | Model untuk profil pasien lengkap |
| `vital_signs.dart` | Model untuk tanda-tanda vital |
| `medical_record.dart` | Model untuk rekam medis |
| `prescription.dart` | Model untuk resep obat |
| `schedule.dart` | Model untuk jadwal |
| `treatment_history.dart` | Model untuk riwayat perawatan |
| `treatment_note.dart` | Model untuk catatan dokter |
| `doctor_patient_assignment.dart` | Model penugasan dokter-pasien |

**Contoh User Model:**
```dart
class UserModel {
  final String uid;        // ID unik user
  final String email;      // Email untuk login
  final String name;       // Nama lengkap
  final String role;       // 'patient', 'doctor', atau 'admin'
  final DateTime createdAt; // Tanggal dibuat
}
```

### B. providers/ - State Management
**Fungsi:** Mengelola state (kondisi/data) aplikasi secara global.

| File | Penjelasan |
|------|------------|
| `auth_provider.dart` | Mengelola state login/logout, data user saat ini, loading state |
| `patient_provider.dart` | Mengelola data pasien yang sedang diakses |

**Bagaimana Provider Bekerja:**
```
┌──────────────┐     notify      ┌──────────────┐
│   Provider   │ ──────────────▶ │   Widgets    │
│   (State)    │                 │   (UI)       │
└──────────────┘                 └──────────────┘
       ▲                                │
       │            update              │
       └────────────────────────────────┘
```

Ketika data berubah di Provider, semua widget yang "mendengarkan" akan otomatis terupdate.

### C. services/ - Business Logic
**Fungsi:** Menangani logika bisnis dan komunikasi dengan Firebase.

| File | Penjelasan |
|------|------------|
| `auth_service.dart` | Login, register, logout, reset password |
| `firebase_service.dart` | Inisialisasi Firebase |
| `firestore_service.dart` | CRUD operasi ke database |
| `storage_service.dart` | Upload/download file |
| `notification_service.dart` | Push notification & local notification |
| `pdf_service.dart` | Generate laporan PDF |

**Contoh AuthService:**
```dart
class AuthService {
  // Login
  Future<UserModel> login(String email, String password);
  
  // Register
  Future<UserModel> register(String email, String password, String name);
  
  // Logout
  Future<void> logout();
  
  // Reset Password
  Future<void> resetPassword(String email);
}
```

### D. screens/ - Halaman UI
**Fungsi:** Menampilkan antarmuka pengguna.

Dibagi berdasarkan role:
```
screens/
├── auth/           ← Halaman login, register, lupa password
├── patient/        ← Halaman khusus pasien (9 screen)
├── doctor/         ← Halaman khusus dokter (4 screen)
├── admin/          ← Halaman khusus admin (7 screen)
├── home_screen.dart
└── splash_screen.dart
```

### E. utils/ - Utilities
**Fungsi:** Fungsi-fungsi pembantu yang digunakan di banyak tempat.

| File | Penjelasan |
|------|------------|
| `app_colors.dart` | Definisi warna aplikasi |
| `app_constants.dart` | Konstanta yang dipakai berulang |
| `app_text_styles.dart` | Style text standar |
| `validator.dart` | Validasi input form |
| `exceptions.dart` | Custom exception handling |
| `error_handler.dart` | Menangani error secara global |
| `result.dart` | Pattern untuk return value yang bisa error |
| `logger.dart` | Logging untuk debugging |

**Contoh Validator:**
```dart
class Validator {
  // Validasi email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    // Cek format email dengan regex
    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }
    return null; // null = valid
  }
}
```

### F. widgets/ - Komponen Reusable
**Fungsi:** Widget yang bisa dipakai ulang di berbagai tempat.

| File | Penjelasan |
|------|------------|
| `complete_profile_dialog.dart` | Dialog untuk melengkapi profil |
| `empty_state_widget.dart` | Tampilan ketika data kosong |
| `error_display_widget.dart` | Tampilan ketika terjadi error |
| `filter_dialog.dart` | Dialog untuk filter data |
| `vital_sign_card.dart` | Card untuk menampilkan satu vital sign |

---

# 5. CARA INSTALASI

## 5.1 Prasyarat (Prerequisites)

Sebelum mulai, pastikan sudah terinstall:

| Software | Versi Minimum | Cara Cek |
|----------|---------------|----------|
| Flutter SDK | >=3.4.3 | `flutter --version` |
| Dart SDK | (ikut Flutter) | `dart --version` |
| Android Studio | Latest | - |
| VS Code (opsional) | Latest | - |
| Git | Latest | `git --version` |

**Cek kesiapan Flutter:**
```bash
flutter doctor
```
Pastikan semua item ✓ (centang hijau).

## 5.2 Langkah Instalasi

### Step 1: Clone Repository
```bash
# Clone dari GitHub
git clone [URL_REPOSITORY]

# Masuk ke folder
cd sisinfo
```

### Step 2: Install Dependencies
```bash
# Install semua package yang dibutuhkan
flutter pub get
```

Perintah ini akan menginstall semua package yang ada di `pubspec.yaml`.

### Step 3: Setup Firebase
Lihat bagian [6. Konfigurasi Firebase](#6-konfigurasi-firebase) untuk panduan lengkap.

### Step 4: Jalankan Aplikasi
```bash
# Lihat device yang tersedia
flutter devices

# Jalankan di device/emulator
flutter run
```

**Shortcut saat running:**
| Tombol | Fungsi |
|--------|--------|
| r | Hot reload (refresh cepat) |
| R | Hot restart (restart penuh) |
| q | Quit (keluar) |

## 5.3 Troubleshooting Instalasi

**Masalah: Flutter command not found**
```bash
# Tambahkan Flutter ke PATH
export PATH="$PATH:[FLUTTER_FOLDER]/bin"
```

**Masalah: Android license not accepted**
```bash
flutter doctor --android-licenses
# Ketik 'y' untuk setiap pertanyaan
```

**Masalah: Dependency conflict**
```bash
flutter clean
flutter pub get
```

---

# 6. KONFIGURASI FIREBASE

## 6.1 Mengapa Firebase?

Firebase dipilih karena:
- ✅ Gratis untuk penggunaan kecil-menengah
- ✅ Real-time database (sync otomatis)
- ✅ Authentication siap pakai
- ✅ Cloud storage untuk file
- ✅ Push notification gratis

## 6.2 Langkah Setup Firebase

### Step 1: Buat Project Firebase

1. Buka **[Firebase Console](https://console.firebase.google.com)**
2. Login dengan akun Google
3. Klik **"Create a project"** atau **"Add project"**
4. Masukkan nama project: `SiKespa`
5. (Opsional) Enable Google Analytics
6. Klik **"Create project"**
7. Tunggu sampai selesai, lalu klik **"Continue"**

### Step 2: Aktifkan Authentication

1. Di sidebar kiri, klik **"Build" → "Authentication"**
2. Klik **"Get started"**
3. Pilih tab **"Sign-in method"**
4. Klik **"Email/Password"**
5. Toggle **"Enable"** ke ON
6. Klik **"Save"**

### Step 3: Buat Firestore Database

1. Di sidebar kiri, klik **"Build" → "Firestore Database"**
2. Klik **"Create database"**
3. Pilih **"Start in test mode"** (untuk development)
4. Pilih lokasi server terdekat (asia-southeast1 untuk Indonesia)
5. Klik **"Enable"**

### Step 4: Setup Firebase Storage

1. Di sidebar kiri, klik **"Build" → "Storage"**
2. Klik **"Get started"**
3. Pilih **"Start in test mode"**
4. Klik **"Next"** → **"Done"**

### Step 5: Tambahkan App Android

1. Di halaman Project Overview, klik **icon Android** (🤖)
2. Masukkan package name: `com.example.sikespa`
3. (Opsional) Masukkan nickname: `SiKespa Android`
4. (Opsional) Masukkan SHA-1 (untuk fitur tertentu)
5. Klik **"Register app"**
6. Download **`google-services.json`**
7. Letakkan file di: `android/app/google-services.json`
8. Klik **"Next"** → **"Next"** → **"Continue to console"**

### Step 6: Tambahkan App iOS (Opsional)

1. Di halaman Project Overview, klik **icon Apple** (🍎)
2. Masukkan Bundle ID: `com.example.sikespa`
3. Klik **"Register app"**
4. Download **`GoogleService-Info.plist`**
5. Letakkan file di: `ios/Runner/GoogleService-Info.plist`
6. Klik **"Next"** → **"Continue to console"**

### Step 7: Generate firebase_options.dart

```bash
# Install FlutterFire CLI (sekali saja)
dart pub global activate flutterfire_cli

# Configure (jalankan di folder project)
flutterfire configure
```

Ikuti instruksi yang muncul untuk memilih project Firebase.

File `lib/firebase_options.dart` akan otomatis terbuat.

### Step 8: Deploy Security Rules

```bash
# Install Firebase CLI (jika belum)
npm install -g firebase-tools

# Login ke Firebase
firebase login

# Deploy rules
firebase deploy --only firestore:rules
firebase deploy --only storage
```

---

# 7. DATABASE & DATA MODEL

## 7.1 Struktur Firestore

Firestore menggunakan struktur **Collection → Document → Field**.

```
FIRESTORE DATABASE
│
├── 📁 users (Collection)
│   │
│   ├── 📄 user_id_1 (Document)
│   │   ├── uid: "user_id_1"
│   │   ├── email: "john@example.com"
│   │   ├── name: "John Doe"
│   │   ├── role: "patient"
│   │   └── createdAt: 2024-01-01T00:00:00Z
│   │
│   └── 📄 user_id_2 (Document)
│       └── ... (field lainnya)
│
├── 📁 patients (Collection)
│   │
│   └── 📄 patient_id (Document)
│       ├── userId: "user_id_1"
│       ├── name: "John Doe"
│       ├── age: 35
│       ├── gender: "Laki-laki"
│       ├── bloodType: "B+"
│       ├── allergies: ["Penisilin", "Seafood"]
│       ├── emergencyContact: "081234567890"
│       ├── insuranceNumber: "BPJ123456"
│       ├── photoUrl: "https://..."
│       │
│       ├── 📁 vitalSigns (Subcollection)
│       │   └── 📄 vital_id
│       │       ├── systolicBP: 120
│       │       ├── diastolicBP: 80
│       │       ├── heartRate: 72
│       │       ├── temperature: 36.5
│       │       ├── oxygenSaturation: 98
│       │       ├── weight: 70
│       │       ├── height: 175
│       │       ├── notes: "Normal"
│       │       └── recordedAt: 2024-01-15T10:30:00Z
│       │
│       ├── 📁 medicalRecords (Subcollection)
│       │   └── 📄 record_id
│       │       ├── diagnosis: "Flu"
│       │       ├── treatment: "Istirahat, minum obat"
│       │       ├── doctorName: "Dr. Smith"
│       │       ├── notes: "Kontrol 1 minggu lagi"
│       │       ├── recordDate: 2024-01-10T00:00:00Z
│       │       └── createdAt: 2024-01-10T14:00:00Z
│       │
│       ├── 📁 treatmentHistory (Subcollection)
│       │   └── 📄 history_id
│       │       └── ... (field history)
│       │
│       └── 📁 schedules (Subcollection)
│           └── 📄 schedule_id
│               ├── title: "Minum Paracetamol"
│               ├── type: "medication"
│               ├── description: "1 tablet setelah makan"
│               ├── scheduledDateTime: 2024-01-20T08:00:00Z
│               ├── isCompleted: false
│               ├── hasReminder: true
│               └── createdAt: 2024-01-15T00:00:00Z
│
└── 📁 doctorPatientAssignments (Collection)
    └── 📄 assignment_id
        ├── doctorId: "doctor_user_id"
        └── patientId: "patient_user_id"
```

## 7.2 Penjelasan Setiap Collection

### Users Collection
Menyimpan data dasar semua user (pasien, dokter, admin).

| Field | Tipe | Penjelasan |
|-------|------|------------|
| uid | String | ID unik dari Firebase Auth |
| email | String | Email untuk login |
| name | String | Nama lengkap |
| role | String | "patient", "doctor", atau "admin" |
| createdAt | Timestamp | Waktu akun dibuat |

### Patients Collection
Menyimpan profil lengkap pasien.

| Field | Tipe | Penjelasan |
|-------|------|------------|
| userId | String | Reference ke users collection |
| name | String | Nama lengkap pasien |
| age | Number | Umur dalam tahun |
| gender | String | "Laki-laki" atau "Perempuan" |
| bloodType | String | A, B, AB, atau O (dengan +/-) |
| allergies | Array | Daftar alergi |
| emergencyContact | String | Nomor telepon darurat |
| insuranceNumber | String | Nomor BPJS/asuransi |
| photoUrl | String? | URL foto profil (opsional) |

### Vital Signs Subcollection
Data tanda-tanda vital pasien.

| Field | Tipe | Penjelasan |
|-------|------|------------|
| patientId | String | ID pasien |
| systolicBP | Number? | Tekanan darah sistolik (mmHg) |
| diastolicBP | Number? | Tekanan darah diastolik (mmHg) |
| heartRate | Number? | Detak jantung (BPM) |
| temperature | Number? | Suhu tubuh (°C) |
| oxygenSaturation | Number? | SpO2 (%) |
| respiratoryRate | Number? | Laju napas (x/menit) |
| weight | Number? | Berat badan (kg) |
| height | Number? | Tinggi badan (cm) |
| notes | String? | Catatan tambahan |
| recordedAt | Timestamp | Waktu pencatatan |

---

# 8. SISTEM AUTENTIKASI

## 8.1 Alur Login

```
┌──────────────┐     email/password     ┌──────────────┐
│    User      │ ─────────────────────▶ │   Firebase   │
│   (Login)    │                        │     Auth     │
└──────────────┘                        └──────────────┘
                                              │
                                              │ verified?
                                              ▼
                                        ┌──────────────┐
                                        │   Get User   │
                                        │    Data      │
                                        └──────────────┘
                                              │
                                              │ from Firestore
                                              ▼
                                        ┌──────────────┐
                                        │   Check      │
                                        │   Role       │
                                        └──────────────┘
                                              │
          ┌───────────────────────────────────┼───────────────────────────────────┐
          ▼                                   ▼                                   ▼
┌──────────────┐                    ┌──────────────┐                    ┌──────────────┐
│   Patient    │                    │   Doctor     │                    │    Admin     │
│  Dashboard   │                    │  Dashboard   │                    │  Dashboard   │
└──────────────┘                    └──────────────┘                    └──────────────┘
```

## 8.2 Role-Based Access Control

Setiap user memiliki role yang menentukan akses mereka:

### Pasien (role: "patient")
- ✅ Melihat data kesehatan sendiri
- ✅ Input vital signs sendiri
- ✅ Melihat rekam medis sendiri
- ✅ Mengatur jadwal & pengingat
- ❌ Tidak bisa akses data pasien lain
- ❌ Tidak bisa menambah rekam medis

### Dokter (role: "doctor")
- ✅ Melihat semua data pasien
- ✅ Menambah rekam medis
- ✅ Membuat resep
- ✅ Mencatat diagnosis
- ❌ Tidak bisa menghapus pasien
- ❌ Tidak bisa akses statistik admin

### Admin (role: "admin")
- ✅ Akses penuh ke semua data
- ✅ CRUD pasien
- ✅ Melihat statistik
- ✅ Mengelola user

## 8.3 Firestore Security Rules

Keamanan data dijaga dengan security rules:

```javascript
// Contoh rule untuk patients collection
match /patients/{patientId} {
  // Pasien hanya bisa baca data sendiri
  // Dokter bisa baca semua
  // Admin bisa baca semua
  allow read: if isOwner(patientId) || isDoctor() || isAdmin();
  
  // Hanya admin yang bisa create pasien
  allow create: if isAdmin();
  
  // Pasien bisa update data sendiri, admin bisa update semua
  allow update: if isOwner(patientId) || isAdmin();
  
  // Hanya admin yang bisa delete
  allow delete: if isAdmin();
}
```

## 8.4 Credentials Default (Development)

```
Email: admin@sikespa.com
Password: admin123
Role: admin
```

⚠️ **PENTING**: Ganti credentials ini sebelum production!

---

# 9. PENJELASAN MODUL

## 9.1 Modul Authentication

### Login Screen
**File:** `lib/screens/auth/login_screen.dart`

Komponen:
- Form email dan password
- Validasi input
- Tombol login
- Link ke register
- Link lupa password

### Register Screen
**File:** `lib/screens/auth/register_screen.dart`

Komponen:
- Form nama, email, password, konfirmasi password
- Dropdown pilih role (untuk development)
- Validasi semua field
- Tombol register

### Forgot Password Screen
**File:** `lib/screens/auth/forgot_password_screen.dart`

Komponen:
- Form email
- Tombol kirim link reset
- Firebase akan kirim email reset password

## 9.2 Modul Patient

### Alur Penggunaan

```
┌──────────────┐
│  Dashboard   │ ◀── Halaman utama pasien
└──────────────┘
       │
       ├──▶ Profile ─────────────▶ Edit profil
       │
       ├──▶ Vital Signs ─────────▶ Input vital signs baru
       │         │
       │         └──▶ History ───▶ Lihat grafik
       │
       ├──▶ Medical Records ─────▶ Lihat detail rekam medis
       │
       ├──▶ Treatment History ───▶ Lihat riwayat perawatan
       │
       ├──▶ Schedule ────────────▶ Lihat kalender
       │
       └──▶ Medication ──────────▶ Tambah pengingat obat
```

## 9.3 Modul Doctor

### Alur Penggunaan

```
┌──────────────────┐
│ Doctor Dashboard │
└──────────────────┘
         │
         └──▶ Pilih Pasien ──▶ Patient Detail
                                    │
                                    ├──▶ Lihat Vital Signs
                                    │
                                    ├──▶ Lihat Medical Records
                                    │
                                    ├──▶ Tambah Prescription
                                    │
                                    └──▶ Tambah Treatment Note
```

## 9.4 Modul Admin

### Alur Penggunaan

```
┌──────────────┐
│Admin Dashboard│
└──────────────┘
       │
       ├──▶ Statistics ──▶ Lihat grafik & analytics
       │
       └──▶ Manage Patients
                │
                ├──▶ Tambah Pasien Baru
                │
                ├──▶ Edit Pasien
                │
                ├──▶ Detail Pasien ──▶ Tambah Medical Record
                │
                └──▶ Hapus Pasien
```

---

# 10. DEVELOPMENT GUIDE

## 10.1 Coding Standards

### Penamaan File
- Gunakan **snake_case**: `user_model.dart`, `login_screen.dart`
- Nama deskriptif: `add_vital_signs_screen.dart`, bukan `add_vs.dart`

### Penamaan Class
- Gunakan **PascalCase**: `UserModel`, `LoginScreen`
- Suffix sesuai tipe:
  - Model: `UserModel`, `PatientProfile`
  - Screen: `LoginScreen`, `DashboardScreen`
  - Widget: `VitalSignCard`, `EmptyStateWidget`
  - Service: `AuthService`, `FirestoreService`
  - Provider: `AuthProvider`, `PatientProvider`

### Struktur Widget
```dart
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  // 1. Variables
  final _formKey = GlobalKey<FormState>();
  
  // 2. Init & Dispose
  @override
  void initState() {
    super.initState();
    // Initialize
  }
  
  @override
  void dispose() {
    // Cleanup
    super.dispose();
  }
  
  // 3. Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI
    );
  }
  
  // 4. Helper Methods
  Future<void> _handleSubmit() async {
    // Logic
  }
}
```

## 10.2 Command Cheatsheet

| Command | Fungsi |
|---------|--------|
| `flutter pub get` | Install dependencies |
| `flutter run` | Jalankan aplikasi |
| `flutter run -d chrome` | Jalankan di Chrome (web) |
| `flutter clean` | Bersihkan build cache |
| `flutter analyze` | Cek code quality |
| `dart format lib/` | Format semua file |
| `flutter test` | Jalankan unit test |
| `flutter build apk` | Build APK Android |

## 10.3 Debugging Tips

### Menggunakan Logger
```dart
import 'package:sikespa/utils/logger.dart';

// Debug log
AppLogger.d('Debug message');

// Info log
AppLogger.i('Info message');

// Warning log
AppLogger.w('Warning message');

// Error log
AppLogger.e('Error message', error: exception);
```

### Debug di Console
Gunakan Flutter DevTools:
```bash
flutter run --debug
# Tekan 'd' untuk buka DevTools
```

---

# 11. BUILD & DEPLOY

## 11.1 Build APK (Android)

### Debug Build (untuk testing)
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release Build (untuk production)
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (untuk Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

## 11.2 Build iOS

```bash
flutter build ios --release
```

Kemudian archive melalui Xcode.

## 11.3 Generate App Icon

```bash
flutter pub run flutter_launcher_icons
```

Pastikan konfigurasi di `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/logo_icon.png"
```

## 11.4 Pre-Release Checklist

- [ ] Update version di `pubspec.yaml`
- [ ] Test di semua device target
- [ ] Deploy Firebase Security Rules (production mode)
- [ ] Setup Firebase Crashlytics
- [ ] Prepare app store assets (screenshots, description, dll)
- [ ] Ganti default credentials
- [ ] Hapus semua debug/print statements

---

# 12. TROUBLESHOOTING

## 12.1 Masalah Umum & Solusi

### ❌ Error: Firebase not initialized

**Gejala:**
```
[core/no-app] No Firebase App '[DEFAULT]' has been created
```

**Solusi:**
```bash
flutter clean
flutter pub get
flutter run
```

Pastikan juga `Firebase.initializeApp()` dipanggil di `main.dart`.

---

### ❌ Error: Package tidak ditemukan

**Gejala:**
```
Could not find package "xxx" in ...
```

**Solusi:**
```bash
flutter pub get
# atau
flutter pub upgrade
```

---

### ❌ Error: Permission denied (Firestore)

**Gejala:**
```
[cloud_firestore/permission-denied] Missing or insufficient permissions
```

**Solusi:**
1. Pastikan user sudah login
2. Cek Firestore Security Rules
3. Pastikan rules mengizinkan operasi tersebut

---

### ❌ Error: Notification tidak muncul

**Gejala:**
Pengingat dibuat tapi notifikasi tidak muncul.

**Solusi:**
1. Cek permissions di AndroidManifest.xml:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

2. Pastikan timezone sudah diinisialisasi:
```dart
import 'package:timezone/data/latest.dart' as tz;
tz.initializeTimeZones();
```

---

### ❌ Error: Image picker tidak bisa pilih foto (iOS)

**Gejala:**
Crash atau error saat pilih foto di iOS.

**Solusi:**
Tambahkan ke `ios/Runner/Info.plist`:
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses ke galeri foto</string>
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses kamera</string>
```

---

### ❌ Error: Build failed (Android)

**Gejala:**
Build gagal dengan berbagai error.

**Solusi:**
```bash
# Bersihkan project
flutter clean

# Hapus cache build
cd android
./gradlew clean
cd ..

# Install ulang dependencies
flutter pub get

# Coba build lagi
flutter build apk
```

---

## 12.2 Kontak Support

Jika menemui masalah yang tidak bisa diselesaikan:
1. Buat issue di repository GitHub
2. Sertakan:
   - Error message lengkap
   - Langkah untuk reproduce
   - Output `flutter doctor`
   - Device/OS yang digunakan

---

# 📝 CHANGELOG

## Version 1.0.0 (2025-12-24)
- ✨ Initial release
- 🔐 Sistem authentication dengan Firebase Auth
- 📊 Dashboard untuk setiap role
- 📈 Monitoring vital signs dengan grafik
- 📅 Jadwal dengan kalender
- 💊 Pengingat obat dengan notifikasi
- 📄 Generate PDF laporan
- 🔒 Security rules untuk Firestore & Storage

---

# 👥 TIM PENGEMBANG

| Role | Nama |
|------|------|
| Developer | [Nama Developer] |
| UI/UX Designer | [Nama Designer] |
| Project Manager | [Nama PM] |
| Technical Auditor | Antigravity AI |

---

<p align="center">
  <strong>Made with ❤️ for better healthcare management</strong>
</p>

<p align="center">
  © 2025 SiKespa - All Rights Reserved
</p>
