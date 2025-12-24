import 'package:flutter/material.dart';
import '../models/patient_profile.dart';
import '../models/vital_signs.dart';
import '../services/firestore_service.dart';

class PatientProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  PatientProfile? _currentProfile;
  VitalSigns? _latestVitalSigns;
  bool _isLoading = false;

  PatientProfile? get currentProfile => _currentProfile;
  VitalSigns? get latestVitalSigns => _latestVitalSigns;
  bool get isLoading => _isLoading;

  Future<void> loadPatientData(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentProfile = await _firestoreService.getPatientProfile(userId);
      if (_currentProfile != null) {
        _latestVitalSigns = await _firestoreService.getLatestVitalSigns(userId);
      }
    } catch (e) {
      print('Error loading patient data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(PatientProfile profile) async {
    await _firestoreService.createOrUpdatePatientProfile(profile);
    _currentProfile = profile;
    notifyListeners();
  }

  Future<void> addVitalSigns(String userId, VitalSigns vitalSigns) async {
    await _firestoreService.addVitalSigns(userId, vitalSigns);
    _latestVitalSigns = vitalSigns;
    notifyListeners();
  }
}
