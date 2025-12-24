class TreatmentNote {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final DateTime date;
  final String diagnosis;
  final String treatment;
  final String followUpInstructions;
  final DateTime? nextAppointment;

  TreatmentNote({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    required this.followUpInstructions,
    this.nextAppointment,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'treatment': treatment,
      'followUpInstructions': followUpInstructions,
      'nextAppointment': nextAppointment?.toIso8601String(),
    };
  }

  // Create from Firestore Map
  factory TreatmentNote.fromMap(Map<String, dynamic> map) {
    return TreatmentNote(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      date: DateTime.parse(map['date']),
      diagnosis: map['diagnosis'] ?? '',
      treatment: map['treatment'] ?? '',
      followUpInstructions: map['followUpInstructions'] ?? '',
      nextAppointment: map['nextAppointment'] != null
          ? DateTime.parse(map['nextAppointment'])
          : null,
    );
  }

  // Copy with method
  TreatmentNote copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    DateTime? date,
    String? diagnosis,
    String? treatment,
    String? followUpInstructions,
    DateTime? nextAppointment,
  }) {
    return TreatmentNote(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      date: date ?? this.date,
      diagnosis: diagnosis ?? this.diagnosis,
      treatment: treatment ?? this.treatment,
      followUpInstructions: followUpInstructions ?? this.followUpInstructions,
      nextAppointment: nextAppointment ?? this.nextAppointment,
    );
  }

  // Check if follow-up is needed
  bool get needsFollowUp => nextAppointment != null;

  // Check if follow-up is overdue
  bool get isFollowUpOverdue {
    if (nextAppointment == null) return false;
    return DateTime.now().isAfter(nextAppointment!);
  }
}
