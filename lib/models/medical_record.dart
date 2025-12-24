class MedicalRecord {
  final String id;
  final String patientId;
  final DateTime date;
  final String diagnosis;
  final String labResults;
  final String prescription;
  final String doctorName;
  final String hospitalName;
  final List<String> documents; // URLs to Firebase Storage

  MedicalRecord({
    required this.id,
    required this.patientId,
    required this.date,
    required this.diagnosis,
    required this.labResults,
    required this.prescription,
    required this.doctorName,
    required this.hospitalName,
    required this.documents,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'labResults': labResults,
      'prescription': prescription,
      'doctorName': doctorName,
      'hospitalName': hospitalName,
      'documents': documents,
    };
  }

  factory MedicalRecord.fromMap(Map<String, dynamic> map, String documentId) {
    return MedicalRecord(
      id: documentId,
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      diagnosis: map['diagnosis'] ?? '',
      labResults: map['labResults'] ?? '',
      prescription: map['prescription'] ?? '',
      doctorName: map['doctorName'] ?? '',
      hospitalName: map['hospitalName'] ?? '',
      documents: List<String>.from(map['documents'] ?? []),
    );
  }
}
