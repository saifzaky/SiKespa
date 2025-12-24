class VitalSigns {
  final String id;
  final String patientId;
  final DateTime date;
  final String bloodPressure; // e.g., "120/80"
  final double bloodSugar;
  final double weight;
  final String? notes;

  VitalSigns({
    required this.id,
    required this.patientId,
    required this.date,
    required this.bloodPressure,
    required this.bloodSugar,
    required this.weight,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'patientId': patientId,
      'date': date.toIso8601String(),
      'bloodPressure': bloodPressure,
      'bloodSugar': bloodSugar,
      'weight': weight,
      'notes': notes,
    };
  }

  factory VitalSigns.fromMap(Map<String, dynamic> map, String documentId) {
    return VitalSigns(
      id: documentId,
      patientId: map['patientId'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      bloodPressure: map['bloodPressure'] ?? '',
      bloodSugar: (map['bloodSugar'] ?? 0.0).toDouble(),
      weight: (map['weight'] ?? 0.0).toDouble(),
      notes: map['notes'],
    );
  }

  // Helper to determine if vital signs are normal
  bool get isNormal {
    // Simple logic - can be customized
    final bp = bloodPressure.split('/');
    if (bp.length == 2) {
      final systolic = int.tryParse(bp[0]) ?? 0;
      final diastolic = int.tryParse(bp[1]) ?? 0;
      if (systolic < 90 || systolic > 140 || diastolic < 60 || diastolic > 90) {
        return false;
      }
    }

    if (bloodSugar < 70 || bloodSugar > 140) return false;

    return true;
  }

  String get statusText => isNormal ? 'Normal' : 'Perlu Perhatian';
}
