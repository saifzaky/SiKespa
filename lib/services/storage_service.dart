import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload patient profile photo
  Future<String?> uploadProfilePhoto(String userId, File imageFile) async {
    try {
      final fileName =
          'profile_${userId}_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final ref = _storage.ref().child('profile_photos/$fileName');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading profile photo: $e');
      return null;
    }
  }

  // Upload medical document
  Future<String?> uploadMedicalDocument(
    String patientId,
    File file,
    String recordType,
  ) async {
    try {
      final fileName =
          '${recordType}_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref =
          _storage.ref().child('medical_documents/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading medical document: $e');
      return null;
    }
  }

  // Upload treatment document
  Future<String?> uploadTreatmentDocument(
    String patientId,
    File file,
  ) async {
    try {
      final fileName =
          'treatment_${DateTime.now().millisecondsSinceEpoch}${path.extension(file.path)}';
      final ref =
          _storage.ref().child('treatment_documents/$patientId/$fileName');

      final uploadTask = ref.putFile(file);
      final snapshot = await uploadTask;

      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading treatment document: $e');
      return null;
    }
  }

  // Delete file
  Future<bool> deleteFile(String downloadUrl) async {
    try {
      final ref = _storage.refFromURL(downloadUrl);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }
}
