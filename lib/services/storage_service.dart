import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../utils/exceptions.dart';
import '../utils/logger.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload patient profile photo
  Future<String> uploadProfilePhoto(String userId, File imageFile) async {
    try {
      AppLogger.i('Uploading profile photo for user: $userId');

      final fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('profile_pictures/$userId/$fileName');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      AppLogger.i('Profile photo uploaded successfully');
      return downloadUrl;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error uploading profile photo', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error uploading profile photo', e, stackTrace);
      throw StorageException('Gagal mengunggah foto profil');
    }
  }

  // Upload medical document
  Future<String> uploadMedicalDocument(
    String patientId,
    File file,
    String recordType,
  ) async {
    try {
      AppLogger.i('Uploading medical document for patient: $patientId');

      final fileName =
          '${recordType}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref =
          _storage.ref().child('medical_documents/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      AppLogger.i('Medical document uploaded successfully');
      return downloadUrl;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error uploading medical document', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error uploading medical document', e, stackTrace);
      throw StorageException('Gagal mengunggah dokumen medis');
    }
  }

  // Upload treatment document
  Future<String> uploadTreatmentDocument(
    String patientId,
    File file,
  ) async {
    try {
      AppLogger.i('Uploading treatment document for patient: $patientId');

      final fileName =
          'treatment_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref = _storage.ref().child('prescriptions/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      AppLogger.i('Treatment document uploaded successfully');
      return downloadUrl;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error uploading treatment document', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e(
          'Unexpected error uploading treatment document', e, stackTrace);
      throw StorageException('Gagal mengunggah dokumen treatment');
    }
  }

  // Delete file
  Future<void> deleteFile(String downloadUrl) async {
    try {
      AppLogger.i('Deleting file from storage');

      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();

      AppLogger.i('File deleted successfully');
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error deleting file', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error deleting file', e, stackTrace);
      throw StorageException('Gagal menghapus file');
    }
  }

  // Upload lab result
  Future<String> uploadLabResult(String patientId, File file) async {
    try {
      AppLogger.i('Uploading lab result for patient: $patientId');

      final fileName =
          'lab_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref = _storage.ref().child('lab_results/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      AppLogger.i('Lab result uploaded successfully');
      return downloadUrl;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error uploading lab result', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error uploading lab result', e, stackTrace);
      throw StorageException('Gagal mengunggah hasil lab');
    }
  }

  // Upload X-ray image
  Future<String> uploadXRayImage(String patientId, File file) async {
    try {
      AppLogger.i('Uploading X-ray image for patient: $patientId');

      final fileName =
          'xray_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref = _storage.ref().child('xray_images/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      AppLogger.i('X-ray image uploaded successfully');
      return downloadUrl;
    } on FirebaseException catch (e, stackTrace) {
      AppLogger.e('Firebase error uploading X-ray image', e, stackTrace);
      throw StorageException.fromError(e);
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error uploading X-ray image', e, stackTrace);
      throw StorageException('Gagal mengunggah gambar X-ray');
    }
  }
}
