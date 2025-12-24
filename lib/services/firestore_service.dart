import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/patient_profile.dart';
import '../models/vital_signs.dart';
import '../models/medical_record.dart';
import '../models/treatment_history.dart';
import '../models/schedule.dart';
import '../models/prescription.dart';
import '../models/treatment_note.dart';

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

  Future<void> addVitalSigns(String userId, VitalSigns vitalSigns) async {
    await _firestore
        .collection('patients')
        .doc(userId)
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

  Future<void> deletePatient(String userId) async {
    try {
      // Delete patient document
      await _firestore.collection('patients').doc(userId).delete();

      // Note: Firestore doesn't delete subcollections automatically
      // In production, you should use a Cloud Function to clean up subcollections
      print('Patient deleted: $userId');
    } catch (e) {
      print('Error deleting patient: $e');
      rethrow;
    }
  }

  // ========== PRESCRIPTIONS ==========

  Future<void> addPrescription(Prescription prescription) async {
    await _firestore
        .collection('prescriptions')
        .doc(prescription.id)
        .set(prescription.toMap());
  }

  Future<void> updatePrescription(Prescription prescription) async {
    await _firestore
        .collection('prescriptions')
        .doc(prescription.id)
        .update(prescription.toMap());
  }

  Future<void> deletePrescription(String prescriptionId) async {
    await _firestore.collection('prescriptions').doc(prescriptionId).delete();
  }

  // Get prescriptions for a patient
  Stream<List<Prescription>> streamPatientPrescriptions(String patientId) {
    return _firestore
        .collection('prescriptions')
        .where('patientId', isEqualTo: patientId)
        .orderBy('prescribedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Prescription.fromMap(doc.data()))
            .toList());
  }

  // Get active prescriptions for a patient
  Future<List<Prescription>> getActivePrescriptions(String patientId) async {
    try {
      final query = await _firestore
          .collection('prescriptions')
          .where('patientId', isEqualTo: patientId)
          .where('isActive', isEqualTo: true)
          .orderBy('prescribedDate', descending: true)
          .get();

      return query.docs
          .map((doc) => Prescription.fromMap(doc.data()))
          .where((p) => !p.isExpired)
          .toList();
    } catch (e) {
      print('Error getting active prescriptions: $e');
      return [];
    }
  }

  // Get prescriptions by doctor
  Stream<List<Prescription>> streamDoctorPrescriptions(String doctorId) {
    return _firestore
        .collection('prescriptions')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('prescribedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Prescription.fromMap(doc.data()))
            .toList());
  }

  // ========== TREATMENT NOTES ==========

  Future<void> addTreatmentNote(TreatmentNote note) async {
    await _firestore
        .collection('treatment_notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Future<void> updateTreatmentNote(TreatmentNote note) async {
    await _firestore
        .collection('treatment_notes')
        .doc(note.id)
        .update(note.toMap());
  }

  Future<void> deleteTreatmentNote(String noteId) async {
    await _firestore.collection('treatment_notes').doc(noteId).delete();
  }

  // Get treatment notes for a patient
  Stream<List<TreatmentNote>> streamPatientTreatmentNotes(String patientId) {
    return _firestore
        .collection('treatment_notes')
        .where('patientId', isEqualTo: patientId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TreatmentNote.fromMap(doc.data()))
            .toList());
  }

  // Get treatment notes by doctor
  Stream<List<TreatmentNote>> streamDoctorTreatmentNotes(String doctorId) {
    return _firestore
        .collection('treatment_notes')
        .where('doctorId', isEqualTo: doctorId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TreatmentNote.fromMap(doc.data()))
            .toList());
  }

  // Get latest treatment note for a patient
  Future<TreatmentNote?> getLatestTreatmentNote(String patientId) async {
    try {
      final query = await _firestore
          .collection('treatment_notes')
          .where('patientId', isEqualTo: patientId)
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        return TreatmentNote.fromMap(query.docs.first.data());
      }
      return null;
    } catch (e) {
      print('Error getting latest treatment note: $e');
      return null;
    }
  }
}
