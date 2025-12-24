class TreatmentHistory {
  final String id;
  final String patientId;
  final DateTime date;
  final String hospitalName;
  final String doctorName;
  final String examinationType;
  final String diagnosis;
  final List<String> documents;

  TreatmentHistory({
    required this.id,
    required this.patientId,
    required this.date,
    required this.hospitalName,
    required this.doctorName,
    required this.examinationType,
    required this.diagnosis,
    required this.documents,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'date': date.toIso8601String(),
      'hospitalName': hospitalName,
      'doctorName': doctorName,
      'examinationType': examinationType,
      'diagnosis': diagnosis,
      'documents': documents,
    };
  }

  factory TreatmentHistory.fromMap(
      Map<String, dynamic> map, String documentId) {
    return TreatmentHistory(
      id: documentId,
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      hospitalName: map['hospitalName'] ?? '',
      doctorName: map['doctorName'] ?? '',
      examinationType: map['examinationType'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      documents: List<String>.from(map['documents'] ?? []),
    );
  }
}
