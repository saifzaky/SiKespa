class DoctorPatientAssignment {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime assignedDate;
  final bool isActive;
  final String? notes;

  DoctorPatientAssignment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.assignedDate,
    this.isActive = true,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'doctorId': doctorId,
      'patientId': patientId,
      'assignedDate': assignedDate.toIso8601String(),
      'isActive': isActive,
      'notes': notes,
    };
  }

  factory DoctorPatientAssignment.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    return DoctorPatientAssignment(
      id: documentId,
      doctorId: map['doctorId'] ?? '',
      patientId: map['patientId'] ?? '',
      assignedDate: DateTime.parse(
        map['assignedDate'] ?? DateTime.now().toIso8601String(),
      ),
      isActive: map['isActive'] ?? true,
      notes: map['notes'],
    );
  }
}
