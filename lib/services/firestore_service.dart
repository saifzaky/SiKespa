import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_profile.dart';
import '../models/vital_signs.dart';
import '../models/medical_record.dart';
import '../models/treatment_history.dart';
import '../models/schedule.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== PATIENT PROFILE ==========

  Future<void> createOrUpdatePatientProfile(PatientProfile profile) async {
    await _firestore
        .collection('patients')
        .doc(profile.userId)
        .set(profile.toMap());
  }

  Future<PatientProfile?> getPatientProfile(String userId) async {
    try {
      final doc = await _firestore.collection('patients').doc(userId).get();
      if (doc.exists) {
        return PatientProfile.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting patient profile: $e');
      return null;
    }
  }

  Stream<PatientProfile?> streamPatientProfile(String userId) {
    return _firestore.collection('patients').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return PatientProfile.fromMap(doc.data()!, doc.id);
      }
      return null;
    });
  }

  // ========== VITAL SIGNS ==========

  Future<void> addVitalSigns(VitalSigns vitalSigns) async {
    await _firestore
        .collection('patients')
        .doc(vitalSigns.patientId)
        .collection('vitalSigns')
        .add(vitalSigns.toMap());
  }

  Future<VitalSigns?> getLatestVitalSigns(String patientId) async {
    try {
      final query = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('vitalSigns')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return VitalSigns.fromMap(query.docs.first.data(), query.docs.first.id);
      }
      return null;
    } catch (e) {
      print('Error getting latest vital signs: $e');
      return null;
    }
  }

  Stream<List<VitalSigns>> streamVitalSigns(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('vitalSigns')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => VitalSigns.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ========== MEDICAL RECORDS ==========

  Future<void> addMedicalRecord(MedicalRecord record) async {
    await _firestore
        .collection('patients')
        .doc(record.patientId)
        .collection('medicalRecords')
        .add(record.toMap());
  }

  Future<void> updateMedicalRecord(MedicalRecord record) async {
    await _firestore
        .collection('patients')
        .doc(record.patientId)
        .collection('medicalRecords')
        .doc(record.id)
        .update(record.toMap());
  }

  Stream<List<MedicalRecord>> streamMedicalRecords(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('medicalRecords')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MedicalRecord.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ========== TREATMENT HISTORY ==========

  Future<void> addTreatmentHistory(TreatmentHistory history) async {
    await _firestore
        .collection('patients')
        .doc(history.patientId)
        .collection('treatmentHistory')
        .add(history.toMap());
  }

  Stream<List<TreatmentHistory>> streamTreatmentHistory(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('treatmentHistory')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TreatmentHistory.fromMap(doc.data(), doc.id))
            .toList());
  }

  // ========== SCHEDULES ==========

  Future<void> addSchedule(Schedule schedule) async {
    await _firestore
        .collection('patients')
        .doc(schedule.patientId)
        .collection('schedules')
        .add(schedule.toMap());
  }

  Future<void> updateSchedule(Schedule schedule) async {
    await _firestore
        .collection('patients')
        .doc(schedule.patientId)
        .collection('schedules')
        .doc(schedule.id)
        .update(schedule.toMap());
  }

  Future<void> deleteSchedule(String patientId, String scheduleId) async {
    await _firestore
        .collection('patients')
        .doc(patientId)
        .collection('schedules')
        .doc(scheduleId)
        .delete();
  }

  Stream<List<Schedule>> streamSchedules(String patientId) {
    return _firestore
        .collection('patients')
        .doc(patientId)
        .collection('schedules')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Schedule.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<List<Schedule>> getUpcomingSchedules(String patientId) async {
    try {
      final now = DateTime.now();
      final query = await _firestore
          .collection('patients')
          .doc(patientId)
          .collection('schedules')
          .where('date', isGreaterThanOrEqualTo: now.toIso8601String())
          .orderBy('date')
          .limit(5)
          .get();

      return query.docs
          .map((doc) => Schedule.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting upcoming schedules: $e');
      return [];
    }
  }

  // ========== ADMIN/DOCTOR FUNCTIONS ==========

  Future<List<PatientProfile>> getAllPatients() async {
    try {
      final query = await _firestore.collection('patients').get();
      return query.docs
          .map((doc) => PatientProfile.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error getting all patients: $e');
      return [];
    }
  }

  Stream<List<PatientProfile>> streamAllPatients() {
    return _firestore.collection('patients').snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => PatientProfile.fromMap(doc.data(), doc.id))
            .toList());
  }
}
