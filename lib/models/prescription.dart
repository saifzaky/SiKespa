class Prescription {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int durationDays;
  final String instructions;
  final DateTime prescribedDate;
  final DateTime expiryDate;
  final bool isActive;

  Prescription({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.instructions,
    required this.prescribedDate,
    required this.expiryDate,
    required this.isActive,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'durationDays': durationDays,
      'instructions': instructions,
      'prescribedDate': prescribedDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'isActive': isActive,
    };
  }

  // Create from Firestore Map
  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      patientName: map['patientName'] ?? '',
      doctorId: map['doctorId'] ?? '',
      doctorName: map['doctorName'] ?? '',
      medicationName: map['medicationName'] ?? '',
      dosage: map['dosage'] ?? '',
      frequency: map['frequency'] ?? '',
      durationDays: map['durationDays']?.toInt() ?? 0,
      instructions: map['instructions'] ?? '',
      prescribedDate: DateTime.parse(map['prescribedDate']),
      expiryDate: DateTime.parse(map['expiryDate']),
      isActive: map['isActive'] ?? true,
    );
  }

  // Copy with method for updates
  Prescription copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? doctorId,
    String? doctorName,
    String? medicationName,
    String? dosage,
    String? frequency,
    int? durationDays,
    String? instructions,
    DateTime? prescribedDate,
    DateTime? expiryDate,
    bool? isActive,
  }) {
    return Prescription(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      durationDays: durationDays ?? this.durationDays,
      instructions: instructions ?? this.instructions,
      prescribedDate: prescribedDate ?? this.prescribedDate,
      expiryDate: expiryDate ?? this.expiryDate,
      isActive: isActive ?? this.isActive,
    );
  }

  // Check if prescription is expired
  bool get isExpired => DateTime.now().isAfter(expiryDate);

  // Get days remaining
  int get daysRemaining {
    if (isExpired) return 0;
    return expiryDate.difference(DateTime.now()).inDays;
  }

  // Get status text
  String get statusText {
    if (!isActive) return 'Nonaktif';
    if (isExpired) return 'Kadaluarsa';
    if (daysRemaining <= 3) return 'Segera Habis';
    return 'Aktif';
  }
}
